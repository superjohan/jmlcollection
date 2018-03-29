//
//  BrandViewYamageruto.swift
//  demo
//
//  Created by Johan Halin on 17/03/2018.
//  Copyright © 2018 Dekadence. All rights reserved.
//

import Foundation
import UIKit

class BrandViewYamageruto: UIView, BrandView {
    // MARK: - UIView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadImages(view: self, name: "yamageruto", count: 3)
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
        let length = Constants.barLength / 6.0
        let delay = length / 2.0
        
        let logo = self.subviews[0]
        logo.alpha = 0
        UIView.animate(withDuration: length, delay: delay, options: [ .curveEaseInOut ], animations: {
            logo.alpha = 1
        }, completion: nil)
        
        let line1 = self.subviews[1]
        line1.alpha = 0
        line1.frame.origin.x = -self.bounds.size.width
        UIView.animate(withDuration: length, delay: 0, options: [ .curveEaseOut ], animations: {
            line1.alpha = 1
            line1.frame = self.frame
        }, completion: nil)
        
        let line2 = self.subviews[2]
        line2.alpha = 0
        line2.frame.origin.x = self.bounds.size.width
        UIView.animate(withDuration: length, delay: 0, options: [ .curveEaseOut ], animations: {
            line2.alpha = 1
            line2.frame = self.bounds
        }, completion: nil)
    }
}
