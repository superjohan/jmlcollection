//
//  BrandViewSantafelos.swift
//  demo
//
//  Created by Johan Halin on 18/03/2018.
//  Copyright © 2018 Dekadence. All rights reserved.
//

import Foundation
import UIKit

class BrandViewSantafelos: UIView, BrandView {
    // MARK: - UIView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadImages(view: self, name: "santafelos", count: 1)
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
        let length = Constants.barLength / 6
        let view = self.subviews[0]
        view.alpha = 0
        view.frame.origin.x = -self.bounds.size.width
        
        UIView.animate(withDuration: length, delay: 0, options: [ .curveEaseOut ], animations: {
            view.alpha = 1
            view.frame = self.bounds
            view.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi / 6))
        }, completion: { _ in
            UIView.animate(withDuration: length, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: [], animations: {
                view.transform = CGAffineTransform.identity
            }, completion: nil)
        })
    }
}
