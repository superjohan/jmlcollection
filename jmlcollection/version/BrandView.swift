//
//  BrandView.swift
//  demo
//
//  Created by Johan Halin on 17/03/2018.
//  Copyright © 2018 Dekadence. All rights reserved.
//

import Foundation
import UIKit

protocol BrandView {
    func showBrand()
    func animateBrand()
}

func loadImages(view: UIView, name: String, count: Int) {
    for i in 1...count {
        let imageView = UIImageView(image: UIImage(named: "\(name)\(i)"))
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
    }
}
