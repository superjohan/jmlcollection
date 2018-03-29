//
//  BrandViewSeptogon.swift
//  demo
//
//  Created by Johan Halin on 18/03/2018.
//  Copyright © 2018 Dekadence. All rights reserved.
//

import Foundation
import UIKit

class BrandViewSeptogon: UIView, BrandView {
    // MARK: - UIView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadImages(view: self, name: "septogon", count: 2)
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
        
        for i in 0..<self.subviews.count {
            let view = self.subviews[i]
            view.alpha = 0

            if i % 2 == 0 {
                view.frame.origin.y -= 40
            } else {
                view.frame.origin.y += 40
            }
            
            view.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
            
            UIView.animate(withDuration: length, delay: 0, options: [ .curveEaseInOut ], animations: {
                view.alpha = 1
                view.frame = self.bounds
                view.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }
}
