//
//  ViewController.swift
//  Nova19
//
//  Created by Chris Wood on 10/04/2019.
//  Copyright © 2019 Realtime Dreams. All rights reserved.
//

import UIKit
import MetalKit
import QuartzCore
import simd
import MetalPerformanceShaders

class TechnofundamentalViewController: UIViewController {
	
	var demoPlayer: TechnofundamentalDemoPlayer?
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	@IBAction func startDemo() {
		demoPlayer = TechnofundamentalDemoPlayer()
		self.view.addSubview(demoPlayer!.view)
		
		demoPlayer?.endDemoBlock = {
			self.navigationController?.popViewController(animated: true)
		}
		
		demoPlayer!.startDemo()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		demoPlayer?.endDemoBlock = nil
		demoPlayer = nil
	}
	
	// Hide the home indicator on devices with no home button:
	override var prefersHomeIndicatorAutoHidden: Bool {
		get {
			return true
		}
	}
	
	// Hide the status bar
	override var prefersStatusBarHidden: Bool {
		get {
			return true
		}
	}


}

