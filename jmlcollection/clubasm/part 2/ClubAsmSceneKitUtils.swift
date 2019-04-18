//
//  ClubAsmSceneKitUtils.swift
//  demo
//
//  Created by Johan Halin on 04/04/2019.
//  Copyright © 2019 Dekadence. All rights reserved.
//

import UIKit
import SceneKit

func loadModel(name: String, textureName: String?, color: UIColor?) -> SCNNode {
    guard let filePath = Bundle.main.path(forResource: name, ofType: "dae", inDirectory: "") else { abort() }
    let referenceURL = URL(fileURLWithPath: filePath)
    guard let referenceNode = SCNReferenceNode(url: referenceURL) else { abort() }
    referenceNode.load()
    
    if let textureName = textureName {
        let boatImage: UIImage? = UIImage(named: textureName)
        let childNodes = referenceNode.childNodes
        for childNode in childNodes {
            childNode.geometry?.firstMaterial = SCNMaterial()
            childNode.geometry?.firstMaterial?.diffuse.contents = boatImage
        }
    } else if let color = color {
        setColorInChildnodes(node: referenceNode, color: color)
    }
    
    return referenceNode
}

func setColorInChildnodes(node: SCNNode, color: UIColor) {
    let childNodes = node.childNodes
    for childNode in childNodes {
        childNode.geometry?.firstMaterial = SCNMaterial()
        childNode.geometry?.firstMaterial?.diffuse.contents = color
        
        setColorInChildnodes(node: childNode, color: color)
    }
}

func applyShader(object: SCNGeometry, shaderName: String, size: CGSize) {
    do {
        object.firstMaterial?.shaderModifiers = [
            SCNShaderModifierEntryPoint.fragment: try String(contentsOfFile: Bundle.main.path(forResource: shaderName, ofType: "fsh")!, encoding: String.Encoding.utf8)
        ]
    } catch {}
    
    object.firstMaterial?.setValue(CGPoint(x: size.width, y: size.height), forKey: "resolution")
}
