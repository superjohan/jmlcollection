//
//  InterfaceController.swift
//  watchfarjan Extension
//
//  Created by Johan Halin on 19/09/2018.
//  Copyright © 2018 Jumalauta. All rights reserved.
//

import WatchKit
import Foundation
import AVFoundation


class InterfaceController: WKInterfaceController {
    var audioPlayer: AVAudioPlayer?

    @IBOutlet var scnInterface: WKInterfaceSCNScene!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if let trackUrl = Bundle.main.url(forResource: "farjan", withExtension: "m4a") {
            guard let audioPlayer = try? AVAudioPlayer(contentsOf: trackUrl) else {
                abort()
            }
            
            self.audioPlayer = audioPlayer
            self.audioPlayer?.numberOfLoops = 999999999
        } else {
            abort()
        }

        let scene = createScene()
        
        self.scnInterface.scene = scene
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()

        self.audioPlayer?.play()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    fileprivate func createScene() -> SCNScene {
        let scene = SCNScene()
        scene.background.contents = UIColor(red: 153.0 / 255.0, green: 153.0 / 255.0, blue: 204.0 / 255.0, alpha: 1.0)
        
        let camera = SCNCamera()
        camera.zFar = 600
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3Make(0, 0, 20)
        
        scene.rootNode.addChildNode(cameraNode)
        
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
            
            let boatImage: UIImage? = UIImage(named: "paatti.jpg")
            let childNodes = referenceNode?.childNodes
            for childNode in childNodes! {
                childNode.geometry?.firstMaterial = SCNMaterial()
                childNode.geometry?.firstMaterial?.diffuse.contents = boatImage
            }
            
            referenceNode?.position = SCNVector3Make(0, -2, 0)
            
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
