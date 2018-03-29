//
//  GearScene.swift
//  demo
//
//  Created by Johan Halin on 25/03/2018.
//  Copyright © 2018 Dekadence. All rights reserved.
//

import Foundation
import SceneKit

fileprivate let gearNode1 = loadModel(name: "gear", textureName: nil, color: UIColor.init(white: 0.95, alpha: 1.0))
fileprivate let gearNode2 = loadModel(name: "gear", textureName: nil, color: UIColor.init(white: 0.95, alpha: 1.0))
fileprivate var ballNode: SCNNode?

func createGearSceneCamera() -> SCNCamera {
    let camera = SCNCamera()
    camera.zFar = 300
    camera.vignettingIntensity = 1.0
    camera.vignettingPower = 1.0
    camera.colorFringeStrength = 3
    camera.motionBlurIntensity = 1.5
    
    return camera
}

func createGearScene(camera: SCNNode) -> SCNScene {
    let scene = SCNScene()
    scene.background.contents = UIColor.init(white: 1.0, alpha: 1.0)
    
    camera.position = SCNVector3Make(0, 0, 40)

    scene.rootNode.addChildNode(camera)
    
    configureLight(scene)
    
    gearNode1.position = SCNVector3Make(-15, -10.7, 0)
    gearNode1.scale = SCNVector3Make(2, 2, 2)
    scene.rootNode.addChildNode(gearNode1)
    
    gearNode2.position = SCNVector3Make(15, 10.7, 0)
    gearNode2.scale = SCNVector3Make(2, 2, 2)
    gearNode2.rotation = SCNVector4Make(0, 0, Float.pi / 4, 1)
    scene.rootNode.addChildNode(gearNode2)

    let ball = SCNSphere(radius: 20)
    ball.firstMaterial?.diffuse.contents = UIColor.black
    ballNode = SCNNode(geometry: ball)
    ballNode?.position = SCNVector3Make(0, 0, 60)
    scene.rootNode.addChildNode(ballNode!)
    
    return scene
}

fileprivate var positionIndex = -1
fileprivate let cameraPositions = [
    (position: SCNVector3Make(0, 0, 30), rotation: SCNVector4Make(0, 0, 0, 0)),
    (position: SCNVector3Make(10, 0, 30), rotation: SCNVector4Make(0, 0.05, 0, 0.25)),
    (position: SCNVector3Make(10, 10, 30), rotation: SCNVector4Make(-0.1, 0.05, 0, 0.25)),
    (position: SCNVector3Make(0, 10, 30), rotation: SCNVector4Make(-0.1, 0, 0, 0.25)),
    (position: SCNVector3Make(0, 0, 30), rotation: SCNVector4Make(0, 0, 0, 0)),
    (position: SCNVector3Make(0, -10, 30), rotation: SCNVector4Make(0.1, 0, 0, 0.25)),
    (position: SCNVector3Make(10, -10, 30), rotation: SCNVector4Make(0.1, 0.05, 0, 0.25)),
    (position: SCNVector3Make(10, 0, 30), rotation: SCNVector4Make(0, 0.05, 0, 0.25)),
    (position: SCNVector3Make(0, 0, 30), rotation: SCNVector4Make(0, 0, 0, 0)),
    (position: SCNVector3Make(-10, 0, 30), rotation: SCNVector4Make(0, -0.05, 0, 0.25)),
    (position: SCNVector3Make(-10, -10, 30), rotation: SCNVector4Make(0.1, -0.05, 0, 0.25)),
    (position: SCNVector3Make(0, -10, 30), rotation: SCNVector4Make(0.1, 0, 0, 0.25)),
    (position: SCNVector3Make(0, 0, 30), rotation: SCNVector4Make(0, 0, 0, 0)),
    (position: SCNVector3Make(0, 10, 30), rotation: SCNVector4Make(-0.1, 0, 0, 0.25)),
    (position: SCNVector3Make(-10, 10, 30), rotation: SCNVector4Make(-0.1, -0.05, 0, 0.25)),
    (position: SCNVector3Make(-10, 0, 30), rotation: SCNVector4Make(0, -0.05, 0, 0.25)),
]

func animateGearScene(camera: SCNNode) {
    positionIndex += 1
    
    if positionIndex >= cameraPositions.count {
        positionIndex = 0
    }

    let duration = Constants.beatLength / 2
    
    let cameraPositionAction = SCNAction.move(to: cameraPositions[positionIndex].position, duration: duration)
    cameraPositionAction.timingMode = .easeOut
    camera.runAction(cameraPositionAction)

    let cameraRotateAction = SCNAction.rotate(toAxisAngle: cameraPositions[positionIndex].rotation, duration: duration)
    cameraRotateAction.timingMode = .easeOut
    camera.runAction(cameraRotateAction)

    let rotateAction1 = SCNAction.rotateBy(x: 0, y: 0, z: CGFloat.pi / 4, duration: duration)
    rotateAction1.timingMode = .easeOut
    gearNode1.runAction(rotateAction1)

    let rotateAction2 = SCNAction.rotateBy(x: 0, y: 0, z: -CGFloat.pi / 4, duration: duration)
    rotateAction2.timingMode = .easeOut
    gearNode2.runAction(rotateAction2)
}

func resetCameraToGear(camera: SCNNode) {
    camera.position = cameraPositions[positionIndex].position
    camera.rotation = cameraPositions[positionIndex].rotation
}

func centerGearCamera(camera: SCNNode) {
    camera.position = SCNVector3Make(0, 0, 0)
    camera.rotation = SCNVector4Make(0, 0, 0, 0)
}

func adjustGearSceneForBall(camera: SCNNode) {
    camera.position = SCNVector3Make(0, 0, 39)
    camera.rotation = SCNVector4Make(0, 1, 0, Float.pi)
    ballNode?.position = SCNVector3Make(0, 0, 60)
    ballNode?.scale = SCNVector3Make(1, 1, 1)
}

func animateBallInGearScene() {
    ballNode?.runAction(SCNAction.move(to: SCNVector3Make(0, 0, 300), duration: Constants.beatLength * 0.75))
    ballNode?.runAction(SCNAction.scale(to: 0, duration: Constants.beatLength * 0.75))
}

fileprivate func configureLight(_ scene: SCNScene) {
    let directionalLightNode = SCNNode()
    directionalLightNode.light = SCNLight()
    directionalLightNode.light?.type = SCNLight.LightType.directional
    directionalLightNode.light?.castsShadow = true
    directionalLightNode.light?.shadowRadius = 30
    directionalLightNode.light?.shadowColor = UIColor(white: 0, alpha: 0.75)
    directionalLightNode.light?.color = UIColor(white: 1.0, alpha: 1.0)
    directionalLightNode.position = SCNVector3Make(0, 20, 40)
    directionalLightNode.rotation = SCNVector4Make(1, 0, 0, -0.75)
    scene.rootNode.addChildNode(directionalLightNode)
}

