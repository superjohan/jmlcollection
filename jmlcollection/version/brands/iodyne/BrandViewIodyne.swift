//
//  BrandViewIodyne.swift
//  demo
//
//  Created by Johan Halin on 17/03/2018.
//  Copyright © 2018 Dekadence. All rights reserved.
//

import Foundation
import UIKit

class BrandViewIodyne: UIView, BrandView {
    // MARK: - UIView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadImages(view: self, name: "iodyne", count: 4)
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
        UIView.animate(withDuration: length, delay: 0, options: [ .curveEaseInOut ], animations: {
            logo.alpha = 1
        }, completion: nil)
        
        for i in 1..<self.subviews.count {
            let view = self.subviews[i]
            view.alpha = 0
            view.transform = CGAffineTransform.init(rotationAngle: -CGFloat(Double.pi / 4))
            
            UIView.animate(withDuration: length, delay: delay * Double(i), options: [ .curveEaseOut ], animations: {
                view.alpha = 1
                view.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }
}
