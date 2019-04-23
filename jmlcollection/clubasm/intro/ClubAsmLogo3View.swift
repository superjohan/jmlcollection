//
//  ClubAsmLogo3View.swift
//  demo
//
//  Created by Johan Halin on 13/04/2019.
//  Copyright © 2019 Dekadence. All rights reserved.
//

import UIKit

class ClubAsmLogo3View: UIView, ClubAsmActions {
    var redImages = [UIImageView]()
    var greenImages = [UIImageView]()
    var blueImages = [UIImageView]()
    
    let redContainer = UIView(frame: .zero)
    let greenContainer = UIView(frame: .zero)
    let blueContainer = UIView(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
     
        self.backgroundColor = .white
        
        for i in 1...5 {
            let image = UIImage(named: "clubasmlogo3-\(i)")!.withRenderingMode(.alwaysTemplate)
            
            for j in 0...2 {
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFit
                imageView.frame = self.bounds
                imageView.isHidden = true
                
                if j == 0 {
                    imageView.tintColor = .red
                    self.redImages.append(imageView)
                    self.redContainer.addSubview(imageView)
                } else if j == 1 {
                    imageView.tintColor = .green
                    self.greenImages.append(imageView)
                    self.greenContainer.addSubview(imageView)
                } else if j == 2 {
                    imageView.tintColor = .blue
                    self.blueImages.append(imageView)
                    self.blueContainer.addSubview(imageView)
                } else {
                    abort()
                }
            }
        }
        
        self.redContainer.frame = self.bounds
        self.redContainer.layer.compositingFilter = "multiplyBlendMode"
        self.greenContainer.frame = self.bounds
        self.greenContainer.layer.compositingFilter = "multiplyBlendMode"
        self.blueContainer.frame = self.bounds
        self.blueContainer.layer.compositingFilter = "multiplyBlendMode"

        addSubview(self.redContainer)
        addSubview(self.greenContainer)
        addSubview(self.blueContainer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func action1() {
        for i in 0...4 {
            setImageHidden(true, index: i)
        }
        
        self.redContainer.layer.removeAllAnimations()
        self.greenContainer.layer.removeAllAnimations()
        self.blueContainer.layer.removeAllAnimations()

        setImageHidden(false, index: 0)
    }
    
    func action2() {
        setImageHidden(false, index: 1)
    }
    
    func action3() {
        setImageHidden(false, index: 2)
    }
    
    func action4() {
        setImageHidden(false, index: 3)
    }
    
    func action5() {
        setImageHidden(false, index: 4)
        
        addAnimationsToViews(views: [self.redContainer, self.greenContainer, self.blueContainer])
    }
    
    private func setImageHidden(_ isHidden: Bool, index: Int) {
        self.redImages[index].isHidden = isHidden
        self.greenImages[index].isHidden = isHidden
        self.blueImages[index].isHidden = isHidden
    }
    
    private func addAnimationsToViews(views: [UIView]) {
        let centerX = Double(self.bounds.size.width / 2.0)
        let centerY = Double(self.bounds.size.height / 2.0)
        
        for (index, view) in views.enumerated() {
            let duration1: TimeInterval
            let duration2: TimeInterval
            
            switch index {
            case 0:
                duration1 = 0.5
                duration2 = 0.4
            case 1:
                duration1 = 0.4
                duration2 = 0.6
            case 2:
                duration1 = 0.6
                duration2 = 0.3
            default:
                abort()
            }
            
            let animation = CABasicAnimation(keyPath: "position.x")
            animation.fromValue = NSNumber(floatLiteral: centerX - 10)
            animation.toValue = NSNumber(floatLiteral: centerX + 10)
            animation.duration = duration1
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            animation.autoreverses = true
            animation.repeatCount = Float.infinity
            view.layer.add(animation, forKey: "xposition")
            
            let animation2 = CABasicAnimation(keyPath: "position.y")
            animation2.fromValue = NSNumber(floatLiteral: centerY - 10)
            animation2.toValue = NSNumber(floatLiteral: centerY + 10)
            animation2.duration = duration2
            animation2.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            animation2.autoreverses = true
            animation2.repeatCount = Float.infinity
            view.layer.add(animation2, forKey: "yposition")
        }
    }
}
