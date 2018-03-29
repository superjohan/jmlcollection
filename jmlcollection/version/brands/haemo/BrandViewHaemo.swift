//
//  BrandViewHaemo.swift
//  demo
//
//  Created by Johan Halin on 17/03/2018.
//  Copyright © 2018 Dekadence. All rights reserved.
//

import Foundation
import UIKit

class BrandViewHaemo: UIView, BrandView {
    // MARK: - UIView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadImages(view: self, name: "haemo", count: 2)
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
        
        UIView.animate(withDuration: length, delay: 0, options: [ .curveEaseInOut ], animations: {
            logo.alpha = 1
        }, completion: nil)
        
        let swoosh = self.subviews[1]
        swoosh.alpha = 0
        swoosh.transform = CGAffineTransform.init(scaleX: 0, y: 1)
        swoosh.frame.origin.x -= 200
        
        UIView.animate(withDuration: length, delay: length / 2, options: [ .curveEaseInOut ], animations: {
            swoosh.alpha = 1
            swoosh.transform = CGAffineTransform.identity
            swoosh.frame = self.bounds
        }, completion: nil)
    }
}
