//
//  ClubAsmCompoCircleView.swift
//  demo
//
//  Created by Johan Halin on 10/04/2019.
//  Copyright © 2019 Dekadence. All rights reserved.
//

import UIKit

class ClubAsmCompoCircleView: UIView, ClubAsmActions {
    private var containers = [ContainerView]()
    private var position = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        for i in 1...4 {
            let view = ContainerView(frame: self.bounds, index: i)
            view.isHidden = true
            addSubview(view)
            
            self.containers.append(view)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func action1() {
        for view in self.containers {
            view.isHidden = true
        }

        self.containers[self.position].isHidden = false
        self.containers[self.position].action1()
    }
    
    func action2() {
        self.containers[self.position].action2()
    }
    
    func action3() {
        self.containers[self.position].action3()
    }
    
    func action4() {
        self.containers[self.position].action4()
    }
    
    func action5() {
        self.containers[self.position].action5()

        self.position += 1
        
        if self.position >= 4 {
            self.position = 0
        }
    }
    
    private class ContainerView: UIView, ClubAsmActions {
        let backgroundContainer = UIView()
        let text = UIImageView()
        let referenceWidth: CGFloat = 366
        let movement: CGFloat = 100
        var textOrigin = CGPoint(x: 0, y: 0)
        let index: Int
        
        init(frame: CGRect, index: Int) {
            self.index = index
            
            super.init(frame: frame)
            
            self.backgroundContainer.frame = frame
            addSubview(self.backgroundContainer)
            
            let image = UIImage(named: "clubasmcompo_2-\(index)")!
            let count = Int(ceil(self.bounds.size.height / image.size.height))
            
            for i in 0..<count {
                let background = UIView(frame: frame)
                background.backgroundColor = UIColor(patternImage: image)
                background.frame.origin.y = CGFloat(i) * image.size.height
                background.frame.size.width = background.bounds.size.width + image.size.width
                background.frame.size.height = image.size.height
                self.backgroundContainer.addSubview(background)
                
                let circleMask = CircleView(frame: self.bounds)
                circleMask.bounds.size.width += self.movement
                circleMask.backgroundColor = .clear
                self.backgroundContainer.mask = circleMask

                self.text.image = image
                self.text.frame = CGRect(x: 0, y: (self.bounds.size.height / 2.0) - (image.size.height / 2.0), width: image.size.width, height: image.size.height)
                addSubview(self.text)
                self.textOrigin = CGPoint(x: (self.bounds.size.width / 2.0) - ((self.text.bounds.size.width - 5.0) / 2.0) - (self.movement / 2.0), y: self.text.frame.origin.y)
                
                let middle = Double(background.bounds.size.width / 2.0)
                let animation = CABasicAnimation(keyPath: "position.x")
                animation.fromValue = NSNumber(floatLiteral: middle)
                animation.toValue = NSNumber(floatLiteral: middle - Double(image.size.width))
                animation.beginTime = CACurrentMediaTime() + (sin(Double(i) / Double(count)) * 0.4)
                animation.duration = Double(image.size.width / self.referenceWidth) * 1.5
                animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                animation.repeatCount = Float.infinity
                background.layer.add(animation, forKey: "xposition")
            }
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func action1() {
            self.backgroundContainer.isHidden = true
            
            startAt(x: 0)
        }
        
        func action2() {
            startAt(x: self.textOrigin.x * (1.0 / 4.0))
        }
        
        func action3() {
            startAt(x: self.textOrigin.x * (2.0 / 4.0))
        }
        
        func action4() {
            startAt(x: self.textOrigin.x * (3.0 / 4.0))
        }
        
        func action5() {
            self.backgroundContainer.isHidden = false
            self.backgroundContainer.mask!.frame.origin.x = -self.movement

            self.text.layer.removeAllAnimations()
            self.text.frame.origin = self.textOrigin

            UIView.animate(withDuration: 2.0, delay: 0, options: [.curveLinear], animations: {
                self.backgroundContainer.mask!.frame.origin.x += self.movement
                self.text.frame.origin.x += self.movement
            }, completion: nil)
        }
        
        private func startAt(x: CGFloat) {
            self.text.layer.removeAllAnimations()
            self.text.frame.origin.x = x
            
            UIView.animate(withDuration: 2.0, delay: 0, options: [.curveLinear], animations: {
                self.text.frame.origin.x = x + self.movement
            }, completion: nil)
        }
    }
    
    private class CircleView: UIView {
        override func draw(_ rect: CGRect) {
            let context = UIGraphicsGetCurrentContext()!
            context.setFillColor(UIColor.white.cgColor)

            context.move(to: CGPoint(x: 0, y: 0))
            context.addLine(to: CGPoint(x: rect.size.width / 2.0, y: 0))
            let radius = rect.size.height / 2.0
            context.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: radius, startAngle: CGFloat.pi * 1.5, endAngle: CGFloat.pi * 0.5, clockwise: true)
            context.addLine(to: CGPoint(x: 0, y: rect.maxY))
            context.addLine(to: CGPoint(x: 0, y: 0))
            context.closePath()
            context.fillPath()

            context.move(to: CGPoint(x: rect.maxX, y: 0))
            context.addLine(to: CGPoint(x: rect.midX, y: 0))
            context.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: radius, startAngle: CGFloat.pi * 1.5, endAngle: CGFloat.pi * 0.5, clockwise: false)
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            context.addLine(to: CGPoint(x: rect.maxX, y: 0))
            context.closePath()
            context.fillPath()
        }
    }
}
