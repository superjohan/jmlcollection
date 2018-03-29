//
//  MiddleScene.swift
//  demo
//
//  Created by Johan Halin on 25/03/2018.
//  Copyright © 2018 Dekadence. All rights reserved.
//

import Foundation
import SceneKit

fileprivate var factoryNode: SCNNode?

func createMiddleSceneCamera() -> SCNCamera {
    let camera = SCNCamera()
    camera.zFar = 400
    camera.colorFringeStrength = 6

    return camera
}

func createMiddleScene(camera: SCNNode, size: CGSize) -> SCNScene {
    let scene = SCNScene()
    scene.background.contents = UIColor.black

    camera.position = SCNVector3Make(0, 0, 50)
    camera.isPaused = true
    
    scene.rootNode.addChildNode(camera)

    configureLight(scene)
    
    let backgroundBox = SCNBox(width: 900, height: 500, length: 10, chamferRadius: 0)
    applyNoiseShader(object: backgroundBox, scale: 50, size: size)

    let backgroundBoxNode = SCNNode(geometry: backgroundBox)
    backgroundBoxNode.position = SCNVector3Make(0, 0, -300)
    
    scene.rootNode.addChildNode(backgroundBoxNode)

    let factory = loadModel(name: "tehdas", textureName: nil, color: UIColor.init(white: 0.4, alpha: 1))
    factory.scale = SCNVector3Make(2.5, 2.5, 2.5)
    factory.position = SCNVector3Make(0, -8, 0)
    factory.pivot = SCNMatrix4MakeTranslation(8, 0, 0)
    scene.rootNode.addChildNode(factory)
    factoryNode = factory
    
    factory.runAction(
        SCNAction.repeatForever(
            SCNAction.rotateBy(
                x: 0,
                y: CGFloat.pi * 2,
                z: 0,
                duration: 5
            )
        )
    )

    return scene
}

func setFactoryHidden(_ isHidden: Bool) {
    if isHidden {
        factoryNode?.runAction(SCNAction.fadeOut(duration: 0.1))
    } else {
        factoryNode?.runAction(SCNAction.fadeIn(duration: 0.1))
    }
}

fileprivate func configureLight(_ scene: SCNScene) {
    let lightNode = SCNNode()
    lightNode.light = SCNLight()
    lightNode.light?.type = SCNLight.LightType.ambient
    lightNode.light?.color = UIColor(white: 1.0, alpha: 1.0)
    scene.rootNode.addChildNode(lightNode)
}

fileprivate func applyNoiseShader(object: SCNGeometry, scale: Float, size: CGSize) {
    do {
        object.firstMaterial?.shaderModifiers = [
            SCNShaderModifierEntryPoint.fragment: try String(contentsOfFile: Bundle.main.path(forResource: "versionnoise.shader", ofType: "fragment")!, encoding: String.Encoding.utf8)
        ]
    } catch {}
    
    object.firstMaterial?.setValue(CGPoint(x: size.width, y: size.width), forKey: "resolution")
    object.firstMaterial?.setValue(scale, forKey: "scale")
}
