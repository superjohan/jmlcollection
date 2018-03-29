//
//  BrandViewOventus.swift
//  demo
//
//  Created by Johan Halin on 18/03/2018.
//  Copyright © 2018 Dekadence. All rights reserved.
//

import Foundation
import UIKit

class BrandViewOventus: UIView, BrandView {
    // MARK: - UIView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadImages(view: self, name: "oventus", count: 2)
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
        logo.frame.origin.y = -self.bounds.size.height
        
        UIView.animate(withDuration: length, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: [], animations: {
            logo.alpha = 1
            logo.frame = self.bounds
        }, completion: nil)
        
        let slogan = self.subviews[1]
        slogan.alpha = 0
        
        UIView.animate(withDuration: length, delay: delay, options: [ .curveEaseInOut ], animations: {
            slogan.alpha = 1
        }, completion: nil)
    }
}
