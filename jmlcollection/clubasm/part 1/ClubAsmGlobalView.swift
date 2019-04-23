//
//  ClubAsmRotationView.swift
//  demo
//
//  Created by Johan Halin on 26/03/2019.
//  Copyright © 2019 Dekadence. All rights reserved.
//

import UIKit

class ClubAsmGlobalView: UIView, ClubAsmActions {
    private let imageCount = 8
    
    private var imageViews = [UIImageView]()
    private var circle: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        let diameter = self.bounds.size.height + 50
        self.circle = ClubAsmUtils.circleImageView(diameter: diameter, color: UIColor(red: 0, green: 1, blue: 0, alpha: 0.3))
        self.circle?.frame.origin = CGPoint(
            x: (self.bounds.size.width / 2.0) - (diameter / 2.0),
            y: (self.bounds.size.height / 2.0) - (diameter / 2.0)
        )
        self.circle?.transform = CGAffineTransform.identity.scaledBy(x: 0, y: 0)
        addSubview(self.circle!)
        
        guard let image = UIImage(named: "clubasmglobal") else { return }
        
        for _ in 0..<self.imageCount {
            let imageView = UIImageView(image: image)
            imageView.bounds = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            imageView.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
            imageView.frame.origin.x = self.bounds.size.width / 2.0
            imageView.frame.origin.y = (self.bounds.size.height / 2.0) - (imageView.bounds.size.height / 2.0)
            addSubview(imageView)
            
            self.imageViews.append(imageView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func action1() {
        resetAllViews()
        
        self.imageViews[0].isHidden = false
        self.imageViews[0].transform = CGAffineTransform.identity.rotated(by: -CGFloat.pi / 2.0)
    }
    
    func action2() {
        resetAllViews()

        self.imageViews[0].isHidden = false
        self.imageViews[0].transform = CGAffineTransform.identity.rotated(by: 0)
    }
    
    func action3() {
        resetAllViews()

        self.imageViews[0].isHidden = false
        self.imageViews[0].transform = CGAffineTransform.identity.rotated(by: CGFloat.pi / 2.0)
    }
    
    func action4() {
        resetAllViews()

        self.imageViews[0].isHidden = false
        self.imageViews[0].transform = CGAffineTransform.identity.rotated(by: CGFloat.pi)
    }
    
    func action5() {
        for (index, view) in self.imageViews.enumerated() {
            view.isHidden = false
            view.transform = CGAffineTransform.identity.rotated(by: -CGFloat.pi / 2.0)
            
            let animation = CABasicAnimation(keyPath: "transform.rotation")
            animation.toValue = NSNumber(floatLiteral: Double(index) * (Double.pi / (Double(self.imageViews.count) / 2)))
            animation.duration = ClubAsmConstants.animationDuration
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false
            view.layer.add(animation, forKey: "rotation")
        }
        
        UIView.animate(withDuration: ClubAsmConstants.animationDuration, delay: 0, options: [.curveEaseOut], animations: {
            self.circle?.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    private func resetAllViews() {
        for view in self.imageViews {
            view.isHidden = true
            view.layer.removeAllAnimations()
        }
        
        self.circle?.transform = CGAffineTransform.identity.scaledBy(x: 0, y: 0)
    }
}
