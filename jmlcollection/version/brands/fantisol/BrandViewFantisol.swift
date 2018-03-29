//
//  BrandViewFantisol.swift
//  demo
//
//  Created by Johan Halin on 17/03/2018.
//  Copyright © 2018 Dekadence. All rights reserved.
//

import Foundation
import UIKit

class BrandViewFantisol: UIView, BrandView {
    // MARK: - UIView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadImages(view: self, name: "fantisol", count: 1)
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
        let length = Constants.barLength / 4
        
        let logo = self.subviews[0]
        logo.alpha = 0
        logo.layer.transform = CATransform3DRotate(CATransform3DIdentity, CGFloat.pi, 1, 0, 0)
        
        UIView.animate(withDuration: length, delay: 0, options: [ .curveEaseOut ], animations: {
            logo.alpha = 1
            logo.layer.transform = CATransform3DIdentity
        }, completion: nil)
    }
}
