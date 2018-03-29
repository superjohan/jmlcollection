//
//  BrandViewKreaten.swift
//  demo
//
//  Created by Johan Halin on 17/03/2018.
//  Copyright © 2018 Dekadence. All rights reserved.
//

import Foundation
import UIKit

class BrandViewKreaten: UIView, BrandView {
    // MARK: - UIView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadImages(view: self, name: "kreaten", count: 7)
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
            view.frame.origin.y -= self.bounds.size.height
            
            UIView.animate(withDuration: length, delay: delay * Double(self.subviews.count - i), usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
                view.alpha = 1
                view.frame = self.frame
            }, completion: nil)
        }
    }
}
