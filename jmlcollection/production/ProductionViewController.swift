//
//  ProductionViewController.swift
//  production
//
//  Created by Johan Halin on 28/02/2018.
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

class ProductionViewController: UIViewController, SCNSceneRendererDelegate {
    let defaultNoiseScale: Float = 150
    
    let audioPlayer: AVAudioPlayer
    let sceneView = SCNView()
    let camera = SCNNode()
    let groupLogo = UIImageView(image: UIImage(named: "dekadence"))
    let nameLogo = UIImageView(image: UIImage(named: "production"))
    let errorView = UIView()
    let startButton: UIButton

    let silentSceneView = SCNView()
    let silentSceneCamera = SCNCamera()
    let silentSceneCameraNode = SCNNode()
    
    let qtFoolingBgView: UIView = UIView.init(frame: CGRect.zero)

    var boxes: [SCNNode] = []
    var backgroundBox: SCNNode?
    var silentSceneBox: SCNNode?
    var isInErrorState = false

    // MARK: - UIViewController
    
    init() {
        if let trackUrl = Bundle.main.url(forResource: "production_audio", withExtension: "m4a") {
            guard let audioPlayer = try? AVAudioPlayer(contentsOf: trackUrl) else {
                abort()
            }
            
            self.audioPlayer = audioPlayer
        } else {
            abort()
        }
        
        let camera = SCNCamera()
        camera.zFar = 600
        camera.vignettingIntensity = 1
        camera.vignettingPower = 1
        camera.colorFringeStrength = 3
        self.camera.camera = camera // lol

        self.silentSceneCamera.wantsHDR = true
        self.silentSceneCamera.bloomIntensity = 1
        self.silentSceneCamera.bloomBlurRadius = 40
        self.silentSceneCamera.colorFringeStrength = 3
        self.silentSceneCameraNode.camera = self.silentSceneCamera
        
        let startButtonText =
            "\"production\"\n" +
                "by dekadence\n" +
                "\n" +
                "programming and music by ricky martin\n" +
                "\n" +
                "presented at instanssi 2018\n" +
                "\n" +
        "tap anywhere to start"
        self.startButton = UIButton.init(type: UIButton.ButtonType.custom)
        self.startButton.setTitle(startButtonText, for: UIControl.State.normal)
        self.startButton.titleLabel?.numberOfLines = 0
        self.startButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.startButton.backgroundColor = UIColor.black

        super.init(nibName: nil, bundle: nil)
        
        self.startButton.addTarget(self, action: #selector(startButtonTouched), for: UIControl.Event.touchUpInside)

        self.view.backgroundColor = .black
        self.sceneView.backgroundColor = .black
        self.sceneView.delegate = self
        
        self.silentSceneView.isHidden = true
        
        self.qtFoolingBgView.backgroundColor = UIColor(white: 0.1, alpha: 1.0)

        self.groupLogo.contentMode = UIView.ContentMode.scaleAspectFit
        self.nameLogo.contentMode = UIView.ContentMode.scaleAspectFit

        self.view.addSubview(self.qtFoolingBgView)
        self.view.addSubview(self.sceneView)
        self.view.addSubview(self.silentSceneView)
        self.view.addSubview(self.groupLogo)
        self.view.addSubview(self.nameLogo)
        self.view.addSubview(self.errorView)
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
        self.silentSceneView.scene = createSilentScene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        self.startButton.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)

        self.sceneView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        self.sceneView.isPlaying = true
        self.sceneView.isHidden = true

        self.silentSceneView.frame = self.sceneView.frame
        self.silentSceneView.isPlaying = true
        
        self.groupLogo.frame = self.sceneView.frame
        self.groupLogo.isHidden = true
        
        self.nameLogo.frame = self.sceneView.frame
        self.nameLogo.isHidden = true
        
        self.errorView.isHidden = true

        self.qtFoolingBgView.frame = CGRect(
            x: (self.view.bounds.size.width / 2) - 1,
            y: (self.view.bounds.size.height / 2) - 1,
            width: 2,
            height: 2
        )
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.audioPlayer.stop()
    }
    
    // MARK: - SCNSceneRendererDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            if (self.isInErrorState) {
                self.updateErrorState()
            }
        }
    }

    // MARK: - Private
    
    @objc private func startButtonTouched(button: UIButton) {
        self.startButton.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 4, animations: {
            self.startButton.alpha = 0
        }, completion: { _ in
            self.start()
        })
    }

    fileprivate func start() {
        scheduleEvents()
        
        self.sceneView.isHidden = false
        
        self.audioPlayer.play()
    }
    
    fileprivate func scheduleEvents() {
        perform(#selector(showGroupLogo), with: NSNumber.init(booleanLiteral: true), afterDelay: 4)
        perform(#selector(showGroupLogo), with: NSNumber.init(booleanLiteral: false), afterDelay: 6)
        perform(#selector(setErrorState), with: NSNumber.init(booleanLiteral: true), afterDelay: 10)
        perform(#selector(setErrorState), with: NSNumber.init(booleanLiteral: false), afterDelay: 12)
        perform(#selector(showNameLogo), with: NSNumber.init(booleanLiteral: true), afterDelay: 16)
        perform(#selector(showNameLogo), with: NSNumber.init(booleanLiteral: false), afterDelay: 18)
        perform(#selector(setErrorState), with: NSNumber.init(booleanLiteral: true), afterDelay: 22)
        perform(#selector(setErrorState), with: NSNumber.init(booleanLiteral: false), afterDelay: 24)
        perform(#selector(setSilent1State), with: NSNumber.init(booleanLiteral: true), afterDelay: 28)
        perform(#selector(setSilent1State), with: NSNumber.init(booleanLiteral: false), afterDelay: 30)
        perform(#selector(setSilent2State), with: NSNumber.init(booleanLiteral: true), afterDelay: 32)
        perform(#selector(setSilent2State), with: NSNumber.init(booleanLiteral: false), afterDelay: 34)
        perform(#selector(endItAll), with: nil, afterDelay: 36)
    }
    
    @objc
    fileprivate func showGroupLogo(showBoolean: NSNumber) {
        let show = showBoolean.boolValue
        self.groupLogo.isHidden = !show
    }

    @objc
    fileprivate func showNameLogo(showBoolean: NSNumber) {
        let show = showBoolean.boolValue
        self.nameLogo.isHidden = !show
    }
    
    @objc
    fileprivate func setErrorState(errorStateBoolean: NSNumber) {
        let errorState = errorStateBoolean.boolValue
        self.isInErrorState = errorState
        
        for box in self.boxes {
            box.isPaused = errorState
        }
        
        if !errorState {
            self.sceneView.isHidden = false
            self.errorView.isHidden = true

            applyNoiseScaleToAllBoxes(scale: self.defaultNoiseScale)
        }
    }

    @objc
    fileprivate func setSilent1State(silentStateBoolean: NSNumber) {
        let isInSilentState = silentStateBoolean.boolValue
        
        if isInSilentState {
            self.sceneView.isHidden = true
            self.silentSceneView.isHidden = false
        } else {
            self.sceneView.isHidden = false
            self.silentSceneView.isHidden = true
        }
    }

    @objc
    fileprivate func setSilent2State(silentStateBoolean: NSNumber) {
        let isInSilent2State = silentStateBoolean.boolValue

        if isInSilent2State {
            self.sceneView.isHidden = true
            self.silentSceneView.isHidden = false

            let animation = CABasicAnimation(keyPath: "colorFringeStrength")
            animation.fromValue = self.silentSceneCamera.colorFringeStrength
            animation.toValue = 100
            animation.duration = 2.0
            animation.repeatCount = .infinity
            self.silentSceneCamera.addAnimation(animation, forKey: "colorFringeStrength")
            
            let rotateAction = SCNAction.rotateTo(x: 0.2, y: 0.3, z: 0.4, duration: TimeInterval(2))
            rotateAction.timingMode = SCNActionTimingMode.easeIn
            self.silentSceneBox?.runAction(rotateAction)
            
            let zoomAction = SCNAction.move(to: SCNVector3Make(0, 0, 45), duration: TimeInterval(2))
            zoomAction.timingMode = SCNActionTimingMode.easeIn
            self.silentSceneCameraNode.runAction(zoomAction)
        } else {
            self.sceneView.isHidden = false
            self.silentSceneView.isHidden = true
        }
    }

    @objc
    fileprivate func endItAll() {
        self.sceneView.isHidden = true
    }
    
    fileprivate func updateErrorState() {
        let isHidden = arc4random_uniform(2) == 1 ? false : true
        self.sceneView.isHidden = isHidden
        
        if !isHidden {
            let isErrorViewHidden = arc4random_uniform(2) == 1 ? false : true
            self.errorView.isHidden = isErrorViewHidden
            if !isErrorViewHidden {
                let horizontal = arc4random_uniform(2) == 1 ? false : true
                
                if horizontal {
                    self.errorView.frame = CGRect(
                        x: 0,
                        y: CGFloat(arc4random_uniform(UInt32(self.view.bounds.size.height))),
                        width: self.view.bounds.size.width,
                        height: CGFloat(arc4random_uniform(300))
                    )
                } else {
                    self.errorView.frame = CGRect(
                        x: CGFloat(arc4random_uniform(UInt32(self.view.bounds.size.width))),
                        y: 0,
                        width: CGFloat(arc4random_uniform(400)),
                        height: self.view.bounds.size.height
                    )
                }
                
                switch (arc4random_uniform(5)) {
                case 0:
                    self.errorView.backgroundColor = .green
                default:
                    self.errorView.backgroundColor = .black
                }
            }

            let scale = 10 + Float(arc4random_uniform(140))
            applyNoiseScaleToAllBoxes(scale: scale)
        } else {
            self.errorView.isHidden = true
        }
    }
    
    fileprivate func applyNoiseScaleToAllBoxes(scale: Float) {
        for boxNode in self.boxes {
            boxNode.geometry?.firstMaterial?.setValue(scale, forKey: "scale")
        }

        self.backgroundBox?.geometry?.firstMaterial?.setValue(scale, forKey: "scale")
    }
    
    fileprivate func createScene() -> SCNScene {
        let scene = SCNScene()
        scene.background.contents = UIColor.black

        self.camera.position = SCNVector3Make(0, 0, 58)

        scene.rootNode.addChildNode(self.camera)
        
        configureLight(scene)
        configureBoxes(scene)
        
        return scene
    }

    fileprivate func createSilentScene() -> SCNScene {
        let scene = SCNScene()
        scene.background.contents = UIColor.black
        
        self.silentSceneCameraNode.position = SCNVector3Make(0, 0, 58)
        
        scene.rootNode.addChildNode(self.silentSceneCameraNode)
        
        configureLight(scene)
        
        let box = SCNBox(width: 20, height: 20, length: 20, chamferRadius: 0)
        box.firstMaterial?.diffuse.contents = UIColor.white
        
        let boxNode = SCNNode(geometry: box)
        boxNode.position = SCNVector3Make(0, 0, 0)
        
        scene.rootNode.addChildNode(boxNode)
        
        self.silentSceneBox = boxNode
        
        return scene
    }
    
    fileprivate func configureLight(_ scene: SCNScene) {
        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        omniLightNode.light?.type = SCNLight.LightType.omni
        omniLightNode.light?.color = UIColor(white: 1.0, alpha: 1.0)
        omniLightNode.position = SCNVector3Make(0, 0, 60)
        scene.rootNode.addChildNode(omniLightNode)
    }
    
    fileprivate func configureBoxes(_ scene: SCNScene) {
        let box = SCNBox(width: 200, height: 200, length: 200, chamferRadius: 0)
        applyNoiseShader(object: box, scale: self.defaultNoiseScale)
        box.firstMaterial?.isDoubleSided = true
        
        let boxNode = SCNNode(geometry: box)
        boxNode.position = SCNVector3Make(0, 0, -90)
        self.backgroundBox = boxNode
        
        scene.rootNode.addChildNode(boxNode)
        
        scene.rootNode.addChildNode(
            createBox(position: SCNVector3Make(-20, 20, 0), scale: self.defaultNoiseScale, size: 25)
        )
        scene.rootNode.addChildNode(
            createBox(position: SCNVector3Make(25, 0, 0), scale: self.defaultNoiseScale, size: 30)
        )
        scene.rootNode.addChildNode(
            createBox(position: SCNVector3Make(-10, -15, 0), scale: self.defaultNoiseScale, size: 20)
        )
        scene.rootNode.addChildNode(
            createBox(position: SCNVector3Make(10, 10, 0), scale: self.defaultNoiseScale, size: 20)
        )
    }
    
    fileprivate func createBox(position: SCNVector3, scale: Float, size: CGFloat) -> SCNNode {
        let box = SCNBox(width: size, height: size, length: size, chamferRadius: 0)
        applyNoiseShader(object: box, scale: scale)
        
        let boxNode = SCNNode(geometry: box)
        boxNode.position = position
        
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
        
        self.boxes.append(boxNode)
        
        return boxNode
    }
    
    fileprivate func applyNoiseShader(object: SCNGeometry, scale: Float) {
        do {
            object.firstMaterial?.shaderModifiers = [
                SCNShaderModifierEntryPoint.fragment: try String(contentsOfFile: Bundle.main.path(forResource: "production_noise.shader", ofType: "fragment")!, encoding: String.Encoding.utf8)
            ]
        } catch {}
        
        object.firstMaterial?.setValue(CGPoint(x: self.view.bounds.size.width, y: self.view.bounds.size.width), forKey: "resolution")
        object.firstMaterial?.setValue(scale, forKey: "scale")
    }
}
