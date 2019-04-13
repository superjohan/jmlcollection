//
//  MusicPlayer.swift
//  Nova19
//
//  Created by Chris Wood on 10/04/2019.
//  Copyright © 2019 Realtime Dreams. All rights reserved.
//

import Foundation
import AVFoundation

class TechnofundamentalMusicPlayer {
	
	private let mainPlayer: AVPlayer
	var player: AVPlayer
	var currentItem: AVPlayerItem
	var duration: Float {
		get {
			return Float(currentItem.duration.seconds)
		}
	}
	
	var time: Float {
		get {
			let time = player.currentTime()
			let seconds = Float(CMTimeGetSeconds(time))
			return seconds
		}
	}
	
	func jumpTo(_ seconds: Float) {
		player.seek(to: CMTimeMakeWithSeconds(Double(seconds), preferredTimescale: 1000))
	}
	
	var position: Float {
		get {
			return time / duration
		}
		set {
			let seconds = Float64(newValue * duration)
			player.seek(to: CMTimeMakeWithSeconds(seconds, preferredTimescale: 1000))
		}
	}
	
	var play: Bool {
		get {
			return player.rate != 0.0
		}
		set {
			player.rate = newValue ? 1.0 : 0.0
		}
	}
	
	func startDemo() {
		play = false
		player = mainPlayer
		currentItem = player.currentItem!
		let startTime = CMTime(seconds: Double(technoFundamentalConfig.demoStartTime), preferredTimescale: 1000)
		player.seek(to: startTime)
		play = true
	}
	
	init() {
		let mainUrl = Bundle.main.url(forResource: technoFundamentalConfig.musicFilename, withExtension: technoFundamentalConfig.musicFileExtension)!
		mainPlayer = AVPlayer.init(url: mainUrl)
		mainPlayer.automaticallyWaitsToMinimizeStalling = true
		
		player = mainPlayer
		currentItem = player.currentItem!
	}
}

