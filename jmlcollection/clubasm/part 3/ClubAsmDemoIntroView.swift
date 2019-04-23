//
//  ClubAsmDemoIntroView.swift
//  demo
//
//  Created by Johan Halin on 09/04/2019.
//  Copyright © 2019 Dekadence. All rights reserved.
//

import UIKit

class ClubAsmDemoIntroView: UIView, ClubAsmActions {
    var images1 = [UIView]()
    var images2 = [UIView]()
    var images3 = [UIView]()
    var images4 = [UIView]()

    var segments = [UIView]()
    
    var counter = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white

        loadImages(index: 1, views: &self.images1)
        loadImages(index: 2, views: &self.images2)
        loadImages(index: 3, views: &self.images3)
        loadImages(index: 4, views: &self.images4)
        
        for i in 0...4 {
            let view = UIView(frame:
                CGRect(
                    x: CGFloat(i) * (self.bounds.size.width / 4.0),
                    y: 0,
                    width: self.bounds.size.width / 4.0,
                    height: self.bounds.size.height
                )
            )
            view.backgroundColor = .white
            addSubview(view)
            
            self.segments.append(view)
        }
    }
    
    private func loadImages(index: Int, views: inout [UIView]) {
        for i in 1...3 {
            let image = UIImage(named: "clubasmcompo\(index)-\(i)")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            let imageView = UIImageView(image: image)
            imageView.tintColor = .white
            imageView.frame = self.bounds
            imageView.contentMode = .scaleAspectFit
            imageView.layer.compositingFilter = "differenceBlendMode"
            imageView.isHidden = true
            addSubview(imageView)
            
            views.append(imageView)

            addAnimationsToViews(views: views)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func action1() {
        if self.counter > 0 {
            animateSegment(index: 0)
        }
    }
    
    func action2() {
        if self.counter > 0 {
            animateSegment(index: 1)
        }
    }
    
    func action3() {
        if self.counter > 0 {
            animateSegment(index: 2)
        }
    }
    
    func action4() {
        if self.counter > 0 {
            animateSegment(index: 3)
        }
    }
    
    func action5() {
        for view in self.segments {
            view.backgroundColor = .white
            view.isHidden = true
        }

        for i in 0...2 {
            self.images1[i].isHidden = true
            self.images2[i].isHidden = true
            self.images3[i].isHidden = true
            self.images4[i].isHidden = true
        }

        switch self.counter {
        case 0:
            for view in self.images1 {
                view.isHidden = false
            }
            
            self.counter += 1
        case 1:
            for view in self.images2 {
                view.isHidden = false
            }
            
            self.counter += 1
        case 2:
            for view in self.images3 {
                view.isHidden = false
            }
            
            self.counter += 1
        case 3:
            for view in self.images4 {
                view.isHidden = false
            }
            
            self.counter = 0
        default:
            abort()
        }
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
    
    private func animateSegment(index: Int) {
        let view = self.segments[index]
        view.isHidden = false

        UIView.animate(withDuration: ClubAsmConstants.tickLength, delay: 0, options: [.curveEaseOut], animations: {
            view.backgroundColor = .black
        }, completion: nil)
    }
}
