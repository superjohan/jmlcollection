//
//  BrandViewVisioland.swift
//  demo
//
//  Created by Johan Halin on 18/03/2018.
//  Copyright © 2018 Dekadence. All rights reserved.
//

import Foundation
import UIKit

class BrandViewVisioland: UIView, BrandView {
    // MARK: - UIView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadImages(view: self, name: "visioland", count: 3)
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
        let length = Constants.barLength / 3.0
        let delay = length / 3
        
        let logo = self.subviews[2]
        logo.alpha = 0
        logo.frame.origin.y += 20
        
        UIView.animate(withDuration: length, delay: 0, options: [ .curveEaseInOut ], animations: {
            logo.alpha = 1
            logo.frame = self.bounds
        }, completion: nil)

        for i in 0..<(self.subviews.count - 1) {
            let view = self.subviews[i]
            view.alpha = 0
            view.frame.origin.y -= 80
                        
            UIView.animate(withDuration: length, delay: delay * Double(i), usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: [], animations: {
                view.alpha = 1
                view.frame = self.bounds
                view.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }
}
