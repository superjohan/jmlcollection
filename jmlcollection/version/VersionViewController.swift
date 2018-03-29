//
//  ViewController.swift
//  demo
//
//  Created by Johan Halin on 12/03/2018.
//  Copyright © 2018 Dekadence. All rights reserved.
//

import UIKit
import AVFoundation
import SceneKit
import Foundation
import GameplayKit

class VersionViewController: UIViewController, SCNSceneRendererDelegate {
    let audioPlayer: AVAudioPlayer
    let sceneView = SCNView()
    let mainCamera = SCNNode()
    let startButton: UIButton
    let qtFoolingBgView: UIView = UIView.init(frame: CGRect.zero)
    let brandViewContainer = BrandViewContainerView(frame: .zero)
    let brandOrder: [Int]
    
    let gearView = SCNView()
    let gearCamera = SCNNode()
    
    let middleView = SCNView()
    let middleCamera = SCNNode()
    let middleOverlay = UIView()
    var isInMiddleState = false
    var middleCount = 0
    var middleStart: TimeInterval = -1

    var brandPosition = 0
    
    // MARK: - UIViewController
    
    init() {
        if let trackUrl = Bundle.main.url(forResource: "versionaudio", withExtension: "mp3") {
            guard let audioPlayer = try? AVAudioPlayer(contentsOf: trackUrl) else {
                abort()
            }
            
            self.audioPlayer = audioPlayer
        } else {
            abort()
        }
        
        self.mainCamera.camera = createMainSceneCamera()
        self.middleCamera.camera = createMiddleSceneCamera()
        self.gearCamera.camera = createGearSceneCamera()
        
        let startButtonText =
            "\"version: labor\"\n" +
                "by dekadence\n" +
                "\n" +
                "programming, music, and graphics by ricky martin\n" +
                "graphics by jaakko\n" +
                "main factory model by spiikki\n" +
                "middle part factory model by zimtis\n" + // from https://www.turbosquid.com/3d-models/fabrik-factory-c4d-free/533477
                "\n" +
                "presented at revision 2018\n" +
                "\n" +
        "tap anywhere to start"
        self.startButton = UIButton.init(type: UIButtonType.custom)
        self.startButton.setTitle(startButtonText, for: UIControlState.normal)
        self.startButton.titleLabel?.numberOfLines = 0
        self.startButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.startButton.backgroundColor = UIColor.black
        
        var brandOrder: [Int] = []
        for i in 0..<32 {
            brandOrder.append(i)
        }
        
        self.brandOrder = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: brandOrder) as! [Int]
        
        super.init(nibName: nil, bundle: nil)
        
        self.startButton.addTarget(self, action: #selector(startButtonTouched), for: UIControlEvents.touchUpInside)
        
        self.view.backgroundColor = .black
        self.sceneView.backgroundColor = .black
        self.sceneView.delegate = self
        self.middleOverlay.backgroundColor = .white
        
        self.qtFoolingBgView.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        
        // barely visible tiny view for fooling Quicktime player. completely black images are ignored by QT
        self.view.addSubview(self.qtFoolingBgView)
        
        self.view.addSubview(self.sceneView)
        self.view.addSubview(self.brandViewContainer)
        self.view.addSubview(self.middleView)
        self.view.addSubview(self.middleOverlay)
        self.view.addSubview(self.gearView)
        
        self.view.addSubview(self.startButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prefersHomeIndicatorAutoHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.audioPlayer.prepareToPlay()
        
        self.sceneView.scene = createMainScene(camera: self.mainCamera)
        self.gearView.scene = createGearScene(camera: self.gearCamera)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.qtFoolingBgView.frame = CGRect(
            x: (self.view.bounds.size.width / 2) - 1,
            y: (self.view.bounds.size.height / 2) - 1,
            width: 2,
            height: 2
        )
        
        self.sceneView.frame = self.view.bounds
        self.sceneView.isPlaying = true
        self.sceneView.isHidden = true
        
        self.brandViewContainer.frame = self.view.bounds
        self.brandViewContainer.isHidden = true
        self.brandViewContainer.adjustFrames()
        
        self.middleView.scene = createMiddleScene(camera: self.middleCamera, size: self.view.bounds.size)
        self.middleView.frame = self.view.bounds
        self.middleView.isHidden = true
        self.middleView.isPlaying = false

        self.middleOverlay.alpha = 1
        self.middleOverlay.isHidden = true
        self.middleOverlay.backgroundColor = .white
        self.middleOverlay.frame = self.middleView.bounds
        
        self.gearView.scene = createGearScene(camera: self.gearCamera)
        self.gearView.frame = self.view.bounds
        self.gearView.isHidden = true
        
        self.startButton.frame = self.view.bounds
        
        centerGearCamera(camera: self.gearCamera)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.audioPlayer.stop()
    }

    // MARK: - SCNSceneRendererDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        // this function is run in a background thread.
        DispatchQueue.main.async {
            if self.isInMiddleState {
                // note for the future: if quicktime can handle this updating every frame, then do that instead
                
                if self.middleStart < 0 {
                    self.middleStart = time
                    self.showNextBrand()
                }
                
                let delta = time - self.middleStart
                
                if delta > 0.033333 {
                    self.middleStart = -1
                }
            }
        }
    }
    
    // MARK: - Private
    
    @objc
    fileprivate func startButtonTouched(button: UIButton) {
        self.startButton.isUserInteractionEnabled = false
        
        // long fadeout to ensure that the home indicator is gone
        UIView.animate(withDuration: 4, animations: {
            self.startButton.alpha = 0
        }, completion: { _ in
            self.start()
        })
    }
    
    fileprivate func start() {
        self.startButton.isHidden = true
        self.sceneView.isHidden = true
        
        self.audioPlayer.play()
        
        scheduleEvents()
    }
    
    fileprivate func scheduleEvents() {
        let beatLength = Constants.beatLength
        let barLength = Constants.barLength
        
        func scheduleBeatEvents(position: Double) {
            perform(#selector(showFirstBeatState), with: nil, afterDelay: position)
            perform(#selector(showSecondBeatState), with: nil, afterDelay: position + beatLength)
            perform(#selector(showThirdBeatState), with: nil, afterDelay: position + (beatLength * 2.0))
        }
        
        for i in 0..<37 {
            let position = Double(i) * barLength
            
            if i >= 0 && i < 16 {
                scheduleBeatEvents(position: position)
            }
            
            if i == 16 {
                perform(#selector(showMiddleState), with: nil, afterDelay: position)
            }
            
            if i >= 20 && i < 36 {
                scheduleBeatEvents(position: position)
            }
            
            if i == 36 {
                perform(#selector(endItAll), with: nil, afterDelay: position)
            }
        }
    }
    
    @objc
    fileprivate func showFirstBeatState() {
        if self.brandPosition == 8 || self.brandPosition == 24 {
            animateBallInGearScene()
        } else {
            animateGearScene(camera: self.gearCamera)
        }
        
        if self.brandPosition % 4 == 0 {
            adjustMainSceneCamera(camera: self.mainCamera)
        }
        
        self.gearView.isHidden = false
        
        self.sceneView.isHidden = true
        self.brandViewContainer.isHidden = true
        self.isInMiddleState = false
        self.middleView.isHidden = true
        self.middleView.isPlaying = false
        self.middleOverlay.isHidden = true

        self.mainCamera.isPaused = true
    }
    
    @objc
    fileprivate func showSecondBeatState() {
        self.gearView.isHidden = true
        self.sceneView.isHidden = false
        self.brandViewContainer.isHidden = true
        self.isInMiddleState = false
        self.middleView.isHidden = true
        self.middleView.isPlaying = false
        self.middleCamera.isPaused = true
        self.middleOverlay.isHidden = true

        self.mainCamera.isPaused = false
        
        centerGearCamera(camera: self.gearCamera)
    }
    
    @objc
    fileprivate func showThirdBeatState() {
        self.gearView.isHidden = true
        self.sceneView.isHidden = true
        self.brandViewContainer.isHidden = false
        self.isInMiddleState = false

        if self.brandPosition < 16 {
            self.middleView.isHidden = true
            self.middleView.isPlaying = false
            self.middleCamera.isPaused = true
        } else {
            self.middleView.isHidden = false
            self.middleView.isPlaying = true
            self.middleCamera.isPaused = false
        }

        self.middleOverlay.isHidden = true
        self.mainCamera.isPaused = true

        self.brandViewContainer.showBrand(self.brandOrder[self.brandPosition], animated: true)
        
        if self.brandPosition == 14 {
            setFactoryHidden(true)
        }
        
        if self.brandPosition == 15 {
            self.middleView.alpha = 0
            self.middleView.isHidden = false
            
            UIView.animate(withDuration: Constants.beatLength * 0.5, delay: Constants.beatLength * 1.5, options: [ .curveEaseIn ], animations: {
                self.middleView.alpha = 0.75
            }, completion: nil)
        } else if self.brandPosition == 16 {
            self.middleView.alpha = 0
            
            UIView.animate(withDuration: Constants.barLength * 16, delay: 0, options: [ .curveEaseIn ], animations: {
                self.middleView.alpha = 0.5
            }, completion: nil)
        }
        
        self.brandPosition += 1
        
        if self.brandPosition % 4 > 0 {
            resetCameraToGear(camera: self.gearCamera)
        }
        
        if self.brandPosition == 8 || self.brandPosition == 24 {
            adjustGearSceneForBall(camera: self.gearCamera)
        }
        
        if self.brandPosition % 4 == 0 {
            self.mainCamera.isPaused = false
            resetMainSceneCamera(camera: self.mainCamera)
        }
    }
    
    @objc
    fileprivate func showMiddleState() {
        self.gearView.isHidden = true
        self.sceneView.isHidden = true
        self.brandViewContainer.isHidden = false
        self.isInMiddleState = true
        
        self.middleView.isHidden = false
        self.middleView.isPlaying = true
        self.middleView.alpha = 1
        self.middleCamera.isPaused = false
        setFactoryHidden(false)
        
        UIView.animate(withDuration: Constants.barLength * 4, animations: {
            self.middleView.alpha = 0
        })
        
        self.middleOverlay.isHidden = false

        UIView.animate(withDuration: Constants.beatLength * 2, animations: {
            self.middleOverlay.alpha = 0
            self.middleOverlay.backgroundColor = .white
        })
    }
    
    @objc
    fileprivate func endItAll() {
        self.gearView.isHidden = true
        self.sceneView.isHidden = true
        self.brandViewContainer.isHidden = true
        self.isInMiddleState = false
        self.middleView.isHidden = true
        self.middleView.isPlaying = false
        self.middleCamera.isPaused = true
        self.middleOverlay.isHidden = true
    }
    
    fileprivate func showNextBrand() {
        self.brandViewContainer.showBrand(self.middleCount, animated: false)
        
        self.middleCount += 1
        
        if self.middleCount >= 32 {
            self.middleCount = 0
        }
    }
}
