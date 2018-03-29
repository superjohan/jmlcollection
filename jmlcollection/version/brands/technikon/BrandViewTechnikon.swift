//
//  BrandViewTechnikon.swift
//  demo
//
//  Created by Johan Halin on 18/03/2018.
//  Copyright © 2018 Dekadence. All rights reserved.
//

import Foundation
import UIKit

class BrandViewTechnikon: UIView, BrandView {
    // MARK: - UIView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadImages(view: self, name: "technikon", count: 1)
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
        let view = self.subviews[0]
        view.alpha = 0
        view.transform = CGAffineTransform.init(scaleX: 3.0, y: 1.3)
        
        UIView.animate(withDuration: length, delay: 0, options: [ .curveEaseInOut ], animations: {
            view.alpha = 1
            view.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}
