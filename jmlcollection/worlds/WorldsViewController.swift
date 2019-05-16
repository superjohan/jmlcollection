//
//  WorldsViewController.swift
//  worlds
//
//  Copyright 2017 Johan Halin.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit
import AVFoundation
import SceneKit

class WorldsViewController: UIViewController, AVAudioPlayerDelegate {
    let textDuration = 115
    let textSource = "Freeman and slave, patrician and plebeian, lord and serf, guild-master and journeyman, in a word, oppressor and oppressed, stood in constant opposition to one another, carried on an uninterrupted, now hidden, now open fight, a fight that each time ended, either in a revolutionary reconstitution of society at large, or in the common ruin of the contending classes. In the earlier epochs of history, we find almost everywhere a complicated arrangement of society into various orders, a manifold gradation of social rank. In ancient Rome we have patricians, knights, plebeians, slaves; in the Middle Ages, feudal lords, vassals, guild-masters, journeymen, apprentices, serfs; in almost all of these classes, again, subordinate gradations. The modern bourgeois society that has sprouted from the ruins of feudal society has not done away with class antagonisms. It has but established new classes, new conditions of oppression, new forms of struggle in place of the old ones. Our epoch, the epoch of the bourgeoisie, possesses, however, this distinct feature: it has simplified class antagonisms. Society as a whole is more and more splitting up into two great hostile camps, into two great classes directly facing each other — Bourgeoisie and Proletariat."

    let audioPlayer: AVAudioPlayer
    let startButton: UIButton
    let sceneView: SCNView
    let camera: SCNNode
    let skyBoxes: [SCNNode]
    let endView: UIView = UIView.init(frame: CGRect.zero)
    let labels: [UILabel]
    let words: [String]
    
    var boxes: [SCNNode]
    var boxPositions: [SCNVector3]
    
    // MARK: - Private
    
    @objc private func startButtonTouched(button: UIButton) {
        self.startButton.isUserInteractionEnabled = false

        UIView.animate(withDuration: 4, animations: {
            self.startButton.alpha = 0
        }, completion: { _ in
            self.endView.isHidden = true
            
            self.start()
        })
    }
    
    fileprivate func moveCamera() {
        let cameraDuration = TimeInterval(160)
        
        self.camera.removeAllActions()
        self.camera.position = SCNVector3Make(0, 0, 58)
        self.camera.rotation = SCNVector4Zero
        
        let cameraMoveAction = SCNAction.move(to: SCNVector3Make(0, 30, 200), duration: cameraDuration)
        cameraMoveAction.timingMode = SCNActionTimingMode.easeIn
        self.camera.runAction(cameraMoveAction)
        
        let cameraRotateAction = SCNAction.rotateBy(x: -0.25, y: 0, z: 0, duration: cameraDuration)
        cameraRotateAction.timingMode = cameraMoveAction.timingMode
        self.camera.runAction(cameraRotateAction)
    }
    
    fileprivate func rotateSkyboxes() {
        for skybox in self.skyBoxes {
            skybox.removeAllActions()
            skybox.runAction(
                SCNAction.repeatForever(
                    SCNAction.rotateBy(
                        x: CGFloat(-10 + Int(arc4random_uniform(20))),
                        y: CGFloat(-10 + Int(arc4random_uniform(20))),
                        z: CGFloat(-10 + Int(arc4random_uniform(20))),
                        duration: TimeInterval(18 + arc4random_uniform(5))
                    )
                )
            )
        }
    }
    
    fileprivate func rotateSphereBoxes() {
        for boxNode in self.boxes {
            boxNode.removeAllActions()
            boxNode.runAction(
                SCNAction.repeatForever(
                    SCNAction.rotateBy(
                        x: CGFloat(-10 + Int(arc4random_uniform(20))),
                        y: CGFloat(-10 + Int(arc4random_uniform(20))),
                        z: CGFloat(-10 + Int(arc4random_uniform(20))),
                        duration: TimeInterval(8 + arc4random_uniform(5))
                    )
                )
            )
        }
    }
    
    fileprivate func crunchEnding() {
        let waitAction = SCNAction.wait(duration: 118)
        
        let moveAction = SCNAction.move(to: SCNVector3Make(0, 0, 0), duration: 1)
        moveAction.timingMode = SCNActionTimingMode.easeIn
        
        let sequence = SCNAction.sequence([ waitAction, moveAction ])
        
        for box in self.boxes {
            box.runAction(sequence)
        }
    }
    
    fileprivate func updateLabelContent() {
        let tickLength = (60.0 / 140.0) * 0.75
        var counter: Double = 0
        
        while counter < Double(self.textDuration) {
            counter += tickLength
            
            // performSelector doesn't throttle, unlike DispatchQueue, so sue me
            perform(#selector(scheduleLabelAnimation), with: NSNumber.init(value: counter), afterDelay: counter)
        }
        
        perform(#selector(fadeOutLabels), with: nil, afterDelay: counter + tickLength)
    }
    
    @objc
    fileprivate func fadeOutLabels() {
        UIView.animate(withDuration: 0.3, animations: {
            for label in self.labels {
                label.alpha = 0
            }
        })
    }
    
    @objc
    fileprivate func scheduleLabelAnimation(counterNumber: NSNumber) {
        let shouldShowLabel = arc4random_uniform(2) == 0 ? true : false
        if !shouldShowLabel {
            return
        }

        let counter = counterNumber.doubleValue
        let textCount = Int(((counter / Double(self.textDuration)) * 9) + 1)
        
        var texts = [ "", "", "", "", "", "", "", "", "" ]
        
        for _ in 0..<textCount {
            let index = Int(arc4random_uniform(9))
            let textIndex = Int(arc4random_uniform(UInt32(self.words.count)))
            texts[index] = self.words[textIndex]
        }
        
        for label in self.labels {
            label.alpha = 1
            
            if let index = self.labels.firstIndex(of: label) {
                label.text = "\(texts[index * 3])\n"
                    + "\(texts[(index * 3) + 1])\n"
                    + "\(texts[(index * 3) + 2])"
            }
        }

        let shouldFadeOutLabel = arc4random_uniform(2) == 0 ? true : false
        if !shouldFadeOutLabel {
            return
        }
        
        fadeOutLabels()
    }
    
    fileprivate func start() {
        self.audioPlayer.play()
        
        self.sceneView.isHidden = false
        self.sceneView.alpha = 0
        
        UIView.animate(withDuration: 10, animations: {
            self.sceneView.alpha = 1.0
        })

        for label in self.labels {
            label.text = ""
        }
        
        for i in 0..<self.boxes.count {
            self.boxes[i].position = self.boxPositions[i]
        }
        
        moveCamera()
        rotateSkyboxes()
        rotateSphereBoxes()
        crunchEnding()
        updateLabelContent()
    }

    fileprivate func configureLight(_ scene: SCNScene) {
        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        omniLightNode.light?.type = SCNLight.LightType.omni
        omniLightNode.light?.color = UIColor(white: 1.0, alpha: 1.0)
        omniLightNode.position = SCNVector3Make(0, -60, 60)
        scene.rootNode.addChildNode(omniLightNode)
    }
    
    fileprivate func configureSkyboxes(_ scene: SCNScene) {
        for skyboxNode in self.skyBoxes {
            guard let skybox = skyboxNode.geometry as! SCNBox? else { abort() }
            
            let length = CGFloat(500)
            skybox.width = length
            skybox.height = length
            skybox.length = length
            
            skybox.firstMaterial?.diffuse.contents = UIImage.init(named: "texture1")
            skybox.firstMaterial?.isDoubleSided = true
            
            scene.rootNode.addChildNode(skyboxNode)
        }
    }
    
    fileprivate func configureSphereBoxes(_ scene: SCNScene) {
        let boxCount = 32
        
        for i in 0...boxCount {
            let ratio = sin((Float.pi) * (Float(i) / Float(boxCount)))
            let half = Float(boxCount) / Float(2)
            let ratio2 = sin((Float.pi / 2.0) * ((half - Float(i)) / half))
            let radius = 50.0 * ratio
            let boxesPerRow = Int(ratio * Float(boxCount))
            
            for j in 0..<boxesPerRow {
                let box = SCNBox(width: 10, height: 10, length: 10, chamferRadius: 0)
                let boxNode = SCNNode(geometry: box)
                let angle = (Float(j) / Float(boxesPerRow)) * (Float.pi * 2)
                
                boxNode.position = SCNVector3Make(
                    sin(angle) * radius,
                    50.0 * ratio2,
                    cos(angle) * radius
                )
                
                self.boxPositions.append(boxNode.position)
                
                box.firstMaterial?.diffuse.contents = UIColor.init(white: 1.0, alpha: 1.0)
                
                self.boxes.append(boxNode)
                scene.rootNode.addChildNode(boxNode)
            }
        }
    }
    
    fileprivate func createScene() -> SCNScene {
        let scene = SCNScene()
        scene.background.contents = UIColor.black
        
        scene.rootNode.addChildNode(self.camera)

        configureLight(scene)
        configureSkyboxes(scene)
        configureSphereBoxes(scene)
        
        return scene
    }
    
    // MARK: - AVAudioPlayerDelegate
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if (flag) {
            self.sceneView.isHidden = true
            self.endView.isHidden = false
            self.audioPlayer.prepareToPlay()
            
            self.startButton.isUserInteractionEnabled = true
            self.startButton.alpha = 0
            self.startButton.isHidden = false
            self.startButton.setTitle("tap anywhere to replay\n\nit will be different this time", for: UIControl.State.normal)
            
            UIView.animate(withDuration: 0.2, delay: 3, options: [], animations: {
                self.startButton.alpha = 1
            }, completion: nil)
        }
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.audioPlayer.prepareToPlay()
        self.audioPlayer.delegate = self
        
        self.sceneView.alpha = 0
        self.view.backgroundColor = UIColor.black
        
        self.sceneView.scene = createScene()
        
        self.endView.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.startButton.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        self.sceneView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        self.endView.frame = CGRect(
            x: (self.view.bounds.size.width / 2) - 1,
            y: (self.view.bounds.size.height / 2) - 1,
            width: 2,
            height: 2
        )
        
        let padding: CGFloat = 40
        
        for label in self.labels {
            label.frame = CGRect(
                x: padding,
                y: padding,
                width: self.view.bounds.size.width - (padding * 2),
                height: self.view.bounds.size.height - (padding * 2)
            )
            
            label.font = UIFont(name: "HelveticaNeue-Bold", size: self.view.bounds.size.height / 4.6)
        }
    }
        
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.audioPlayer.stop()
    }
    
    init() {
        if let trackUrl = Bundle.main.url(forResource: "track", withExtension: "m4a") {
            guard let audioPlayer = try? AVAudioPlayer(contentsOf: trackUrl) else {
                abort()
            }
            
            self.audioPlayer = audioPlayer
        } else {
            abort()
        }
        
        let startButtonText =
            "\"worlds\"\n" +
            "by dekadence\n" +
            "\n" +
            "programming and music by ricky martin\n" +
            "\n" +
            "presented at vortex 2017\n" +
            "\n" +
            "tap anywhere to start"
        self.startButton = UIButton.init(type: UIButton.ButtonType.custom)
        self.startButton.setTitle(startButtonText, for: UIControl.State.normal)
        self.startButton.titleLabel?.numberOfLines = 0
        self.startButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.startButton.backgroundColor = UIColor.black
        
        self.sceneView = SCNView(frame: CGRect.zero)
        
        self.boxes = []
        self.boxPositions = []
        
        self.camera = SCNNode()
        let camera = SCNCamera()
        camera.zFar = 600
        camera.vignettingIntensity = 1
        camera.vignettingPower = 1
        self.camera.camera = camera // lol
        
        self.skyBoxes = [ SCNNode(geometry: SCNBox()), SCNNode(geometry: SCNBox()) ]
        
        self.labels = [
            UILabel.init(frame: CGRect.zero),
            UILabel.init(frame: CGRect.zero),
            UILabel.init(frame: CGRect.zero)
        ]
        
        self.words = self.textSource.components(separatedBy: " ")
        
        super.init(nibName: nil, bundle: nil)
        
        self.endView.isHidden = true
        self.view.addSubview(self.endView)
        
        self.view.addSubview(self.sceneView)
        
        self.startButton.addTarget(self, action: #selector(startButtonTouched), for: UIControl.Event.touchUpInside)
        self.view.addSubview(self.startButton)
        
        for label in self.labels {
            label.numberOfLines = 0
            label.textColor = UIColor.init(white: 0.75, alpha: 0.75)
            label.backgroundColor = UIColor.clear
            label.lineBreakMode = NSLineBreakMode.byClipping
            
            let index = self.labels.firstIndex(of: label)
            if index == 0 {
                label.textAlignment = NSTextAlignment.left
            } else if index == 1 {
                label.textAlignment = NSTextAlignment.center
            } else if index == 2 {
                label.textAlignment = NSTextAlignment.right
            }
            
            self.view.addSubview(label)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
