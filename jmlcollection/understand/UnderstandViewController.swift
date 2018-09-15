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

class UnderstandViewController: UIViewController, SCNSceneRendererDelegate {
    let colorSchemes = [
        [
            UIColor(red: (234.0 / 255.0), green: (223.0 / 255.0), blue: (195.0 / 255.0), alpha: 1.0),
            UIColor(red: (245.0 / 255.0), green: (171.0 / 255.0), blue: (12.0 / 255.0), alpha: 1.0),
            UIColor(red: (26.0 / 255.0), green: (157.0 / 255.0), blue: (213.0 / 255.0), alpha: 1.0),
            UIColor(red: (222.0 / 255.0), green: (17.0 / 255.0), blue: (32.0 / 255.0), alpha: 1.0)
        ],
        [
            UIColor(red: (254.0 / 255.0), green: (244.0 / 255.0), blue: (82.0 / 255.0), alpha: 1.0),
            UIColor(red: (204.0 / 255.0), green: (51.0 / 255.0), blue: (122.0 / 255.0), alpha: 1.0),
            UIColor(red: (38.0 / 255.0), green: (27.0 / 255.0), blue: (107.0 / 255.0), alpha: 1.0),
            UIColor(red: (255.0 / 255.0), green: (255.0 / 255.0), blue: (255.0 / 255.0), alpha: 1.0)
        ],
        [
            UIColor(red: (23.0 / 255.0), green: (77.0 / 255.0), blue: (203.0 / 255.0), alpha: 1.0),
            UIColor(red: (237.0 / 255.0), green: (125.0 / 255.0), blue: (156.0 / 255.0), alpha: 1.0),
            UIColor(red: (128.0 / 255.0), green: (146.0 / 255.0), blue: (192.0 / 255.0), alpha: 1.0),
            UIColor(red: (89.0 / 255.0), green: (125.0 / 255.0), blue: (161.0 / 255.0), alpha: 1.0)
        ],
        [
            UIColor(red: (230.0 / 255.0), green: (55.0 / 255.0), blue: (42.0 / 255.0), alpha: 1.0),
            UIColor(red: (44.0 / 255.0), green: (104.0 / 255.0), blue: (212.0 / 255.0), alpha: 1.0),
            UIColor(red: (36.0 / 255.0), green: (77.0 / 255.0), blue: (37.0 / 255.0), alpha: 1.0),
            UIColor(red: (229.0 / 255.0), green: (75.0 / 255.0), blue: (44.0 / 255.0), alpha: 1.0)
        ],
        [
            UIColor(red: (43.0 / 255.0), green: (87.0 / 255.0), blue: (40.0 / 255.0), alpha: 1.0),
            UIColor(red: (236.0 / 255.0), green: (71.0 / 255.0), blue: (97.0 / 255.0), alpha: 1.0),
            UIColor(red: (254.0 / 255.0), green: (252.0 / 255.0), blue: (92.0 / 255.0), alpha: 1.0),
            UIColor(red: (201.0 / 255.0), green: (175.0 / 255.0), blue: (161.0 / 255.0), alpha: 1.0)
        ],
        [
            UIColor(red: (168.0 / 255.0), green: (173.0 / 255.0), blue: (168.0 / 255.0), alpha: 1.0),
            UIColor(red: (249.0 / 255.0), green: (209.0 / 255.0), blue: (71.0 / 255.0), alpha: 1.0),
            UIColor(red: (237.0 / 255.0), green: (72.0 / 255.0), blue: (56.0 / 255.0), alpha: 1.0),
            UIColor(red: (68.0 / 255.0), green: (162.0 / 255.0), blue: (231.0 / 255.0), alpha: 1.0)
        ],
        [
            UIColor(red: (235.0 / 255.0), green: (92.0 / 255.0), blue: (151.0 / 255.0), alpha: 1.0),
            UIColor(red: (70.0 / 255.0), green: (158.0 / 255.0), blue: (223.0 / 255.0), alpha: 1.0),
            UIColor(red: (252.0 / 255.0), green: (241.0 / 255.0), blue: (81.0 / 255.0), alpha: 1.0),
            UIColor(red: (127.0 / 255.0), green: (189.0 / 255.0), blue: (88.0 / 255.0), alpha: 1.0)
        ],
        [
            UIColor(red: (235.0 / 255.0), green: (224.0 / 255.0), blue: (194.0 / 255.0), alpha: 1.0),
            UIColor(red: (52.0 / 255.0), green: (87.0 / 255.0), blue: (143.0 / 255.0), alpha: 1.0),
            UIColor(red: (94.0 / 255.0), green: (148.0 / 255.0), blue: (55.0 / 255.0), alpha: 1.0),
            UIColor(red: (207.0 / 255.0), green: (71.0 / 255.0), blue: (55.0 / 255.0), alpha: 1.0)
        ],
        [
            UIColor(red: (227.0 / 255.0), green: (36.0 / 255.0), blue: (28.0 / 255.0), alpha: 1.0),
            UIColor(red: (184.0 / 255.0), green: (142.0 / 255.0), blue: (32.0 / 255.0), alpha: 1.0),
            UIColor(red: (62.0 / 255.0), green: (6.0 / 255.0), blue: (5.0 / 255.0), alpha: 1.0),
            UIColor(red: (254.0 / 255.0), green: (248.0 / 255.0), blue: (248.0 / 255.0), alpha: 1.0)
        ],
        [
            UIColor(red: (17.0 / 255.0), green: (24.0 / 255.0), blue: (32.0 / 255.0), alpha: 1.0),
            UIColor(red: (139.0 / 255.0), green: (141.0 / 255.0), blue: (138.0 / 255.0), alpha: 1.0),
            UIColor(red: (112.0 / 255.0), green: (198.0 / 255.0), blue: (233.0 / 255.0), alpha: 1.0),
            UIColor(red: (255.0 / 255.0), green: (255.0 / 255.0), blue: (251.0 / 255.0), alpha: 1.0)
        ],
        [
            UIColor(red: (133.0 / 255.0), green: (152.0 / 255.0), blue: (148.0 / 255.0), alpha: 1.0),
            UIColor(red: (4.0 / 255.0), green: (4.0 / 255.0), blue: (4.0 / 255.0), alpha: 1.0),
            UIColor(red: (251.0 / 255.0), green: (250.0 / 255.0), blue: (248.0 / 255.0), alpha: 1.0),
            UIColor(red: (228.0 / 255.0), green: (44.0 / 255.0), blue: (32.0 / 255.0), alpha: 1.0)
        ],
    ]
    
    let audioPlayer: AVAudioPlayer
    let sceneView = SCNView()
    let camera = SCNNode()
    let startButton: UIButton
    let qtFoolingBgView: UIView = UIView.init(frame: .zero)
    let understandLabel: BlurredLabel = BlurredLabel(frame: .zero)
    let allFontNames: [String]
    
    var position: Int = 0

    var previousFontName: String? = nil
    var boxNode: SCNNode? = nil
    var sawNode: SCNNode? = nil
    var waveNode: SCNNode? = nil
    var planeNode: SCNNode? = nil
    
    // MARK: - UIViewController
    
    init() {
        if let trackUrl = Bundle.main.url(forResource: "understandaudio", withExtension: "m4a") {
            guard let audioPlayer = try? AVAudioPlayer(contentsOf: trackUrl) else {
                abort()
            }
            
            self.audioPlayer = audioPlayer
        } else {
            abort()
        }
        
        let camera = SCNCamera()
        camera.zFar = 300
        camera.vignettingIntensity = 0.5
        camera.vignettingPower = 0.5
        camera.colorFringeStrength = 1
        camera.wantsDepthOfField = true
        camera.focusDistance = 0.075
        camera.fStop = 1
        camera.apertureBladeCount = 10
        camera.focalBlurSampleCount = 100
        self.camera.camera = camera // lol
        
        let startButtonText =
            "\"understand\"\n" +
                "by jumalauta\n" +
                "\n" +
                "programming and music by ylvaes\n" +
                "modeling by tohtori kannabispiikki\n" +
                "jaakko helped with colors\n" +
                "\n" +
                "presented at jumalauta 18 years (2018)\n" +
                "\n" +
        "tap anywhere to start"
        self.startButton = UIButton.init(type: UIButton.ButtonType.custom)
        self.startButton.setTitle(startButtonText, for: UIControl.State.normal)
        self.startButton.titleLabel?.numberOfLines = 0
        self.startButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.startButton.backgroundColor = UIColor.black

        var fontNames: [String] = []
        let ignoredFamilies: [String] = ["Arial", "Arial Hebrew", "Arial Rounded MT Bold", "Bodoni Ornaments", "Bradley Hand", "Chalkboard SE", "Chalkduster", "Marker Felt", "Papyrus", "Party LET", "Rockwell", "Courier", "Courier New"]
        for familyName in UIFont.familyNames {
            if ignoredFamilies.contains(familyName) {
                continue
            }
            
            for fontName in UIFont.fontNames(forFamilyName: familyName) {
                if fontName.lowercased().contains("bold") && fontName.lowercased().contains("italic") {
                    fontNames.append(fontName)
                }
            }
        }
        
        self.allFontNames = fontNames
            
        super.init(nibName: nil, bundle: nil)
        
        self.startButton.addTarget(self, action: #selector(startButtonTouched), for: UIControl.Event.touchUpInside)
        
        self.view.backgroundColor = .black
        self.sceneView.backgroundColor = .black
        
        self.qtFoolingBgView.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        
        // barely visible tiny view for fooling Quicktime player. completely black images are ignored by QT
        self.view.addSubview(self.qtFoolingBgView)
        
        self.view.addSubview(self.sceneView)

        self.view.addSubview(self.understandLabel)
        
        self.view.addSubview(self.startButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.audioPlayer.prepareToPlay()
        
        self.sceneView.scene = createScene()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.qtFoolingBgView.frame = CGRect(
            x: (self.view.bounds.size.width / 2) - 1,
            y: (self.view.bounds.size.height / 2) - 1,
            width: 2,
            height: 2
        )

        self.sceneView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        self.sceneView.isPlaying = true
        self.sceneView.isHidden = true

        self.understandLabel.text = "UNDERSTAND"
        self.understandLabel.frame = self.view.bounds
        self.understandLabel.adjustsFontSizeToFitWidth = true
        self.understandLabel.font = UIFont.systemFont(ofSize: 400)
        self.understandLabel.textAlignment = .center
        self.understandLabel.textColor = .white
        self.understandLabel.baselineAdjustment = .alignCenters
        self.understandLabel.isHidden = true
        self.understandLabel.shadowColor = .black
        self.understandLabel.shadowOffset = CGSize(width: 5, height: 5)
        
        self.startButton.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.audioPlayer.stop()
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
        self.sceneView.isHidden = false
        
        scheduleEvents()
        resetScene()
        
        self.audioPlayer.play()
    }
    
    private func scheduleEvents() {
        let fontStartTime = 1.5
        
        for i in 0..<40 {
            perform(#selector(updateScene), with: nil, afterDelay: (Double(i) * 2) + fontStartTime)
        }
    }
    
    @objc
    private func updateScene() {
        self.position += 1
        
        var fontName: String
        repeat {
            let index = Int(arc4random_uniform(UInt32(self.allFontNames.count)))
            fontName = self.allFontNames[index]
        } while fontName == self.previousFontName
        
        self.previousFontName = fontName
        
        guard let font = UIFont(name: fontName, size: 400) else { return }
        self.understandLabel.font = font
        self.understandLabel.isHidden = false
        
        if self.position < 9 {
            self.understandLabel.blurredText = "UNDERSTAND"
        } else if self.position >= 9 && self.position < 24 {
            self.understandLabel.text = "UNDERSTAND"
        } else if self.position >= 24 && self.position < 33 {
            self.understandLabel.blurredText = "UNDERSTAND"
        } else {
            self.understandLabel.text = "UNDERSTAND"
        }
        
        if self.position == 9 {
            let focusDistanceAnimation = CABasicAnimation(keyPath: "camera.focusDistance")
            focusDistanceAnimation.toValue = 2.5
            focusDistanceAnimation.duration = 2.0
            self.camera.addAnimation(focusDistanceAnimation, forKey: "focus")
            
            let fStopAnimation = CABasicAnimation(keyPath: "camera.fStop")
            fStopAnimation.toValue = 5.6
            fStopAnimation.duration = focusDistanceAnimation.duration
            self.camera.addAnimation(fStopAnimation, forKey: "fStop")
        }
        
        if self.position == 10 {
            self.camera.camera?.focusDistance = 2.5
            self.camera.camera?.fStop = 5.6
        }
        
        resetScene()
        
        if self.position < 40 {
            perform(#selector(hideLabel), with: nil, afterDelay: 1)
        } else {
            perform(#selector(hideSceneView), with: nil, afterDelay: 1)
        }
    }
    
    @objc
    private func hideLabel() {
        self.understandLabel.isHidden = true
    }
    
    @objc
    private func hideSceneView() {
        self.sceneView.isHidden = true
    }
    
    private func resetScene() {
        self.camera.removeAllActions()
        if self.position >= 24 && self.position < 33 {
            let positions = [
                SCNVector3Make(20, 20, 40),
                SCNVector3Make(-45, 0, 30),
                SCNVector3Make(5, -25, 20)
            ]
            
            self.camera.position = positions[Int(arc4random_uniform(UInt32(positions.count)))]
            self.camera.runAction(
                SCNAction.move(
                    by: SCNVector3Make(10, 0, -5),
                    duration: 2
                )
            )
        } else {
            self.camera.position = SCNVector3Make(-5, 0, 58)
            self.camera.runAction(
                SCNAction.move(
                    by: SCNVector3Make(10, 0, 0),
                    duration: 2
                )
            )
        }
        
        let positions = [
            SCNVector3Make(20, 20, 0),
            SCNVector3Make(-45, -15, 0),
            SCNVector3Make(-5, -25, -10)
        ]
        
        let colorScheme = self.colorSchemes[Int(arc4random_uniform(UInt32(self.colorSchemes.count)))].shuffled()
        
        self.boxNode?.removeAllActions()
        self.boxNode?.position = positions[0]
        self.boxNode?.geometry?.firstMaterial?.diffuse.contents = colorScheme[0]
        self.boxNode?.rotation = SCNVector4Make(0, 0, 0, 0)
        self.boxNode?.runAction(
            SCNAction.repeatForever(
                SCNAction.rotateBy(
                    x: 0.4,
                    y: 0.7,
                    z: 1,
                    duration: 1.1
                )
            )
        )
        self.boxNode?.runAction(
            SCNAction.move(
                by: SCNVector3Make(10, -5, 2),
                duration: 2.5
            )
        )

        self.sawNode?.removeAllActions()
        self.sawNode?.position = positions[1]
        setColorInChildnodes(node: self.sawNode!, color: colorScheme[1])
        self.sawNode?.rotation = SCNVector4Make(0.2, 0.1, 0.2, 1)
        self.sawNode?.runAction(
            SCNAction.repeatForever(
                SCNAction.rotateBy(
                    x: CGFloat.pi,
                    y: 0,
                    z: 0,
                    duration: 2
                )
            )
        )

        self.waveNode?.rotation = SCNVector4Make(0, 0, -2, 0.1)
        self.waveNode?.position = positions[2]
        setColorInChildnodes(node: self.waveNode!, color: colorScheme[2])
        self.waveNode?.removeAllActions()
        self.waveNode?.runAction(
            SCNAction.repeatForever(
                SCNAction.rotateBy(
                    x: -CGFloat.pi,
                    y: 0,
                    z: 0.2,
                    duration: 1.4
                )
            )
        )
        
        self.planeNode?.geometry?.firstMaterial?.multiply.contents = colorScheme[3]
    }
    
    fileprivate func createScene() -> SCNScene {
        let scene = SCNScene()
        scene.background.contents = UIColor.black
                
        scene.rootNode.addChildNode(self.camera)

        // background
        let plane = SCNPlane(width: 300, height: 300)
        plane.firstMaterial?.diffuse.contents = UIImage(named: "checkerboard")
        plane.firstMaterial?.multiply.contents = UIColor.green
        let planeNode = SCNNode(geometry: plane)
        planeNode.position = SCNVector3Make(0, 0, -24)
        scene.rootNode.addChildNode(planeNode)
        self.planeNode = planeNode

        let box2 = SCNBox(width: 20, height: 20, length: 20, chamferRadius: 0)
        box2.firstMaterial?.diffuse.contents = UIColor.red
        let boxNode2 = SCNNode(geometry: box2)
        scene.rootNode.addChildNode(boxNode2)
        self.boxNode = boxNode2
        
        let sawNode = loadModel(name: "saha", textureName: nil, color: .blue)
        sawNode.scale = SCNVector3Make(1.6, 1.6, 1.6)
        scene.rootNode.addChildNode(sawNode)
        self.sawNode = sawNode
        
        let waveNode = loadModel(name: "sini", textureName: nil, color: .yellow)
        waveNode.scale = SCNVector3Make(1.5, 1.5, 1.5)
        scene.rootNode.addChildNode(waveNode)
        self.waveNode = waveNode
        
        resetScene()
        
        configureLight(scene)
        
        return scene
    }
    
    fileprivate func configureLight(_ scene: SCNScene) {
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = SCNLight.LightType.directional
        lightNode.light?.color = UIColor(white: 1.0, alpha: 1.0)
        lightNode.light?.castsShadow = true
        lightNode.light?.shadowColor = UIColor(white: 0, alpha: 1.0)
        lightNode.light?.intensity = 3000
        scene.rootNode.addChildNode(lightNode)
    }
}
