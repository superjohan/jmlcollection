//
//  ClubAsmLocalView.swift
//  demo
//
//  Created by Johan Halin on 26/03/2019.
//  Copyright © 2019 Dekadence. All rights reserved.
//

import UIKit

class ClubAsmLocalView: UIView, ClubAsmActions {
    private let imageCount = 12
    
    private var imageViews = [UIImageView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .black
        
        guard let filled = UIImage(named: "clubasmlocalfilled") else { return }
        let filledImage = UIImageView(image: filled)
        filledImage.frame = CGRect(
            x: (self.bounds.size.width / 2.0) - (filled.size.width / 2.0),
            y: 0,
            width: filled.size.width,
            height: filled.size.height
        )
        addSubview(filledImage)
        self.imageViews.append(filledImage)
        
        guard let outline = UIImage(named: "clubasmlocaloutline") else { return }
        
        for _ in 1..<self.imageCount {
            let outlineImage = UIImageView(image: outline)
            outlineImage.frame = filledImage.frame
            outlineImage.isHidden = true
            addSubview(outlineImage)
            self.imageViews.append(outlineImage)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func action1() {
        for (index, view) in self.imageViews.enumerated() {
            if index > 0 {
                view.isHidden = true
            }
        }
        
        self.imageViews[0].frame.origin.y = self.bounds.size.height - self.imageViews[0].bounds.size.height
    }
    
    func action2() {
        self.imageViews[0].frame.origin.y = (self.bounds.size.height - self.imageViews[0].bounds.size.height) * (2.0 / 3.0)
    }
    
    func action3() {
        self.imageViews[0].frame.origin.y = (self.bounds.size.height - self.imageViews[0].bounds.size.height) * (1.0 / 3.0)
    }
    
    func action4() {
        self.imageViews[0].frame.origin.y = 0
    }
    
    func action5() {
        for (index, view) in self.imageViews.enumerated() {
            view.isHidden = false
            view.frame.origin.y = self.bounds.size.height - view.bounds.size.height

            if index > 0 {
                let i = index - 1
                let y = -view.bounds.size.height
                let distance = (self.bounds.size.height - view.bounds.size.height) - y
                
                UIView.animate(withDuration: ClubAsmConstants.animationDuration, delay: 0, options: [.curveEaseOut], animations: {
                    view.frame.origin.y = y + (distance * (CGFloat(i) / CGFloat(self.imageViews.count - 1)))
                }, completion: nil)
            }
        }
    }
}
