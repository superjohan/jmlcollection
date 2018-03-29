//
//  BrandViewLateqniq.swift
//  demo
//
//  Created by Johan Halin on 17/03/2018.
//  Copyright © 2018 Dekadence. All rights reserved.
//

import Foundation
import UIKit

class BrandViewLateqniq: UIView, BrandView {
    // MARK: - UIView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadImages(view: self, name: "lateqniq", count: 7)
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
        let delay = length / 6.0
        
        let logo = self.subviews[0]
        logo.alpha = 0
        logo.frame.origin.x += 20
        
        UIView.animate(withDuration: length, delay: length, options: [ .curveEaseInOut ], animations: {
            logo.alpha = 1
            logo.frame = self.bounds
        }, completion: nil)
        
        for i in 1..<self.subviews.count {
            let view = self.subviews[i]
            view.alpha = 0
            view.frame.origin.y += 20
            
            UIView.animate(withDuration: length, delay: -delay + delay * Double(i), options: [ .curveEaseInOut ], animations: {
                view.alpha = 1
                view.frame = self.bounds
            }, completion: nil)
        }
    }
}
