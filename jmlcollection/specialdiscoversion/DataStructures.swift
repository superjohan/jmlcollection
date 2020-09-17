//
//  DemoDictionary.swift
//  demo
//
//  Created by Johan Halin on 13.9.2020.
//  Copyright © 2020 Dekadence. All rights reserved.
//

import Foundation

struct DemoDictionary {
    static let words = [
        [
            "Special",
            "Super",
            "Original",
            "Euro",
            "American",
            "Midnight",
            "Disconet",
        ],
        [
            "Disco",
            "12-inch",
            "7-inch",
            "Dance",
            "Album",
            "Single",
            "Extended",
            "Club",
        ],
        [
            "Version",
            "Mix",
            "Edit",
            "Remix",
            "Dub"
        ]
    ]
}

struct SoundtrackStructure {
    static let length = 37
    static let modifierStart = 5
    static let backgroundStart = 9
    static let quietHit1 = 26
    static let quietHit2 = 28
    static let loudHit1 = 30
    static let loudHit2 = 32
    static let loudHit3 = 34
    static let end = 35
    static let endActual = 36
}

struct SoundtrackConfig {
    static let bpm = 120.0
    static let barLength = (120.0 / bpm) * 2.0
    static let tickLength = barLength / 16.0
}
