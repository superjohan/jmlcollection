//
//  Demo.swift
//  jmlcollection
//
//  Created by Johan Halin on 28/01/2018.
//  Copyright © 2018 Jumalauta. All rights reserved.
//

import Foundation
import UIKit

struct Demo {
    // MARK: - Information for UI
    let name: String
    let group: String
    let year: String
    
    // MARK: - Information for launching
    let viewController: (() -> UIViewController)?
    let htmlFilename: String?
}
