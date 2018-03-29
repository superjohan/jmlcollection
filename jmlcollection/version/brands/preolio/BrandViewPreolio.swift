//
//  BrandViewPreolio.swift
//  demo
//
//  Created by Johan Halin on 17/03/2018.
//  Copyright © 2018 Dekadence. All rights reserved.
//

import Foundation
import UIKit

class BrandViewPreolio: UIView, BrandView {
    // MARK: - UIView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadImages(view: self, name: "preolio", count: 7)
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
        let delay = length / 8.0
        
        for i in 0..<self.subviews.count {
            let view = self.subviews[i]
            view.alpha = 0
            view.frame.origin.y = i % 2 == 0 ? -self.bounds.size.height : self.bounds.size.height
            
            UIView.animate(withDuration: length, delay: delay * Double(i), options: [ .curveEaseInOut ], animations: {
                view.alpha = 1
                view.frame = self.bounds
            }, completion: nil)
        }
    }
}
