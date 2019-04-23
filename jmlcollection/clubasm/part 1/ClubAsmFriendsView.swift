//
//  ClubAsmFriendsView.swift
//  demo
//
//  Created by Johan Halin on 28/03/2019.
//  Copyright © 2019 Dekadence. All rights reserved.
//

import UIKit

class ClubAsmFriendsView: UIView, ClubAsmActions {
    private let friendsView: UIImageView

    private var interference1: InterferenceView?
    private var interference2: InterferenceView?

    private var animating = false
    
    override init(frame: CGRect) {
        guard let image = UIImage(named: "clubasmfriends") else { abort() }

        self.friendsView = UIImageView(image: image)
        
        super.init(frame: frame)
        
        self.backgroundColor = .black
        
        let length = self.bounds.size.width * 2

        self.interference1 = InterferenceView(
            frame: CGRect(
                x: (self.bounds.size.width / 2.0) - (length / 2.0),
                y: (self.bounds.size.height / 2.0) - (length / 2.0),
                width: length,
                height: length
            )
        )
        addSubview(self.interference1!)

        self.interference1?.layer.compositingFilter = "differenceBlendMode"

        self.interference2 = InterferenceView(frame: self.interference1!.frame)
        addSubview(self.interference2!)

        self.interference2?.layer.compositingFilter = "differenceBlendMode"

        self.interference1?.circleCount = 14
        self.interference1?.setNeedsDisplay()
        self.interference2?.circleCount = 14
        self.interference2?.setNeedsDisplay()

        self.friendsView.frame = CGRect(
            x: (self.bounds.size.width / 2.0) - (image.size.width / 2.0),
            y: (self.bounds.size.height / 2.0) - (image.size.height / 2.0),
            width: image.size.width,
            height: image.size.height
        )
        addSubview(self.friendsView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func action1() {
        self.friendsView.transform = CGAffineTransform.identity.scaledBy(x: 0.2, y: 0.2)

        if self.animating { return }

        self.interference1?.isHidden = true
        self.interference2?.isHidden = true
    }
    
    func action2() {
        self.friendsView.transform = CGAffineTransform.identity.scaledBy(x: 0.4, y: 0.4)
    }
    
    func action3() {
        self.friendsView.transform = CGAffineTransform.identity.scaledBy(x: 0.6, y: 0.6)
    }
    
    func action4() {
        self.friendsView.transform = CGAffineTransform.identity.scaledBy(x: 0.8, y: 0.8)
    }
    
    func action5() {
        self.friendsView.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)

        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseOut], animations: {
            self.friendsView.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
        }, completion: nil)
        
        if self.animating { return }

        self.animating = true

        self.interference1?.isHidden = false
        self.interference2?.isHidden = false

        self.interference1?.alpha = 0
        self.interference2?.alpha = 0
        
        UIView.animate(withDuration: ClubAsmConstants.tickLength * 4, delay: 0, options: [.curveEaseOut], animations: {
            self.interference1?.alpha = 1
            self.interference2?.alpha = 1
            self.backgroundColor = UIColor(red:0.507, green:0.390, blue:1.000, alpha:1.000)
        }, completion: nil)
        
        let distance = Double(self.bounds.size.height / 4.0)

        let animation = CABasicAnimation(keyPath: "position.x")
        animation.fromValue = NSNumber(floatLiteral: Double(self.bounds.size.width / 2.0) - (distance / 2.0))
        animation.toValue = NSNumber(floatLiteral: Double(self.bounds.size.width / 2.0) + (distance / 2.0))
        animation.duration = 1
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        self.interference1?.layer.add(animation, forKey: "xposition")

        let animation2 = CABasicAnimation(keyPath: "position.y")
        animation2.fromValue = NSNumber(floatLiteral: Double(self.bounds.size.height / 2.0) - (distance / 2.0))
        animation2.toValue = NSNumber(floatLiteral: Double(self.bounds.size.height / 2.0) + (distance / 2.0))
        animation2.duration = 0.9
        animation2.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation2.autoreverses = true
        animation2.repeatCount = Float.infinity
        self.interference1?.layer.add(animation2, forKey: "yposition")

        let animation3 = CABasicAnimation(keyPath: "position.x")
        animation3.fromValue = NSNumber(floatLiteral: Double(self.bounds.size.width / 2.0 ) + (distance / 2.0))
        animation3.toValue = NSNumber(floatLiteral: Double(self.bounds.size.width / 2.0) - (distance / 2.0))
        animation3.duration = 0.8
        animation3.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation3.autoreverses = true
        animation3.repeatCount = Float.infinity
        self.interference2?.layer.add(animation3, forKey: "xposition")
        
        let animation4 = CABasicAnimation(keyPath: "position.y")
        animation4.fromValue = NSNumber(floatLiteral: Double(self.bounds.size.height / 2.0 ) + (distance / 2.0))
        animation4.toValue = NSNumber(floatLiteral: Double(self.bounds.size.height / 2.0) - (distance / 2.0))
        animation4.duration = 1.1
        animation4.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation4.autoreverses = true
        animation4.repeatCount = Float.infinity
        self.interference2?.layer.add(animation4, forKey: "yposition")
    }
    
    private class InterferenceView: UIView {
        var circleCount: Int = -1

        private let fullCircleCount: Int

        private let thickness = CGFloat(20)
        
        override init(frame: CGRect) {
            self.fullCircleCount = 30

            super.init(frame: frame)
            
            self.backgroundColor = .clear
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func draw(_ rect: CGRect) {
            guard let context = UIGraphicsGetCurrentContext() else { return }

            context.setLineWidth(self.thickness)
            context.setStrokeColor(UIColor.green.cgColor)
            
            let count: Int
            if self.circleCount >= 0 {
                count = self.circleCount
            } else {
                count = self.fullCircleCount
            }

            for i in 0..<count {
                let base = self.thickness * CGFloat(2)
                let length = base + ((base * 2) * CGFloat(i))
                
                context.strokeEllipse(in:
                    CGRect(
                        x: (frame.size.width / 2.0) - (length / 2.0),
                        y: (frame.size.height / 2.0) - (length / 2.0),
                        width: length,
                        height: length
                    )
                )
            }
        }
    }
}
