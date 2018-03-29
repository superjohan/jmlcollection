//
//  BrandViewEftua.swift
//  demo
//
//  Created by Johan Halin on 17/03/2018.
//  Copyright © 2018 Dekadence. All rights reserved.
//

import Foundation
import UIKit

class BrandViewEftua: UIView, BrandView {
    // MARK: - UIView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadImages(view: self, name: "eftua", count: 5)
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
        let delay = length / 5
        
        for i in 0..<self.subviews.count {
            let view = self.subviews[i]
            view.alpha = 0
            view.layer.transform = CATransform3DRotate(CATransform3DIdentity, CGFloat.pi / 2, 1, 0, 0)
            
            UIView.animate(withDuration: length, delay: Double(i) * delay, options: [ .curveEaseOut ], animations: {
                view.alpha = 1
                view.layer.transform = CATransform3DIdentity
            }, completion: nil)
        }
    }
}
