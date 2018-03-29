//
//  MainScene.swift
//  demo
//
//  Created by Johan Halin on 25/03/2018.
//  Copyright © 2018 Dekadence. All rights reserved.
//

import Foundation
import SceneKit

func createMainSceneCamera() -> SCNCamera {
    let camera = SCNCamera()
    camera.zFar = 600
    camera.vignettingIntensity = 1
    camera.vignettingPower = 1
    camera.colorFringeStrength = 3
    camera.bloomIntensity = 0.5
    camera.bloomBlurRadius = 20
    camera.wantsHDR = true
    
    return camera
}

fileprivate let cameraDuration = Constants.beatLength * 4
fileprivate var cameraPositionIndex = 0
fileprivate var cameras = [
    (position: SCNVector3Make(-50, 2, 40), rotation: SCNVector4Make(0, 0, 0, 0), fieldOfView: CGFloat(80)),
    (position: SCNVector3Make(-50, 2, 20), rotation: SCNVector4Make(0, 0, 0, 0), fieldOfView: CGFloat(80)),
    (position: SCNVector3Make(-10, 50, -5), rotation: SCNVector4Make(1, 0, 0.3, -Float.pi / 2), fieldOfView: CGFloat(80)),
    (position: SCNVector3Make(10, 50, -5), rotation: SCNVector4Make(1, 0, 0.1, -Float.pi / 2), fieldOfView: CGFloat(80)),
    (position: SCNVector3Make(-40, 5, -5), rotation: SCNVector4Make(0, 1, 0, -Float.pi / 2), fieldOfView: CGFloat(80)),
    (position: SCNVector3Make(-40, 25, -5), rotation: SCNVector4Make(0, 1, 0, -Float.pi / 2), fieldOfView: CGFloat(80)),
    (position: SCNVector3Make(-40, 2, -40), rotation: SCNVector4Make(0, 1, 0, -Float.pi), fieldOfView: CGFloat(80)),
    (position: SCNVector3Make(-20, 2, -40), rotation: SCNVector4Make(0, 1, 0, -Float.pi), fieldOfView: CGFloat(80)),
    (position: SCNVector3Make(60, 10, -15), rotation: SCNVector4Make(-0.1, 1, 0, Float.pi / 2), fieldOfView: CGFloat(80)),
    (position: SCNVector3Make(40, 20, -15), rotation: SCNVector4Make(-0.2, 0.5, 0, Float.pi / 2), fieldOfView: CGFloat(80)),
    (position: SCNVector3Make(48, 2, 40), rotation: SCNVector4Make(0, 0, 0, 0), fieldOfView: CGFloat(80)),
    (position: SCNVector3Make(38, 20, 20), rotation: SCNVector4Make(1, 0, 0, -Float.pi / 6), fieldOfView: CGFloat(80)),
    (position: SCNVector3Make(10, 10, 0), rotation: SCNVector4Make(-0.2, 1, 0, -Float.pi / 8), fieldOfView: CGFloat(80)),
    (position: SCNVector3Make(10, 20, 0), rotation: SCNVector4Make(-0.2, 1, 0, (Float.pi / 2) - (Float.pi / 8)), fieldOfView: CGFloat(80)),
    (position: SCNVector3Make(0, 10, 5), rotation: SCNVector4Make(0, 0, 0, 0), fieldOfView: CGFloat(80)),
    (position: SCNVector3Make(0, 30, 45), rotation: SCNVector4Make(1, 0, 0, -Float.pi / 8), fieldOfView: CGFloat(80)),
]

func createMainScene(camera: SCNNode) -> SCNScene {
    let scene = SCNScene()
    scene.background.contents = UIColor.init(white: 0.42, alpha: 1)
    scene.rootNode.addChildNode(camera)
    
    configureLight(scene)
    
    let factory = loadModel(name: "tehras", textureName: nil, color: UIColor.init(white: 0.8, alpha: 1.0))
    factory.scale = SCNVector3Make(2, 2, 2)
    factory.rotation = SCNVector4Make(1, 0, 0, -Float.pi / 2)
    factory.pivot = SCNMatrix4MakeTranslation(50, 10, 0)
    factory.position = SCNVector3Make(0, -1.5, 0)
    scene.rootNode.addChildNode(factory)
    
    let box2 = SCNBox(width: 200, height: 100, length: 200, chamferRadius: 0)
    box2.firstMaterial?.diffuse.contents = UIColor.gray
    
    let boxNode2 = SCNNode(geometry: box2)
    boxNode2.position = SCNVector3Make(0, -51, 0)
    
    scene.rootNode.addChildNode(boxNode2)
    
    return scene
}

func resetMainSceneCamera(camera: SCNNode) {
    camera.position = SCNVector3Make(0, 0, 0)
    camera.rotation = SCNVector4Make(0, 0, 0, 0)
}

func adjustMainSceneCamera(camera: SCNNode) {
    camera.position = cameras[cameraPositionIndex].position
    camera.rotation = cameras[cameraPositionIndex].rotation
    camera.camera?.fieldOfView = cameras[cameraPositionIndex].fieldOfView

    let cameraMoveAction = SCNAction.move(to: cameras[cameraPositionIndex + 1].position, duration: cameraDuration)
    cameraMoveAction.timingMode = SCNActionTimingMode.linear
    camera.runAction(cameraMoveAction)
    
    let cameraRotateAction = SCNAction.rotate(toAxisAngle: cameras[cameraPositionIndex + 1].rotation, duration: cameraDuration)
    cameraRotateAction.timingMode = cameraMoveAction.timingMode
    camera.runAction(cameraRotateAction)
    
    camera.isPaused = true
    
    cameraPositionIndex += 2
}

fileprivate func configureLight(_ scene: SCNScene) {
    let directionalLightNode = SCNNode()
    directionalLightNode.light = SCNLight()
    directionalLightNode.light?.type = SCNLight.LightType.directional
    directionalLightNode.light?.castsShadow = true
    directionalLightNode.light?.shadowRadius = 30
    directionalLightNode.light?.shadowColor = UIColor(white: 0, alpha: 0.75)
    directionalLightNode.light?.color = UIColor(white: 1.0, alpha: 1.0)
    directionalLightNode.position = SCNVector3Make(-10, 20, 40)
    directionalLightNode.rotation = SCNVector4Make(1, -0.2, 0, -0.75)
    scene.rootNode.addChildNode(directionalLightNode)
    
    let omniLightNode = SCNNode()
    omniLightNode.light = SCNLight()
    omniLightNode.light?.type = SCNLight.LightType.ambient
    omniLightNode.light?.color = UIColor(white: 0.1, alpha: 1.0)
    scene.rootNode.addChildNode(omniLightNode)
}
