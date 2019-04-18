//
//  ClubAsmMacView.swift
//  demo
//
//  Created by Johan Halin on 13/04/2019.
//  Copyright © 2019 Dekadence. All rights reserved.
//

import UIKit

class ClubAsmMacView: UIView, ClubAsmActions {
    private let alert = UIImageView()
    private var alertSelectedViews = [UIImageView]()
    private let pointer = UIImageView()
    private var destination = CGPoint(x: 52, y: 43)
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        let background = UIView(frame: self.bounds)
        background.backgroundColor = UIColor(patternImage: UIImage(named: "clubasmmacbackground")!)
        addSubview(background)
        
        let alertImage = UIImage(named: "clubasmmac")!
        self.alert.image = alertImage
        self.alert.frame = CGRect(
            x: (self.bounds.size.width / 2.0) - (alertImage.size.width / 2.0),
            y: (self.bounds.size.height / 2.0) - (alertImage.size.height / 2.0),
            width: alertImage.size.width,
            height: alertImage.size.height
        )
        addSubview(self.alert)

        self.destination = CGPoint(
            x: self.alert.frame.maxX - self.destination.x,
            y: self.alert.frame.maxY - self.destination.y
        )
        
        let alertSelectedImage = UIImage(named: "clubasmmacselected")!

        for _ in 0...9 {
            let selectedView = UIImageView(image: alertSelectedImage)
            selectedView.frame = self.alert.frame
            selectedView.isHidden = true
            addSubview(selectedView)
            
            self.alertSelectedViews.append(selectedView)
        }
        
        let pointerImage = UIImage(named: "clubasmmacpointer")!
        self.pointer.image = pointerImage
        self.pointer.frame.size = pointerImage.size
        addSubview(self.pointer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func action1() {
        self.alert.isHidden = false
        
        for view in self.alertSelectedViews {
            view.isHidden = true
            view.layer.removeAllAnimations()
            view.transform = CGAffineTransform.identity
            view.alpha = 1
        }
        
        self.pointer.frame.origin = CGPoint(x: 20, y: 20)
    }
    
    func action2() {
        self.pointer.frame.origin = CGPoint(
            x: 20 + (self.destination.x * (1.0 / 3.0)),
            y: 20 + (self.destination.y * (1.0 / 3.0))
        )
    }
    
    func action3() {
        self.pointer.frame.origin = CGPoint(
            x: 20 + (self.destination.x * (2.0 / 3.0)),
            y: 20 + (self.destination.y * (2.0 / 3.0))
        )
    }
    
    func action4() {
        self.pointer.frame.origin = self.destination
    }
    
    func action5() {
        self.alert.isHidden = true
        
        for (index, view) in self.alertSelectedViews.enumerated() {
            view.isHidden = false

            let alpha = CGFloat(index) / CGFloat(self.alertSelectedViews.count)
            let scale = 0.5 + ((1.0 - alpha) * 0.9) * 0.5
            
            UIView.animate(withDuration: 1.5, delay: 0, options: [.curveEaseOut], animations: {
                view.alpha = alpha
                view.transform = CGAffineTransform.identity.scaledBy(x: scale, y: scale)
            }, completion: nil)
        }
    }
}
