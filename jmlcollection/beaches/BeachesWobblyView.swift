//
//  BeachesWobblyView.swift
//  demo
//
//  Created by Johan Halin on 14/05/2019.
//  Copyright © 2019 Dekadence. All rights reserved.
//

import UIKit

class BeachesWobblyView: UIView {
    private var images = [UIView]()
    
    init(frame: CGRect, tintColor: UIColor, singleImage: Bool) {
        super.init(frame: frame)
        
        if singleImage {
            let image = UIImage(named: "beaches")!.withRenderingMode(.alwaysTemplate)
            let imageView = UIImageView(image: image)
            imageView.frame = self.bounds
            imageView.tintColor = tintColor
            imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            imageView.contentMode = .scaleAspectFit
            addSubview(imageView)
            
            self.images.append(imageView)
        } else {
            for i in 1...12 {
                let image = UIImage(named: "beaches\(i)")!.withRenderingMode(.alwaysTemplate)
                let imageView = UIImageView(image: image)
                imageView.frame = self.bounds
                imageView.tintColor = tintColor
                imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                imageView.isHidden = true
                imageView.contentMode = .scaleAspectFit
                addSubview(imageView)
                
                self.images.append(imageView)
            }
        }
    }
    
    func showImage(index: Int) {
        self.images[index].isHidden = false
    }
    
    func animate() {
        let centerY = Double(self.bounds.size.height / 2.0)

        for view in self.images {
            let animation2 = CABasicAnimation(keyPath: "position.y")
            animation2.fromValue = NSNumber(floatLiteral: centerY + 60)
            animation2.toValue = NSNumber(floatLiteral: centerY - 60)
            animation2.duration = 0.5
            animation2.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            animation2.autoreverses = true
            animation2.repeatCount = Float.infinity
            view.layer.add(animation2, forKey: "yposition")

            let animation = CABasicAnimation(keyPath: "transform.rotation")
            animation.fromValue = NSNumber(floatLiteral: -(Double.pi / 16.0))
            animation.toValue = NSNumber(floatLiteral: Double.pi / 16.0)
            animation.duration = 1
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
            animation.autoreverses = true
            animation.repeatCount = Float.infinity
            view.layer.add(animation, forKey: "rotation")
        }
    }
    
    func moreBounce() {
        for view in self.images {
            let animation2 = CABasicAnimation(keyPath: "transform.scale")
            animation2.fromValue = NSNumber(floatLiteral: 1)
            animation2.toValue = NSNumber(floatLiteral: 1.25)
            animation2.duration = 0.5
            animation2.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            animation2.autoreverses = true
            animation2.repeatCount = Float.infinity
            view.layer.add(animation2, forKey: "scale")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
