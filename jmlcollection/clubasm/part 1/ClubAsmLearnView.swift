//
//  ClubAsmLearnView.swift
//  demo
//
//  Created by Johan Halin on 02/04/2019.
//  Copyright © 2019 Dekadence. All rights reserved.
//

import UIKit

class ClubAsmLearnView: UIView, ClubAsmActions {
    private var images = [UIImageView]()

    private let bg = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .black
        
        self.bg.frame = self.bounds
        self.bg.clipsToBounds = true
        
        let bgLeft = UIView(frame: CGRect(x: 0, y: 0, width: self.bg.bounds.size.width / 2.0, height: self.bg.bounds.size.height))
        bgLeft.backgroundColor = UIColor(red:0.121, green:0.125, blue:0.130, alpha:1.000)
        self.bg.addSubview(bgLeft)
        
        let bgRight = UIView(frame: CGRect(x: self.bg.bounds.size.width / 2.0, y: 0, width: self.bg.bounds.size.width / 2.0, height: self.bg.bounds.size.height))
        bgRight.backgroundColor = UIColor(red:0.292, green:0.220, blue:0.695, alpha:1.000)
        self.bg.addSubview(bgRight)

        self.bg.layer.zPosition = -500
        
        addSubview(self.bg)

        for _ in 0..<5 {
            guard let image = UIImage(named: "clubasmlearn") else { return }
            let imageView = UIImageView(image: image)
            imageView.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
            imageView.frame = CGRect(
                x: self.bounds.size.width / 2.0,
                y: (self.bounds.size.height / 2.0) - (image.size.height / 2.0),
                width: image.size.width,
                height: image.size.height
            )
            imageView.layer.zPosition = 500
            addSubview(imageView)
            
            self.images.append(imageView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func action1() {
        for view in self.images {
            view.layer.transform = CATransform3DIdentity
            view.layer.transform.m34 = -0.002
        }
        
        self.bg.layer.transform = CATransform3DIdentity
        self.bg.layer.transform.m34 = -0.002
        self.bg.layer.transform = CATransform3DRotate(self.bg.layer.transform, CGFloat.pi / 2.0, 0, 1, 0)
        
        animate(index: 0)
    }
    
    func action2() {
        animate(index: 1)
    }
    
    func action3() {
        animate(index: 2)
    }
    
    func action4() {
        animate(index: 3)
    }
    
    func action5() {
        animate(index: 4)

        UIView.animate(withDuration: ClubAsmConstants.animationDuration, delay: 0, options: [.curveEaseOut], animations: {
            self.bg.layer.transform = CATransform3DIdentity
        }, completion: nil)
    }
    
    private func animate(index: Int) {
        let view = self.images[index]
        let duration = index < 4 ? 0.4 : ClubAsmConstants.animationDuration
        
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut], animations: {
            view.layer.transform = CATransform3DRotate(view.layer.transform, CGFloat.pi, 0, 1, 0)
        }, completion: nil)
    }
}
