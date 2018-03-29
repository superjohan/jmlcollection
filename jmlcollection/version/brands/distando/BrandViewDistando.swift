//
//  BrandViewDistando.swift
//  demo
//
//  Created by Johan Halin on 17/03/2018.
//  Copyright © 2018 Dekadence. All rights reserved.
//

import Foundation
import UIKit

class BrandViewDistando: UIView, BrandView {
    // MARK: - UIView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadImages(view: self, name: "distando", count: 3)
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
        let delay = length / 2.0

        let logo = self.subviews[0]
        logo.alpha = 0
        logo.frame.origin.y = logo.frame.origin.y - 20
        UIView.animate(withDuration: length, delay: delay, options: [ .curveEaseInOut ], animations: {
            logo.alpha = 1
            logo.frame = self.frame
        }, completion: nil)

        let line = self.subviews[1]
        line.alpha = 0
        UIView.animate(withDuration: length, delay: 0, options: [ .curveEaseInOut ], animations: {
            line.alpha = 1
            line.frame = self.frame
        }, completion: nil)

        let slogan = self.subviews[2]
        slogan.alpha = 0
        slogan.frame.origin.y = slogan.frame.origin.y + 20
        UIView.animate(withDuration: length, delay: delay * 2, options: [ .curveEaseInOut ], animations: {
            slogan.alpha = 1
            slogan.frame = self.frame
        }, completion: nil)
    }
}
