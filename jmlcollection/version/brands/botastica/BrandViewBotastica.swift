//
//  BrandViewBotastica.swift
//  demo
//
//  Created by Johan Halin on 18/03/2018.
//  Copyright © 2018 Dekadence. All rights reserved.
//

import Foundation
import UIKit

class BrandViewBotastica: UIView, BrandView {
    // MARK: - UIView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadImages(view: self, name: "botastica", count: 2)
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
        let delay = length / 2.0
        
        let ball = self.subviews[0]
        ball.alpha = 0
        ball.frame.origin.y = ball.frame.origin.y - 80
        UIView.animate(withDuration: length, delay: delay, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            ball.alpha = 1
            ball.frame = self.frame
        }, completion: nil)
        
        let logo = self.subviews[1]
        logo.alpha = 0
        UIView.animate(withDuration: length, delay: 0, options: [ .curveEaseInOut ], animations: {
            logo.alpha = 1
        }, completion: nil)
    }
}
