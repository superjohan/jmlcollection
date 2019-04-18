//
//  ClubAsmCompoCirclesTwoView.swift
//  demo
//
//  Created by Johan Halin on 14/04/2019.
//  Copyright © 2019 Dekadence. All rights reserved.
//

import UIKit

class ClubAsmCompoCirclesView: UIView, ClubAsmActions {
    private var images = [UIView]()
    private var maskedImages = [UIView]()
    private var position = 0
    private let maskOffset: CGFloat = 100
    private var circleViews = [MaskedCircleView]()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .white

        let offset: CGFloat = 300
        let circlesFrame = CGRect(
            x: offset / 2.0,
            y: (self.bounds.size.height / 2.0) - (self.bounds.size.width / 2.0) + (offset / 2.0),
            width: self.bounds.size.width - offset,
            height: self.bounds.size.width - offset
        )
        let color = UIColor(red:1.000, green:0.867, blue:0.010, alpha:0.6)
        let circles1 = MaskedCircleView(
            frame: circlesFrame,
            circleSize: circlesFrame.width,
            color: color,
            direction: .vertical
        )
        addSubview(circles1)
        
        let circles2 = MaskedCircleView(
            frame: circlesFrame,
            circleSize: circlesFrame.width,
            color: color,
            direction: .horizontal
        )
        addSubview(circles2)
        
        self.circleViews.append(circles1)
        self.circleViews.append(circles2)

        for i in 1...4 {
            let index = i < 4 ? i : i + 1
            let image = UIImage(named: "clubasmcompo_4-\(index)")!
            let imageView = UIImageView(image: image)
            imageView.frame = self.bounds
//            imageView.alpha = 1.0
            let maskedView = UIView(frame: self.bounds)
            maskedView.addSubview(imageView)
            addSubview(maskedView)
            
            switch i {
            case 1:
                imageView.frame.origin.y += 40
                imageView.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 4)
            case 2:
                imageView.frame.origin.y += 70
                imageView.transform = CGAffineTransform.identity.scaledBy(x: 1.5, y: 5)
            case 3:
                imageView.frame.origin.y += 420
                imageView.transform = CGAffineTransform.identity.scaledBy(x: 1.5, y: 5)
            case 4:
                imageView.frame.origin.y += 420
                imageView.transform = CGAffineTransform.identity.scaledBy(x: 1.5, y: 5)
            default:
                abort()
            }
            
            let circleImage = circle(diameter: 50, color: .black)
            let circles = UIView(frame: CGRect(origin: .zero, size: CGSize(width: self.bounds.size.width + 100, height: self.bounds.size.height)))
            circles.backgroundColor = UIColor(patternImage: circleImage)
            maskedView.mask = circles
            maskedView.isHidden = true

            self.maskedImages.append(maskedView)
        }
        
        for i in 1...6 {
            let container = UIView(frame: self.bounds)
            container.isHidden = true
            
            let shadowImage = UIImage(named: "clubasmcompo_4-\(i)")!.withRenderingMode(.alwaysTemplate)
            let shadowImageView = UIImageView(image: shadowImage)
            shadowImageView.tintColor = self.backgroundColor
            shadowImageView.frame = self.bounds
            shadowImageView.frame.origin.x += 2
            shadowImageView.frame.origin.y += 2
            shadowImageView.contentMode = .scaleAspectFit
            container.addSubview(shadowImageView)
            
            let image = UIImage(named: "clubasmcompo_4-\(i)")!
            let imageView = UIImageView(image: image)
            imageView.frame = self.bounds
            imageView.contentMode = .scaleAspectFit
            container.addSubview(imageView)
            
            addSubview(container)
            
            self.images.append(container)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func action1() {
        for view in self.images {
            view.isHidden = true
            view.frame = self.bounds
        }
        
        for view in self.maskedImages {
            view.isHidden = true
            view.mask?.frame.origin.x = 0
            view.frame.origin.x = 0
        }
        
        for view in self.circleViews {
            view.isHidden = true
            view.reset()
        }
        
        self.maskedImages[self.position].isHidden = false
        self.maskedImages[self.position].frame.origin.x -= self.maskOffset / 4.0
        
        UIView.animate(withDuration: ClubAsmConstants.tickLength * 4.0, delay: 0, options: [.curveLinear], animations: {
            self.maskedImages[self.position].mask?.frame.origin.x -= self.maskOffset
            self.maskedImages[self.position].frame.origin.x += self.maskOffset / 2.0
        }, completion: nil)
        
        self.maskedImages[self.position].alpha = 1
        
        UIView.animate(withDuration: ClubAsmConstants.tickLength, delay: 0, options: [.curveEaseOut], animations: {
            self.maskedImages[self.position].alpha = 0
        }, completion: nil)
    }
    
    func action2() {
        self.maskedImages[self.position].alpha = 1
        
        UIView.animate(withDuration: ClubAsmConstants.tickLength, delay: 0, options: [.curveEaseOut], animations: {
            self.maskedImages[self.position].alpha = 0
        }, completion: nil)
    }
    
    func action3() {
        self.maskedImages[self.position].alpha = 1
        
        UIView.animate(withDuration: ClubAsmConstants.tickLength, delay: 0, options: [.curveEaseOut], animations: {
            self.maskedImages[self.position].alpha = 0
        }, completion: nil)
    }
    
    func action4() {
        self.maskedImages[self.position].alpha = 1
        
        UIView.animate(withDuration: ClubAsmConstants.tickLength, delay: 0, options: [.curveEaseOut], animations: {
            self.maskedImages[self.position].alpha = 0
        }, completion: nil)
    }
    
    func action5() {
        for view in self.maskedImages {
            view.isHidden = true
        }

        for view in self.circleViews {
            view.isHidden = false
            view.animate()
        }

        let offset: CGFloat = 20
        let duration = (ClubAsmConstants.barLength - (ClubAsmConstants.tickLength * 4.0))
        
        if self.position < 2 {
            let imageView = self.images[self.position]
            imageView.frame.origin.x -= offset / 2.0
            imageView.isHidden = false
            
            UIView.animate(withDuration: duration, delay: 0, options: [.curveLinear], animations: {
                imageView.frame.origin.x += offset
            }, completion: nil)
        } else {
            let index = self.position == 2 ? 2 : 4
            let imageView1 = self.images[index]
            imageView1.frame.origin.x += offset / 4.0
            imageView1.isHidden = false
            let imageView2 = self.images[index + 1]
            imageView2.frame.origin.x -= offset / 2.0
            imageView2.isHidden = false
            
            UIView.animate(withDuration: duration, delay: 0, options: [.curveLinear], animations: {
                imageView1.frame.origin.x -= offset / 2.0
                imageView2.frame.origin.x += offset
            }, completion: nil)
        }
        
        self.position += 1
        if self.position >= 4 {
            self.position = 0
        }
    }
    
    private func circle(diameter: CGFloat, color: UIColor) -> UIImage {
        let rect = CGRect(origin: .zero, size: CGSize(width: diameter * 2.0, height: diameter * 2.0))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = color.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.path = CGPath(ellipseIn: CGRect(origin: .zero, size: CGSize(width: diameter, height: diameter)), transform: nil)

        let shapeLayer2 = CAShapeLayer()
        shapeLayer2.fillColor = color.cgColor
        shapeLayer2.lineWidth = 1
        shapeLayer2.path = CGPath(ellipseIn: CGRect(origin: CGPoint(x: rect.midX, y: rect.midY), size: CGSize(width: diameter, height: diameter)), transform: nil)

        let renderer = UIGraphicsImageRenderer(size: rect.size)
        let image = renderer.image { context in
            shapeLayer2.render(in: context.cgContext)
            
            return shapeLayer.render(in: context.cgContext)
        }
        
        return image
    }
    
    private class MaskedCircleView: UIView {
        let circles = UIView(frame: .zero)
        let circleMask = UIView(frame: .zero)
        let duration: Double = ClubAsmConstants.barLength - (ClubAsmConstants.tickLength * 4.0)
        let direction: Direction
        let circleSize: CGFloat
        var circleBounds: CGRect = .zero
        
        init(frame: CGRect, circleSize: CGFloat, color: UIColor, direction: Direction) {
            self.direction = direction
            self.circleSize = circleSize
            
            super.init(frame: frame)
            
            let maskCircle = circle(diameter: self.bounds.size.height, color: .black)
            let circleMask = UIImageView(image: maskCircle)
            circleMask.frame = self.bounds
            self.mask = circleMask
            
            switch direction {
            case .horizontal:
                horizontal(circleSize: circleSize, color: color)
            case .vertical:
                vertical(circleSize: circleSize, color: color)
            }
        }
        
        private func horizontal(circleSize: CGFloat, color: UIColor) {
            var bounds = self.bounds
            bounds.size.width += circleSize
            self.circleBounds = bounds
            
            let circleImage = circle(diameter: circleSize, color: color)
            self.circles.backgroundColor = UIColor(patternImage: circleImage)
            self.circles.frame = bounds
            addSubview(self.circles)
            
            let maskCircleImage = circle(diameter: circleSize, color: .black)
            self.circleMask.backgroundColor = UIColor(patternImage: maskCircleImage)
            self.circleMask.frame = bounds
            self.circleMask.frame.origin.x += circleSize
            self.circles.mask = self.circleMask
        }
        
        private func vertical(circleSize: CGFloat, color: UIColor) {
            var bounds = self.bounds
            bounds.size.height += circleSize
            self.circleBounds = bounds
            
            let circleImage = circle(diameter: circleSize, color: color)
            self.circles.backgroundColor = UIColor(patternImage: circleImage)
            self.circles.frame = bounds
            addSubview(self.circles)
            
            let maskCircleImage = circle(diameter: circleSize, color: .black)
            self.circleMask.backgroundColor = UIColor(patternImage: maskCircleImage)
            self.circleMask.frame = bounds
            self.circleMask.frame.origin.y += circleSize
            self.circles.mask = self.circleMask
        }
        
        func reset() {
            self.circles.layer.removeAllAnimations()
            self.circleMask.layer.removeAllAnimations()
        }
        
        func animate() {
            switch self.direction {
            case .horizontal:
                animateHorizontal()
            case .vertical:
                animateVertical()
            }
        }
        
        private func animateHorizontal() {
            let centerX = Double(self.circleBounds.size.width / 2.0)
            let animation = CABasicAnimation(keyPath: "position.x")
            animation.fromValue = NSNumber(floatLiteral: centerX - Double(self.circleSize))
            animation.toValue = NSNumber(floatLiteral: centerX)
            animation.duration = self.duration
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            animation.repeatCount = Float.infinity
            self.circles.layer.add(animation, forKey: "xposition")
            
            let maskCenterX = Double((self.circleMask.bounds.size.width / 2.0))
            let maskAnimation = CABasicAnimation(keyPath: "position.x")
            maskAnimation.fromValue = NSNumber(floatLiteral: maskCenterX)
            maskAnimation.toValue = NSNumber(floatLiteral: maskCenterX - Double(self.circleSize))
            maskAnimation.duration = self.duration
            maskAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            maskAnimation.repeatCount = Float.infinity
            self.circleMask.layer.add(maskAnimation, forKey: "xposition")
        }
        
        private func animateVertical() {
            let centerY = Double(self.circleBounds.size.height / 2.0)
            let animation = CABasicAnimation(keyPath: "position.y")
            animation.fromValue = NSNumber(floatLiteral: centerY - Double(self.circleSize))
            animation.toValue = NSNumber(floatLiteral: centerY)
            animation.duration = self.duration
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            animation.repeatCount = Float.infinity
            self.circles.layer.add(animation, forKey: "yposition")
            
            let maskCenterY = Double((self.circleMask.bounds.size.height / 2.0))
            let maskAnimation = CABasicAnimation(keyPath: "position.y")
            maskAnimation.fromValue = NSNumber(floatLiteral: maskCenterY)
            maskAnimation.toValue = NSNumber(floatLiteral: maskCenterY - Double(self.circleSize))
            maskAnimation.duration = self.duration
            maskAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            maskAnimation.repeatCount = Float.infinity
            self.circleMask.layer.add(maskAnimation, forKey: "yposition")
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func circle(diameter: CGFloat, color: UIColor) -> UIImage {
            // thanks to apple for this code lol
            let rect = CGRect(origin: CGPoint.zero, size: CGSize(width: diameter, height: diameter))
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.fillColor = color.cgColor
            shapeLayer.lineWidth = 1
            shapeLayer.path = CGPath(ellipseIn: rect, transform: nil)
            
            let renderer = UIGraphicsImageRenderer(size: rect.size)
            let image = renderer.image { context in
                return shapeLayer.render(in: context.cgContext)
            }
            
            return image
        }
    }
    
    private enum Direction {
        case horizontal
        case vertical
    }
}
