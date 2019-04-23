//
//  ClubAsmVictoryView.swift
//  demo
//
//  Created by Johan Halin on 03/04/2019.
//  Copyright © 2019 Dekadence. All rights reserved.
//

import UIKit

class ClubAsmVictoryView: UIView, ClubAsmActions {
    private var textImages = [UIImageView]()
    private var sines = [UIView]()
    private let background = UIView()
    
    private var animating = false
    private var sineWidth: Double = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .white

        self.background.frame = self.bounds
        self.background.backgroundColor = UIColor(red:1.000, green:0.919, blue:0.894, alpha:1.000)
        
        let filledSine = UIImage(named: "clubasmfilledsine")!
        self.background.frame.size.width += filledSine.size.width
        let borderView = UIView(frame: CGRect(x: 0, y: (self.bounds.size.height / 2.0) - (filledSine.size.height / 2.0), width: self.bounds.size.width + filledSine.size.width, height: filledSine.size.height))
        borderView.backgroundColor = UIColor(patternImage: filledSine)
        self.sineWidth = Double(filledSine.size.width)
        self.background.addSubview(borderView)
        
        let lowerHalf = UIView(frame: CGRect(x: 0, y: borderView.frame.maxY, width: self.bounds.size.width + filledSine.size.width, height: self.bounds.size.height - borderView.frame.maxY))
        lowerHalf.backgroundColor = .white
        self.background.addSubview(lowerHalf)
        
        self.background.alpha = 0
        
        addSubview(self.background)

        guard let image = UIImage(named: "clubasmvictory") else { return }
        guard let sineImage = UIImage(named: "clubasmsine")?.withRenderingMode(.alwaysTemplate) else { return }
        guard let imageMask = UIImage(named: "clubasmvictorymask") else { return }
        
        for i in 0..<7 {
            let imageY = image.size.height * CGFloat(i)
            let imageX = (self.bounds.size.width / 2.0) - (image.size.width / 2.0)
            
            let sineY = imageY + (image.size.height / 2.0) - (sineImage.size.height / 2.0)
            let sineView = UIView(frame: CGRect(x: 0, y: sineY, width: self.bounds.size.width, height: sineImage.size.height))
            sineView.backgroundColor = UIColor.init(patternImage: sineImage)
            addSubview(sineView)
            
            let mask = UIImageView(image: imageMask)
            mask.frame.size.width = imageMask.size.width
            mask.frame.size.height = imageMask.size.height
            mask.frame.origin.x = imageX + (image.size.width / 2.0) - (imageMask.size.width / 2.0)
            mask.frame.origin.y = (sineView.bounds.size.height / 2.0) - (imageMask.size.height / 2.0)
            sineView.mask = mask
            self.sines.append(sineView)
            
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(
                x: imageX,
                y: imageY,
                width: image.size.width,
                height: image.size.height
            )
            addSubview(imageView)
            
            self.textImages.append(imageView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func action1() {
        if self.animating {
            setVisibility(index: 0, visible: false, showSine: true)
            return
        }
        
        for (index, view) in self.textImages.enumerated() {
            view.isHidden = true
            self.sines[index].isHidden = true
            
            let distance = Double(view.bounds.size.width)
            let animation = CABasicAnimation(keyPath: "position.x")
            animation.fromValue = NSNumber(floatLiteral: Double(self.bounds.size.width / 2.0) - distance)
            animation.toValue = NSNumber(floatLiteral: Double(self.bounds.size.width / 2.0) + distance)
            animation.duration = 1
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            animation.autoreverses = true
            animation.repeatCount = Float.infinity
            animation.beginTime = CACurrentMediaTime() + (Double(index) * 0.05)
            view.layer.add(animation, forKey: "xposition")

            self.sines[index].mask?.layer.add(animation, forKey: "xposition")
        }
        
        setVisibility(index: 0, visible: true, showSine: false)
    }
    
    func action2() {
        if self.animating {
            setVisibility(index: 0, visible: true, showSine: true)
            setVisibility(index: 2, visible: false, showSine: true)
            return
        }
        
        for i in 0..<self.textImages.count {
            setVisibility(index: i, visible: false, showSine: false)
        }
        
        setVisibility(index: 2, visible: true, showSine: false)
    }
    
    func action3() {
        if self.animating {
            setVisibility(index: 2, visible: true, showSine: true)
            setVisibility(index: 4, visible: false, showSine: true)
            return
        }

        for i in 0..<self.textImages.count {
            setVisibility(index: i, visible: false, showSine: false)
        }
        
        setVisibility(index: 4, visible: true, showSine: false)
    }
    
    func action4() {
        if self.animating {
            setVisibility(index: 4, visible: true, showSine: true)
            setVisibility(index: 6, visible: false, showSine: true)
            return
        }

        for i in 0..<self.textImages.count {
            setVisibility(index: i, visible: false, showSine: false)
        }
        
        setVisibility(index: 6, visible: true, showSine: false)
    }
    
    func action5() {
        for i in 0..<self.textImages.count {
            setVisibility(index: i, visible: true, showSine: true)
        }
        
        if !self.animating {
            let centerX: Double = Double(self.bounds.size.width / 2.0) + (self.sineWidth / 2.0)
            let animation = CABasicAnimation(keyPath: "position.x")
            animation.fromValue = NSNumber(floatLiteral: centerX)
            animation.toValue = NSNumber(floatLiteral: centerX - self.sineWidth)
            animation.duration = 2
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
            animation.repeatCount = Float.infinity
            self.background.layer.add(animation, forKey: "xposition")
            
            UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
                self.background.alpha = 1
            }, completion: nil)
        }
        
        self.animating = true
    }
    
    private func setVisibility(index: Int, visible: Bool, showSine: Bool) {
        self.textImages[index].isHidden = !visible
        self.sines[index].isHidden = showSine ? !visible : true
    }
}
