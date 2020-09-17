//
//  Modifiers.swift
//  demo
//
//  Created by Johan Halin on 14.9.2020.
//  Copyright © 2020 Dekadence. All rights reserved.
//

import Foundation
import UIKit

let modifierRange = CGFloat(10)...CGFloat(30)

enum Modifier: Equatable {
    case none
    case modifyX
    case modifyY
    case modifyXModifyY
    case random
    case rotate2d
    case rotate3d
}

func generateModifierList() -> [Modifier] {
    let shortestSequence = DemoDictionary.words[0].min(by: { $0.count < $1.count })!.count
        + DemoDictionary.words[1].min(by: { $0.count < $1.count })!.count
        + DemoDictionary.words[2].min(by: { $0.count < $1.count })!.count
        + 2 // "spaces"
    let length = (SoundtrackStructure.length * 16) - SoundtrackStructure.modifierStart
    let sequenceCount = length / shortestSequence

    let allModifiers: [Modifier] = [
        .none,
        .modifyX,
        .modifyY,
        .modifyXModifyY,
        .random,
        .rotate2d,
        .rotate3d,
    ]

    var modifiers = [Modifier]()

    for _ in 0..<sequenceCount {
        var contentsOk = false
        var shuffledModifiers: [Modifier] = []

        while !contentsOk {
            let mods = allModifiers.shuffled()

            if let lastMod = modifiers.last {
                if mods.last != lastMod {
                    shuffledModifiers = mods
                    contentsOk = true
                }
            } else {
                shuffledModifiers = mods
                contentsOk = true
            }
        }

        modifiers.append(contentsOf: shuffledModifiers)
    }

    return modifiers
}

func randomRange() -> CGFloat {
    return CGFloat.random(in: modifierRange) * CGFloat(Bool.random() ? -1 : 1)
}
