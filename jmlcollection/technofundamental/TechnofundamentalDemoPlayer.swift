//
//  DemoPlayer.swift
//  Nova19
//
//  Created by Chris Wood on 10/04/2019.
//  Copyright © 2019 Realtime Dreams. All rights reserved.
//

import Foundation
import MetalKit
import simd
import MetalPerformanceShaders

class TechnofundamentalDemoPlayer: NSObject, MTKViewDelegate {
	
	// Create the view and get the screen size
	#if os(iOS)
	
	var view = MTKView(frame: UIScreen.main.bounds)
	var size = UIScreen.main.bounds.size
	
	#elseif os(macOS)
	
	var view = MTKView(frame: NSRect(x: 100.0, y: 100.0, width: 640.0, height: 480.0))
	var size = NSScreen.main?.frame.size ?? CGSize(width: 1920.0, height: 1080.0)
	
	#endif
	
	var renderTargetWidth: CGFloat = 1920.0 {
		didSet {
			updateDrawableSize()
		}
	}
	var fps = 60
	
	// Create the metal device, command queue and pipeline state
	let dev = MTLCreateSystemDefaultDevice()
	var queue: MTLCommandQueue!
	var computePS = [MTLComputePipelineState]()
	
	// The time buffer just stores the current time (a float) to pass to the shader
	var time: Float = 0.0
	var timeBuffer: MTLBuffer?
	var activeScene = 0
	
	// If you want to chain your shader into metal performance shaders, declare them here:
	var mpsMedian: MPSImageMedian?
	
	let musicPlayer = TechnofundamentalMusicPlayer()
	var textureLoader: TechnofundamentalTextureLoader!
	
	var endDemoBlock: (() -> Void)?
	
	override init() {
		super.init()
		
		guard let device = dev else {
			return
		}
		
		#if os(iOS)
		renderTargetWidth = technoFundamentalConfig.iOSRenderTargetWidth
		fps = technoFundamentalConfig.iOSFPS
		#else
		
		#endif
		
		textureLoader = TechnofundamentalTextureLoader(dev: device)
		
		// Do any additional setup after loading the view.
		queue = device.makeCommandQueue()!
		
		// Set up the buffers to contain time and resolution
		timeBuffer = device.makeBuffer(length: MemoryLayout<Float>.size, options: [])
		
		// Create the library + compute function
		let lib = device.makeDefaultLibrary()!
		
		// Load all the scene shaders
		for i in 0..<technoFundamentalConfig.numberOfScenes {
			var sceneNo = Int32(i)
			let constants = MTLFunctionConstantValues.init()
			
			constants.setConstantValue(&sceneNo, type: .int, index: 0)
			
			do {
				let funcKernel = try lib.makeFunction(name: "demo", constantValues: constants)
				funcKernel.label = "\(sceneNo)"
				print("Loaded scene function \(funcKernel.label!)")
				let funcPS = try device.makeComputePipelineState(function: funcKernel)
				
				computePS.append(funcPS)
				
			} catch let e {
				print("Error building function \(i):\n\(e)")
			}
		}
		
		view.device = device
		
		updateDrawableSize()
		
		view.delegate = self
		self.view.framebufferOnly = false
		self.view.translatesAutoresizingMaskIntoConstraints = true
		self.view.autoResizeDrawable = false
		self.view.preferredFramesPerSecond = fps
		self.view.depthStencilPixelFormat = .invalid
		self.view.frame = self.view.bounds
		
		view.enableSetNeedsDisplay = false
		view.isPaused = false
		
		// Create any MPS shaders you want here:
		mpsMedian = MPSImageMedian(device: device, kernelDiameter: 3)
		
		// Set the view to auto-resize on macOS (view size won't change on iOS)
		#if os(macOS)
		self.view.autoresizingMask = [.width, .height]
		#endif
	}
	
	func startDemo() {
		// Just start the audio player. The shader is already rendering, so we just need to start the music which drives the timer.
		musicPlayer.startDemo()
	}
	
	func endDemo() {
		view.isPaused = true
		if let ender = endDemoBlock {
			ender()
		}
	}
	
	func updateDrawableSize() {
		// This sets the rendering size. It should set it to the size set in renderTargetWidth, with the correct aspect ratio for the screen.
		size = CGSize(width: renderTargetWidth, height: renderTargetWidth / (size.width / size.height))
		
		// Configure the rendering view
		view.drawableSize = size
	}
	
	func updateTime() {
		// Get the time from the music player and copy it into the time buffer
		guard let buffer = self.timeBuffer else { return }
		
		// Scale time by bpm so time is measured in beats
		time = max(0.0, musicPlayer.time * technoFundamentalConfig.bpm) // + 208.0
		
		// Finally get the active scene
		activeScene = 0
		
		for i in 0..<technoFundamentalConfig.sceneStartTime.count {
			if time > technoFundamentalConfig.sceneStartTime[i] {
				activeScene = i
//				break
			}
		}
		time -= technoFundamentalConfig.sceneStartTime[activeScene]
		activeScene += 1
		
		let bufferPointer = buffer.contents()
		memcpy(bufferPointer, &time, MemoryLayout<Float>.size)
		
	}
	
	func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
		return
	}
	
	func draw(in view: MTKView) {
		// Ensure we have a valid drawable and queue, or we can't draw
		guard let drawable = view.currentDrawable, let queue = self.queue else { return }
		
		updateTime()
		
		// Check for end time
		if activeScene == computePS.count {
			// The demo has ended
			endDemo()
			return
		}
		
		let pipe = computePS[activeScene]
		let commandBuffer = queue.makeCommandBuffer()
		
		// Make sure we can set up a rendering pipeline
		guard let buffer = commandBuffer, let cmdEncoder = buffer.makeComputeCommandEncoder() else {
			return
		}
		
		cmdEncoder.setComputePipelineState(pipe)
		
		// If we're using MPS for post processing, we need a temporary texture to render into. Create a texture description based on the current drawable surface:
		let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(
			pixelFormat: drawable.texture.pixelFormat,
			width: drawable.texture.width,
			height: drawable.texture.height,
			mipmapped: false
		)
		// We want to render into it and also read it back
		textureDescriptor.usage = [MTLTextureUsage.shaderWrite, MTLTextureUsage.shaderRead]
		
		// Make the texture
		let tex = dev!.makeTexture(descriptor: textureDescriptor)!
		
		// Set the texture and time buffer
		cmdEncoder.setTexture(tex, index: 0)
		cmdEncoder.setBuffer(timeBuffer!, offset: 0, index: 0)
		
		// Set any textures dependent on what scene we're in
		let currentTexture: MTLTexture?
		if activeScene < 3 {
			currentTexture = textureLoader.textures[.Technofundamental]
		} else {
			let idx = Int(fmodf(floor(time / 4.0), 4.0))
			let name: TechnofundamentalDemoConfig.TextureName = [.Code, .Psonice, .Music, .Bossman][idx]
			currentTexture = textureLoader.textures[name]
		}
		cmdEncoder.setTexture(currentTexture, index: 1)
		
		// It's compute, so configure the threadgroups and dispatch them
		// Dispatch 64 pixels at a time in an 8x8 block
		let threadGroupCount = MTLSizeMake(8, 8, 1)
		cmdEncoder.dispatchThreads(MTLSize(width: drawable.texture.width, height: drawable.texture.height, depth: 1), threadsPerThreadgroup: threadGroupCount)
		
		// We're done encoding this!
		cmdEncoder.endEncoding()
		
		// Now we pass the temporary texture into the MPS shader, and assign the destination texture as the drawable surface like so:
		mpsMedian!.encode(commandBuffer: buffer, sourceTexture: tex, destinationTexture: drawable.texture)
		
		// Done. Just tell it to present (show it on screen) and commit the command buffer to the GPU.
		buffer.present(drawable)
		buffer.commit()
	}
}
