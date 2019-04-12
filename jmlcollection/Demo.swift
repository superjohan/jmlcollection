//
//  Demo.swift
//  jmlcollection
//
//  Copyright 2018 Johan Halin.
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

import Foundation
import UIKit

struct Demo {
    struct Requirements: OptionSet {
        let rawValue: Int
        static let metal_v4 = Requirements(rawValue: 1 << 0) // Metal, with feature set 4 or higher (iPhone XS or higher)
    }
	
    // MARK: - Information for UI
    let name: String
    let group: String
    let year: String
    let requirements: Requirements?
    
    // MARK: - Information for launching
    let viewController: (() -> UIViewController)?
    let htmlFilename: String?
}
