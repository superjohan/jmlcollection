//
//  ClubAsmConstants.swift
//  demo
//
//  Created by Johan Halin on 24/03/2019.
//  Copyright © 2019 Dekadence. All rights reserved.
//

import Foundation

struct ClubAsmConstants {
    static let bpm = 140.0
    static let barLength = (120.0 / ClubAsmConstants.bpm) * 2.0
    static let tickLength = ClubAsmConstants.barLength / 16.0
    static let animationDuration = ClubAsmConstants.barLength - (ClubAsmConstants.tickLength * 4.0)
}

struct ClubAsmPositions {
    static let start = 0
    static let startEnd = 3
    static let beatNoBasslineStart = 4
    static let beatNoBasslineEnd = 7
    static let beatBasslineStart = 8
    static let beatBasslineFill = 16
    static let raveStart = 24
    static let raveChords = 32
    static let raveMelody = 40
    static let raveEnd = 47
    static let beatBassline2Start = 48
    static let beatBassline2Fill = 55
    static let beatBassline2NoKick = 64
    static let end = 65
}
