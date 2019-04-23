//
//  ClubAsmCubeView.swift
//  demo
//
//  Created by Johan Halin on 03/04/2019.
//  Copyright © 2019 Dekadence. All rights reserved.
//

import UIKit

class ClubAsmDefeatView: UIView, ClubAsmActions {
    private var imageViews = [UIView]()
    private let bg = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .black
        
        self.bg.frame = self.bounds
        addSubview(self.bg)
        
        for i in 0...4 {
            let height = self.bounds.size.height / 5.0
            let segmentFrame = CGRect(
                x: 0,
                y: CGFloat(i) * height,
                width: self.bounds.size.width,
                height: height
            )
            let segment = UIView(frame: segmentFrame)
            segment.backgroundColor = UIColor(white: 0.2, alpha: 1)
            segment.alpha = 0
            self.bg.addSubview(segment)
        }
        
        let image = UIImage(named: "clubasmdefeat")!
        
        for _ in 0...20 {
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(
                x: (self.bounds.size.width / 2.0) - (image.size.width / 2.0),
                y: (self.bounds.size.height / 2.0) - (image.size.height / 2.0),
                width: image.size.width,
                height: image.size.height
            )
            addSubview(imageView)
            
            self.imageViews.append(imageView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var animating = false
    
    func action1() {
        animateSegment(0)
        
        if self.animating { return }
        
        self.animating = true
        
        for (index, view) in self.imageViews.enumerated() {
            view.alpha = 0
            view.layer.transform.m34 = -0.002
            view.frame.origin.y = -view.bounds.size.height
            view.layer.transform = CATransform3DRotate(view.layer.transform, -(CGFloat.pi), 1, 0, 0)
            
            let duration = ClubAsmConstants.barLength * 2
            let delay = Double(index) * 0.3

            UIView.animate(withDuration: duration, delay: delay, options: [.curveLinear], animations: {
                view.frame.origin.y = 375
                view.layer.transform = CATransform3DRotate(view.layer.transform, CGFloat.pi, 1, 0, 0)
            }, completion: nil)
            
            UIView.animate(withDuration: duration, delay: delay, options: [.curveEaseInOut], animations: {
                view.alpha = 1
            }, completion: nil)
        }
    }
    
    func action2() {
        animateSegment(1)
    }
    
    func action3() {
        animateSegment(2)
    }
    
    func action4() {
        animateSegment(3)
    }
    
    func action5() {
        animateSegment(4)
    }
    
    private func animateSegment(_ index: Int) {
        let view = self.bg.subviews[index]
        
        view.alpha = 1
        
        UIView.animate(withDuration: ClubAsmConstants.animationDuration, delay: 0, options: [.curveEaseOut], animations: {
            view.alpha = 0
        }, completion: nil)
    }
}
