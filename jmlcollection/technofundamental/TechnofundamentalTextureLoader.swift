//
//  TextureLoader.swift
//  Nova19
//
//  Created by Chris Wood on 10/04/2019.
//  Copyright © 2019 Realtime Dreams. All rights reserved.
//

import Foundation
import simd
import MetalKit

struct TechnofundamentalTextureLoader {
	
	var textures = [TechnofundamentalDemoConfig.TextureName: MTLTexture]()
	
	init(dev: MTLDevice) {
		// Create a texture loader
		let loader = MTKTextureLoader.init(device: dev)
		let opts: [MTKTextureLoader.Option : NSObject] = [
			MTKTextureLoader.Option.allocateMipmaps : NSNumber.init(value: 0),
			MTKTextureLoader.Option.generateMipmaps : NSNumber.init(value: 0),
			MTKTextureLoader.Option.textureUsage : NSNumber.init(value: MTLTextureUsage.shaderRead.rawValue),
			MTKTextureLoader.Option.textureStorageMode : NSNumber.init(value: MTLStorageMode.private.rawValue)
		]
		
		var tempTextures = [TechnofundamentalDemoConfig.TextureName: MTLTexture]()
		
		for name in TechnofundamentalDemoConfig.TextureName.allCases {
			let url = Bundle.main.url(forResource: name.rawValue, withExtension: "png")!
			let tex = try! loader.newTexture(URL: url, options: opts)
			tempTextures[name] = tex
			print("Loaded texture: \(name)")
		}
		textures = tempTextures
	}
}
