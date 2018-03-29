//
//  BrandViewMurtelio.swift
//  demo
//
//  Created by Johan Halin on 17/03/2018.
//  Copyright © 2018 Dekadence. All rights reserved.
//

import Foundation
import UIKit

class BrandViewMurtelio: UIView, BrandView {
    // MARK: - UIView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadImages(view: self, name: "murtelio", count: 2)
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
        logo.frame.origin.x -= 40
        
        UIView.animate(withDuration: length, delay: 0, options: [ .curveEaseInOut ], animations: {
            logo.alpha = 1
            logo.frame = self.bounds
        }, completion: nil)
        
        let ball = self.subviews[1]
        ball.alpha = 0
        ball.frame.origin.x += 40
        
        UIView.animate(withDuration: length, delay: 0, options: [ .curveEaseInOut ], animations: {
            ball.alpha = 1
            ball.frame = self.bounds
        }, completion: nil)
    }
}
