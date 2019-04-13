//
//  DemoConfig.swift
//  Nova19
//
//  Created by Chris Wood on 11/04/2019.
//  Copyright © 2019 Realtime Dreams. All rights reserved.
//

import UIKit

/*
	This is where you set your demo up.
*/

struct TechnofundamentalDemoConfig {
	
	// Configure your demo here!
	
	// Audio file info
	let musicFilename = "technofundamental"
	let musicFileExtension = "mp3"
	
	// Any textures to load (these should be in .png format). The "rawValue" should match the filename.
	enum TextureName: String, CaseIterable {
		case Technofundamental = "technofundamental"
		case Code = "code"
		case Psonice = "PSONICE"
		case Music = "music"
		case Bossman = "BOSSMAN"
	}
	
	// This is the number of scenes in your shader:
	let numberOfScenes = 13
	
	// Set the BPM here (first number). This makes sync trivial, because time in the shader will be measured in beats not seconds.
	let bpm: Float = (126.0 / 60.0)
	
	// This array holds the start time (IN BEATS) for each scene
	let sceneStartTime: [Float] = [0.0, 16.0, 48.0, 80.0, 96.0, 112.0, 144.0, 160.0, 192.0, 208.0, 224.0, 256.0, 300.0]
	
	// The demo start time. Normally this is zero, but you can use it to skip to any time while working on the demo.
	// Note that this is in seconds, but you can manually divide by bpm.
	let demoStartTime: Float = 0.0 / (126.0 / 60.0)
	
	// Render size and fps for iOS (macOS has a config screen and uses 60fps)
	// Render size will use this as the width and determine height based on aspect ratio
	let iOSRenderTargetWidth: CGFloat = 480.0
	let iOSFPS = 30
}

// Config is a global (shock, horror, etc)
let technoFundamentalConfig = TechnofundamentalDemoConfig()
