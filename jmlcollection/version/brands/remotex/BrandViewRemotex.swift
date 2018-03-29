//
//  BrandViewRemotex.swift
//  demo
//
//  Created by Johan Halin on 18/03/2018.
//  Copyright © 2018 Dekadence. All rights reserved.
//

import Foundation
import UIKit

class BrandViewRemotex: UIView, BrandView {
    // MARK: - UIView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadImages(view: self, name: "remotex", count: 3)
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
        let length = Constants.barLength / 8

        for view in self.subviews {
            view.alpha = 0
        }

        let view1 = self.subviews[2]
        let view2 = self.subviews[1]
        let view3 = self.subviews[0]
        
        UIView.animate(withDuration: length, delay: 0, options: [ .curveEaseInOut ], animations: {
            view1.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: length, delay: 0, options: [ .curveEaseInOut ], animations: {
                view1.alpha = 0
                view2.alpha = 1
            }, completion: { _ in
                UIView.animate(withDuration: length, delay: 0, options: [ .curveEaseInOut ], animations: {
                }, completion: { _ in
                    view2.alpha = 0
                    view3.alpha = 1
                })
            })
        })
    }
}
