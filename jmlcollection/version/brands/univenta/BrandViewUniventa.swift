//
//  BrandViewUniventa.swift
//  demo
//
//  Created by Johan Halin on 18/03/2018.
//  Copyright © 2018 Dekadence. All rights reserved.
//

import Foundation
import UIKit

class BrandViewUniventa: UIView, BrandView {
    // MARK: - UIView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadImages(view: self, name: "univenta", count: 2)
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
        
        let logo = self.subviews[1]
        logo.alpha = 0
        logo.frame.origin.x += 20
        
        UIView.animate(withDuration: length, delay: length / 2, options: [ .curveEaseInOut ], animations: {
            logo.alpha = 1
            logo.frame = self.bounds
        }, completion: nil)
        
        let icon = self.subviews[0]
        icon.alpha = 0
        icon.transform = CGAffineTransform.init(rotationAngle: -CGFloat.pi / 4)
        
        UIView.animate(withDuration: length, delay: 0, options: [ .curveEaseOut ], animations: {
            icon.alpha = 1
            icon.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}
