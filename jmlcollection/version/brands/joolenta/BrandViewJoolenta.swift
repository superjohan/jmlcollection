//
//  BrandViewJoolenta.swift
//  demo
//
//  Created by Johan Halin on 17/03/2018.
//  Copyright © 2018 Dekadence. All rights reserved.
//

import Foundation
import UIKit

class BrandViewJoolenta: UIView, BrandView {
    // MARK: - UIView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadImages(view: self, name: "joolenta", count: 2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - BrandView
    
    func showBrand() {
        for view in self.subviews {
            view.isHidden = false
        }
    }
    
    func animateBrand() {
        let length = Constants.barLength / 5.0
        let delay = length / 3.0

        let logo = self.subviews[0]
        logo.alpha = 0
        logo.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi / 4))
        
        UIView.animate(withDuration: length, delay: 0, options: [ .curveEaseInOut ], animations: {
            logo.alpha = 1
            logo.transform = CGAffineTransform.identity
        }, completion: nil)

        let cloud = self.subviews[1]
        cloud.alpha = 0
        cloud.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        
        UIView.animate(withDuration: length, delay: delay, options: [ .curveEaseInOut ], animations: {
            cloud.alpha = 1
            cloud.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}
