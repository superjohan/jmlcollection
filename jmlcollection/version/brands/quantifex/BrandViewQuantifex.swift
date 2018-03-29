//
//  BrandViewQuantifex.swift
//  demo
//
//  Created by Johan Halin on 18/03/2018.
//  Copyright © 2018 Dekadence. All rights reserved.
//

import Foundation
import UIKit

class BrandViewQuantifex: UIView, BrandView {
    // MARK: - UIView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadImages(view: self, name: "quantifex", count: 4)
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
        let delay = length / 5.0
        
        let logo = self.subviews[0]
        logo.alpha = 0
        UIView.animate(withDuration: length, delay: 0, options: [ .curveEaseInOut ], animations: {
            logo.alpha = 1
        }, completion: nil)
        
        for i in 1..<self.subviews.count {
            let view = self.subviews[i]
            view.alpha = 0
            view.transform = CGAffineTransform.init(scaleX: 0, y: 0)
            
            let delay2: TimeInterval
            if i == 1 {
                delay2 = delay * 2
            } else if i == 2 {
                delay2 = delay
            } else if i == 3 {
                delay2 = delay * 3
            } else {
                delay2 = 0
            }
            
            UIView.animate(withDuration: length, delay: delay2, options: [ .curveEaseInOut ], animations: {
                view.alpha = 1
                view.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }
}
