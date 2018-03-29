//
//  BrandViewNeandertek.swift
//  demo
//
//  Created by Johan Halin on 18/03/2018.
//  Copyright © 2018 Dekadence. All rights reserved.
//

import Foundation
import UIKit

class BrandViewNeandertek: UIView, BrandView {
    // MARK: - UIView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadImages(view: self, name: "neandertek", count: 4)
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
        let length = Constants.barLength / 4.0
        let delay = length / 6.0
        
        for i in 0..<self.subviews.count {
            let view = self.subviews[i]
            view.alpha = 0
            
            UIView.animate(withDuration: 0, delay: delay * Double(i), options: [ .curveEaseInOut ], animations: {
                view.alpha = 1
            }, completion: { _ in
                UIView.animate(withDuration: length / 2, delay: 0, options: [ .curveEaseOut ], animations: {
                    view.alpha = 0
                }, completion: { _ in
                    if i == 3 {
                        for view2 in self.subviews {
                            UIView.animate(withDuration: length / 2, delay: 0, options: [ .curveEaseInOut ], animations: {
                                view2.alpha = 1
                            }, completion: nil)
                        }
                    }
                })
            })
        }
    }
}
