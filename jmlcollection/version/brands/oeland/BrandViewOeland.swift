//
//  BrandViewOeland.swift
//  demo
//
//  Created by Johan Halin on 18/03/2018.
//  Copyright © 2018 Dekadence. All rights reserved.
//

import Foundation
import UIKit

class BrandViewOeland: UIView, BrandView {
    // MARK: - UIView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadImages(view: self, name: "oeland", count: 2)
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
        let delay = length / 4.0
        
        let square = self.subviews[0]
        square.alpha = 0
        square.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        
        UIView.animate(withDuration: length, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: [], animations: {
            square.alpha = 1
            square.transform = CGAffineTransform.identity
        }, completion: nil)
        
        let logo = self.subviews[1]
        logo.alpha = 0
        
        UIView.animate(withDuration: length, delay: delay, options: [ .curveEaseInOut ], animations: {
            logo.alpha = 1
        }, completion: nil)
    }
}
