//
//  BrandViewFreemo.swift
//  demo
//
//  Created by Johan Halin on 17/03/2018.
//  Copyright © 2018 Dekadence. All rights reserved.
//

import Foundation
import UIKit

class BrandViewFreemo: UIView, BrandView {
    // MARK: - UIView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadImages(view: self, name: "freemo", count: 6)
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
            view.frame.origin.x = self.bounds.size.width
            
            UIView.animate(withDuration: length, delay: delay * Double(i), options: [ .curveEaseInOut ], animations: {
                view.alpha = 1
                view.frame.origin.x = 0
            }, completion: nil)
        }
    }
}
