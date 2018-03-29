//
//  BrandViewAntiflex.swift
//  demo
//
//  Created by Johan Halin on 17/03/2018.
//  Copyright © 2018 Dekadence. All rights reserved.
//

import Foundation
import UIKit

class BrandViewAntiflex: UIView, BrandView {
    // MARK: - UIView
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        loadImages(view: self, name: "antiflex", count: 8)
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
        let delay = length / 8.0

        for i in 0..<self.subviews.count {
            let view = self.subviews[i]
            view.alpha = 0
            let offset = CGFloat((Double(i + 1) * 20.0))
            view.frame = CGRect(x: view.frame.origin.x - offset, y: view.frame.origin.y, width: view.frame.size.width, height: view.frame.size.height)
            
            UIView.animate(withDuration: length, delay: delay * Double(i), options: [ .curveEaseOut ], animations: {
                view.alpha = 1
                view.frame = self.frame
            }, completion: nil)
        }
    }
}
