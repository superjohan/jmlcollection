//
//  BrandViewWebtraks.swift
//  demo
//
//  Created by Johan Halin on 17/03/2018.
//  Copyright © 2018 Dekadence. All rights reserved.
//

import Foundation
import UIKit

class BrandViewWebtraks: UIView, BrandView {
    // MARK: - UIView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadImages(view: self, name: "webtraks", count: 2)
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
        
        let logo = self.subviews[0]
        logo.alpha = 0
        logo.frame.origin.x -= 20
        
        UIView.animate(withDuration: length, delay: 0, options: [ .curveEaseInOut ], animations: {
            logo.alpha = 1
            logo.frame = self.bounds
        }, completion: nil)
        
        let cursor = self.subviews[1]
        cursor.alpha = 0
        var visible = true
        
        UIView.animate(withDuration: length / 2, delay: length / 2, options: [ .curveEaseInOut, .repeat ], animations: {
            cursor.alpha = visible ? 1 : 0
            cursor.frame = self.bounds
            visible = !visible
        }, completion: nil)
    }
}
