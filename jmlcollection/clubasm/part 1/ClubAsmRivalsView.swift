//
//  ShadeTwist.swift
//  demo
//
//  Created by Johan Halin on 25/03/2019.
//  Copyright © 2019 Dekadence. All rights reserved.
//

import UIKit

class ClubAsmRivalsView: UIView, ClubAsmActions {
    private let duration = ClubAsmConstants.barLength - (ClubAsmConstants.tickLength * 4.0)
    private let width = CGFloat(299)
    private let bg = UIView()
    
    private var shades = [ShadeViewHolder]()
    private var isAnimating = false
    private var stepTwo = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .black
        
        let bgLength = self.bounds.size.width * 2.0
        self.bg.frame = CGRect(
            x: (self.bounds.size.width / 2.0) - (bgLength / 2.0),
            y: (self.bounds.size.height / 2.0) - (bgLength / 2.0),
            width: bgLength,
            height: bgLength
        )
        self.bg.isHidden = true
        self.bg.alpha = 0
        addSubview(self.bg)

        let bgLeft = UIView(frame: CGRect(x: 0, y: 0, width: bgLength / 2.0, height: bgLength))
        bgLeft.backgroundColor = UIColor(red:0.325, green:0.326, blue:0.325, alpha:1.000)
        self.bg.addSubview(bgLeft)
        
        let bgRight = UIView(frame: CGRect(x: bgLength / 2.0, y: 0, width: bgLength / 2.0, height: bgLength))
        bgRight.backgroundColor = .black
        self.bg.addSubview(bgRight)
        
        let height = frame.size.height / 4.0
        
        for i in 0..<4 {
            let holder = ShadeViewHolder(
                centerX: frame.size.width / 2.0,
                y: height * (CGFloat(i)),
                width: self.width,
                height: height,
                startDelay: TimeInterval(i) * (self.duration / 4.0)
            )
            
            self.shades.append(holder)
            
            addSubview(holder.container)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func action1() {
        if self.isAnimating {
            self.shades[0].setViewVisibility(isHidden: true)
            return
        }
        
        hideAllViews()
        showView(index: 0)
    }
    
    func action2() {
        if self.isAnimating {
            self.shades[0].setViewVisibility(isHidden: false)
            self.shades[1].setViewVisibility(isHidden: true)
            return
        }
        
        hideAllViews()
        showView(index: 1)
    }
    
    func action3() {
        if self.isAnimating {
            self.shades[1].setViewVisibility(isHidden: false)
            self.shades[2].setViewVisibility(isHidden: true)
            return
        }
        
        hideAllViews()
        showView(index: 2)
    }
    
    func action4() {
        if self.isAnimating {
            self.shades[2].setViewVisibility(isHidden: false)
            self.shades[3].setViewVisibility(isHidden: true)
            return
        }
        
        hideAllViews()
        showView(index: 3)
    }
    
    func action5() {
        self.bg.isHidden = false
        
        if self.isAnimating {
            self.shades[3].setViewVisibility(isHidden: false)
        }
        
        if !self.isAnimating {
            animate()

            self.isAnimating = true
        }

        let offset = self.width / 3.0

        if !self.stepTwo {
            UIView.animate(withDuration: ClubAsmConstants.barLength / 2.0, delay: 0, options: [.curveEaseOut], animations: {
                for i in 0...3 {
                    let centerOffset = (CGFloat(i) * offset) - self.width
                    self.shades[i].container.frame.origin.x = (self.bounds.midX) + centerOffset
                }

                self.bg.alpha = 1
                self.bg.transform = self.bg.transform.rotated(by: CGFloat.pi)
            }, completion: nil)

            self.stepTwo = true
        } else {
            UIView.animate(withDuration: ClubAsmConstants.barLength / 2.0, delay: 0, options: [.curveEaseOut], animations: {
                for i in 0...3 {
                    let centerOffset = (CGFloat(3 - i) * offset) - self.width
                    self.shades[i].container.frame.origin.x = (self.bounds.midX) + centerOffset
                }
                
                self.bg.transform = self.bg.transform.rotated(by: CGFloat.pi)
            }, completion: nil)

            self.stepTwo = false
        }
    }
    
    private func showView(index: Int) {
        let holder = self.shades[index]

        holder.setViewVisibility(isHidden: false)
    }
    
    private func hideAllViews() {
        for holder in self.shades {
            holder.setViewVisibility(isHidden: true)
        }
    }
    
    private func animate() {
        for holder in self.shades {
            holder.setViewVisibility(isHidden: false)
            holder.animateRow(duration: self.duration)
        }
    }

    private class ShadeViewHolder {
        let container = UIView()
        private let leftView = UIImageView(image: UIImage(named: "clubasmrivalswhite"))
        private let leftShadeLeft = UIImageView(image: UIImage(named: "clubasmshadeleft"))
        private let leftShadeRight = UIImageView(image: UIImage(named: "clubasmshaderight"))
        private let rightView = UIImageView(image: UIImage(named: "clubasmrivalsblack"))
        private let rightShadeLeft = UIImageView(image: UIImage(named: "clubasmshadeleft"))
        private let rightShadeRight = UIImageView(image: UIImage(named: "clubasmshaderight"))
        
        let startDelay: TimeInterval
        let width: CGFloat
        let x: CGFloat
        
        var started = false
        
        init(centerX: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, startDelay: TimeInterval) {
            self.startDelay = startDelay
            
            let tintColor = UIColor(red:0.999, green:0.977, blue:0.380, alpha:1.000)
            
            self.leftView.backgroundColor = UIColor(white: 0.2, alpha: 1)
            self.rightView.backgroundColor = tintColor

            self.container.frame = CGRect(
                x: centerX - width / 2,
                y: y,
                width: width,
                height: height
            )
            
            self.leftView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            self.rightView.frame = CGRect(x: width, y: 0, width: 0, height: height)
            
            self.x = self.leftView.frame.origin.x
            self.width = width
            
            self.leftView.addSubview(self.leftShadeLeft)
            self.leftView.addSubview(self.leftShadeRight)
            self.rightView.addSubview(self.rightShadeLeft)
            self.rightView.addSubview(self.rightShadeRight)
            
            self.leftShadeLeft.frame = self.leftView.bounds
            self.leftShadeRight.frame = self.leftView.bounds
            self.rightShadeLeft.frame = self.rightView.bounds
            self.rightShadeRight.frame = self.rightView.bounds
            
            self.leftShadeLeft.autoresizingMask = [.flexibleWidth]
            self.leftShadeRight.autoresizingMask = self.leftShadeLeft.autoresizingMask
            self.rightShadeLeft.autoresizingMask = self.leftShadeLeft.autoresizingMask
            self.rightShadeRight.autoresizingMask = self.leftShadeLeft.autoresizingMask

            self.rightView.frame.origin.x = self.x + self.width
            
            self.leftShadeLeft.alpha = 0
            self.leftShadeRight.alpha = 0
            self.rightShadeLeft.alpha = 0
            self.rightShadeRight.alpha = 1
            
            self.container.addSubview(self.leftView)
            self.container.addSubview(self.rightView)
        }
        
        func animateRow(duration: TimeInterval) {
            self.rightView.frame.origin.x = self.x + self.width
            
            self.leftShadeLeft.alpha = 0
            self.leftShadeRight.alpha = 0
            self.rightShadeLeft.alpha = 0
            self.rightShadeRight.alpha = 1
            
            let delay = self.started ? 0 : self.startDelay
            
            self.started = true
            
            UIView.animate(withDuration: duration, delay: delay, options: [.curveEaseInOut], animations: {
                self.leftView.frame.size.width = 0
                self.leftShadeLeft.alpha = 1
                
                self.rightView.frame.origin.x = self.x
                self.rightView.frame.size.width = self.width
                self.rightShadeRight.alpha = 0
            }, completion: { _ in
                self.leftView.frame.origin.x = self.x + self.width
                self.leftShadeLeft.alpha = 0
                self.leftShadeRight.alpha = 1
                
                self.rightShadeLeft.alpha = 0
                self.rightShadeRight.alpha = 0
                
                UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseInOut], animations: {
                    self.leftView.frame.origin.x = self.x
                    self.leftView.frame.size.width = self.width
                    self.leftShadeRight.alpha = 0
                    
                    self.rightView.frame.size.width = 0
                    self.rightShadeLeft.alpha = 1
                }, completion: { _ in
                    self.animateRow(duration: duration)
                })
            })
        }
        
        func setViewVisibility(isHidden: Bool) {
            self.leftView.isHidden = isHidden
            self.rightView.isHidden = isHidden
            
            if isHidden {
                self.leftView.alpha = 0
                self.rightView.alpha = 0
            } else {
                self.leftView.alpha = 1
                self.rightView.alpha = 1
            }
        }
    }
}
