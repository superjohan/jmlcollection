//
//  BrandViewCromteq.swift
//  demo
//
//  Created by Johan Halin on 17/03/2018.
//  Copyright © 2018 Dekadence. All rights reserved.
//

import Foundation
import UIKit

class BrandViewCromteq: UIView, BrandView {
    // MARK: - UIView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadImages(view: self, name: "cromteq", count: 10)
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
        
        for i in 0..<3 {
            let view = self.subviews[i]
            view.alpha = 0
            let offset = i % 2 == 0 ? CGFloat(20) : CGFloat(-20)
            view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y + offset, width: view.frame.size.width, height: view.frame.size.height)
            
            UIView.animate(withDuration: length, delay: 0, options: [ .curveEaseOut ], animations: {
                view.alpha = 1
                view.frame = self.frame
            }, completion: nil)
        }

        let delay = length / 8.0

        for i in 3..<10 {
            let view = self.subviews[i]
            view.alpha = 0
            
            UIView.animate(withDuration: length, delay: (length / 2.0) + delay * Double(i), options: [ .curveEaseOut ], animations: {
                view.alpha = 1
            }, completion: nil)
        }
    }
}
