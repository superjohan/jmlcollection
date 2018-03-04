//
//  FfViewController.swift
//  finlandsfarjan
//
//  Created by Johan Halin on 03/03/2018.
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
import SceneKit
import AVFoundation

class FfViewController: UIViewController {
    let audioPlayer: AVAudioPlayer
    let sceneView = SCNView()
    let camera = SCNNode()

    init() {
        if let trackUrl = Bundle.main.url(forResource: "farjan", withExtension: "m4a") {
            guard let audioPlayer = try? AVAudioPlayer(contentsOf: trackUrl) else {
                abort()
            }
            
            self.audioPlayer = audioPlayer
            self.audioPlayer.numberOfLoops = 9999999999
        } else {
            abort()
        }
        
        let camera = SCNCamera()
        camera.zFar = 600
        self.camera.camera = camera // lol

        super.init(nibName: nil, bundle: nil)

        self.view.addSubview(self.sceneView)
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
        
        self.sceneView.scene = createScene()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sceneView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        self.sceneView.isPlaying = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.audioPlayer.play()
        
        let scroller = UILabel(frame: CGRect.zero)
        scroller.text = "Welcome to Jumalauta 18 Years party 24.-26.8.2018 at Hauho in potentially sunny Finland! We have cabins and good times! If you're in Sweden, take the dang titular finlandsfärjan. Greets to everyone at Instanssi 2018 and everyone who's been at the Jumalauta party before! See you there! This remake was made by Ylvaes, Tohtori Kannabispiikki, and Paasikivi-Kekkosen Linja. The 2006 original was made by Anteeksi, Maitotuote, Saksan Perussanasto, and Ylvaes."
        scroller.font = UIFont.init(name: "Superclarendon-Black", size: 36)
        scroller.backgroundColor = .clear
        scroller.textColor = UIColor(red: 0.7, green: 0.7, blue: 1.0, alpha: 1.0)
        scroller.sizeToFit()
        self.view.addSubview(scroller)
        
        scroller.frame = CGRect(x: self.view.bounds.size.width, y: self.view.bounds.size.height - scroller.bounds.size.height - 10, width: scroller.bounds.size.width, height: scroller.bounds.size.height)
        UIView.animate(withDuration: 45, delay: 0, options: [UIViewAnimationOptions.repeat, UIViewAnimationOptions.curveLinear], animations: {
            scroller.frame = CGRect(x: -scroller.bounds.size.width, y: self.view.bounds.size.height - 10, width: scroller.bounds.size.width, height: scroller.bounds.size.height)
        })
    }
        
    fileprivate func createScene() -> SCNScene {
        let scene = SCNScene()
        scene.background.contents = UIColor(red: 153.0 / 255.0, green: 153.0 / 255.0, blue: 204.0 / 255.0, alpha: 1.0)
        
        self.camera.position = SCNVector3Make(0, 0, 20)
        
        scene.rootNode.addChildNode(self.camera)
        
        configureLight(scene)
        
        let sun = SCNSphere(radius: 7)
        sun.firstMaterial?.diffuse.contents = UIColor.yellow
        let sunNode = SCNNode(geometry: sun)
        sunNode.position = SCNVector3Make(16, 12, -10)
        scene.rootNode.addChildNode(sunNode)
        
        let ground = SCNBox(width: 100, height: 50, length: 20, chamferRadius: 10)
        ground.firstMaterial?.diffuse.contents = UIColor.green
        let groundNode = SCNNode(geometry: ground)
        groundNode.position = SCNVector3Make(0, -22, -15)
        scene.rootNode.addChildNode(groundNode)
        addRotateMoveActions(node: groundNode, moveBy: SCNVector3Make(0, 1, 0), moveDuration: 6, rotateBy: SCNVector3Make(0, 0, 0), rotateDuration: 7)

        let water = SCNBox(width: 100, height: 50, length: 20, chamferRadius: 10)
        water.firstMaterial?.diffuse.contents = UIColor(red: 80.0 / 255.0, green: 80.0 / 255.0, blue: 1, alpha: 0.95)
        let waterNode = SCNNode(geometry: water)
        waterNode.position = SCNVector3Make(0, -28, 0)
        scene.rootNode.addChildNode(waterNode)
        addRotateMoveActions(node: waterNode, moveBy: SCNVector3Make(0, 0.4, 0), moveDuration: 5, rotateBy: SCNVector3Make(0, 0.2, 0.01), rotateDuration: 6)

        if let filePath = Bundle.main.path(forResource: "paatti", ofType: "dae", inDirectory: "") {
            let referenceURL = URL(fileURLWithPath: filePath)
            let referenceNode = SCNReferenceNode(url: referenceURL)
            referenceNode?.load()
            
            referenceNode?.runAction(
                SCNAction.rotateBy(
                    x: 3.14159 * 1.5 - 0.1,
                    y: -0.05,
                    z: -0.2,
                    duration: 0
                )
            )

            let boatImage: UIImage? = UIImage(named: "paatti")
            let childNodes = referenceNode?.childNodes
            for childNode in childNodes! {
                childNode.geometry?.firstMaterial = SCNMaterial()
                childNode.geometry?.firstMaterial?.diffuse.contents = boatImage
            }
            
            referenceNode?.position = SCNVector3Make(-5, -2, 0)
            
            let moveAction = SCNAction.moveBy(x: 0, y: -2, z: 0, duration: 2)
            moveAction.timingMode = SCNActionTimingMode.easeInEaseOut
            
            if let node = referenceNode {
                addRotateMoveActions(node: node, moveBy: SCNVector3Make(0, -2, 0), moveDuration: 3, rotateBy: SCNVector3Make(0.2, 0.1, 0.4), rotateDuration: 3)
            }
            
            scene.rootNode.addChildNode(referenceNode!)
        }
        
        return scene
    }

    fileprivate func addRotateMoveActions(node: SCNNode, moveBy: SCNVector3, moveDuration: TimeInterval, rotateBy: SCNVector3, rotateDuration: TimeInterval) {
        let moveAction = SCNAction.moveBy(x: CGFloat(moveBy.x), y: CGFloat(moveBy.y), z: CGFloat(moveBy.z), duration: moveDuration)
        moveAction.timingMode = SCNActionTimingMode.easeInEaseOut
        
        let moveReverseAction = moveAction.reversed()
        let sequence = SCNAction.sequence([moveAction, moveReverseAction])
        
        node.runAction(
            SCNAction.repeatForever(
                sequence
            )
        )
        
        let rotateAction = SCNAction.rotateBy(x: CGFloat(rotateBy.x), y: CGFloat(rotateBy.y), z: CGFloat(rotateBy.z), duration: rotateDuration)
        rotateAction.timingMode = SCNActionTimingMode.easeInEaseOut
        
        let rotateReverseAction = rotateAction.reversed()
        let rotateSequence = SCNAction.sequence([rotateAction, rotateReverseAction])
        
        node.runAction(
            SCNAction.repeatForever(
                rotateSequence
            )
        )
    }
    
    fileprivate func configureLight(_ scene: SCNScene) {
        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        omniLightNode.light?.type = SCNLight.LightType.omni
        omniLightNode.light?.color = UIColor(white: 1.0, alpha: 1.0)
        omniLightNode.position = SCNVector3Make(0, 0, 60)
        scene.rootNode.addChildNode(omniLightNode)
    }
}

