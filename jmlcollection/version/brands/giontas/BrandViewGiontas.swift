//
//  BrandViewGiontas.swift
//  demo
//
//  Created by Johan Halin on 17/03/2018.
//  Copyright © 2018 Dekadence. All rights reserved.
//

import Foundation
import UIKit

class BrandViewGiontas: UIView, BrandView {
    // MARK: - UIView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        loadImages(view: self, name: "giontas", count: 4)
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
        let delay = length / 6.0
        
        let logo = self.subviews[0]
        logo.alpha = 0
        UIView.animate(withDuration: length, delay: length, options: [ .curveEaseOut ], animations: {
            logo.alpha = 1
        }, completion: nil)

        for i in 1..<self.subviews.count {
            let view = self.subviews[i]
            view.alpha = 0
            view.frame.origin.y += 20
            
            UIView.animate(withDuration: length, delay: -delay + delay * Double(i), options: [ .curveEaseOut ], animations: {
                view.alpha = 1
                view.frame.origin.y = self.bounds.origin.y
            }, completion: nil)
        }
    }
}
