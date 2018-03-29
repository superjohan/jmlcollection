//
//  BrandViewUltrox.swift
//  demo
//
//  Created by Johan Halin on 17/03/2018.
//  Copyright © 2018 Dekadence. All rights reserved.
//

import Foundation
import UIKit

class BrandViewUltrox: UIView, BrandView {
    // MARK: - UIView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadImages(view: self, name: "ultrox", count: 3)
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
        let length = Constants.barLength / 5
        let delay = length / 3
        let base = self.subviews[2]
        base.alpha = 0
        
        UIView.animate(withDuration: length, delay: 0, options: [ .curveEaseInOut ], animations: {
            base.alpha = 1
        }, completion: nil)
        
        for i in 0..<(self.subviews.count - 1) {
            let view = self.subviews[i]
            view.alpha = 0
            
            if i % 2 == 0 {
                view.frame.origin.y -= 20
            } else {
                view.frame.origin.y += 20
            }

            UIView.animate(withDuration: length, delay: delay * Double(i), options: [ .curveEaseInOut ], animations: {
                view.alpha = 1
                view.frame = self.bounds
            }, completion: nil)
        }
    }
}
