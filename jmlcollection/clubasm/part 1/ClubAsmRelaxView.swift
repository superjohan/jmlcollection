//
//  ClubAsmRelaxView.swift
//  demo
//
//  Created by Johan Halin on 02/04/2019.
//  Copyright © 2019 Dekadence. All rights reserved.
//

import UIKit

class ClubAsmRelaxView: UIView, ClubAsmActions {
    private var images = [UIImageView]()
    private var imageHeight: CGFloat = 0
    
    private let bg = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .black

        self.bg.frame = self.bounds
        self.bg.clipsToBounds = true
        self.bg.bounds.size.width = 0
        
        let bgLeft = UIView(frame: CGRect(x: 0, y: 0, width: self.bg.bounds.size.width / 2.0, height: self.bg.bounds.size.height))
        bgLeft.backgroundColor = .white
        self.bg.addSubview(bgLeft)
        
        let bgRight = UIView(frame: CGRect(x: self.bg.bounds.size.width / 2.0, y: 0, width: self.bg.bounds.size.width / 2.0, height: self.bg.bounds.size.height))
        bgRight.backgroundColor = UIColor(red:0.980, green:0.443, blue:0.173, alpha:1.000)
        self.bg.addSubview(bgRight)

        addSubview(self.bg)
        
        for i in 0..<5 {
            let image = UIImage(named: "clubasmrelax\(i + 1)")!.withRenderingMode(.alwaysTemplate)
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(
                x: 0,
                y: 0,
                width: image.size.width,
                height: image.size.height
            )
            imageView.tintColor = .white
            imageView.contentMode = .scaleToFill
            addSubview(imageView)
            
            self.imageHeight = imageView.bounds.size.height
            
            self.images.append(imageView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func action1() {
        self.bg.bounds.size.width = 0
        self.bg.subviews[0].frame = CGRect(x: 0, y: 0, width: self.bg.bounds.size.width / 2.0, height: self.bg.bounds.size.height)
        self.bg.subviews[1].frame = CGRect(x: self.bg.bounds.size.width / 2.0, y: 0, width: self.bg.bounds.size.width / 2.0, height: self.bg.bounds.size.height)

        for view in self.images {
            view.isHidden = true
            view.frame.size.height = self.imageHeight
            view.frame.origin.x = (self.bounds.size.width / 2.0) - (view.bounds.size.width / 2.0)
            view.frame.origin.y = (self.bounds.size.height / 2.0) - (view.bounds.size.height / 2.0)
            view.alpha = 1
            view.tintColor = .white
        }
        
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
        var lastX: CGFloat = 0
        var lastX2: CGFloat = 0
        var ratios: [CGFloat] = [self.images[0].bounds.size.height / self.bounds.size.height]
        ratios.append((1.0 - ratios[0]) / 2.0)
        ratios.append(ratios[1] / 2.0)
        ratios.append(ratios[2] / 2.0)
        ratios.append(ratios[2] / 2.0)

        for (index, view) in self.images.enumerated() {
            view.tintColor = .black
            view.layer.removeAllAnimations()
            view.isHidden = false
            view.alpha = 1
            
            let height = self.bounds.size.height * ratios[index]
            view.frame.origin.y = lastX
            view.frame.size.height = height
            
            lastX = lastX + view.frame.size.height
            
            UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseOut], animations: {
                let height2 = self.bounds.size.height * ratios[ratios.count - 1 - index]
                view.frame.origin.y = lastX2
                view.frame.size.height = height2
                
                lastX2 = lastX2 + view.frame.size.height
            }, completion: nil)
        }
        
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseOut], animations: {
            self.bg.bounds.size.width = self.bounds.size.width
            self.bg.subviews[0].frame = CGRect(x: 0, y: 0, width: self.bg.bounds.size.width / 2.0, height: self.bg.bounds.size.height)
            self.bg.subviews[1].frame = CGRect(x: self.bg.bounds.size.width / 2.0, y: 0, width: self.bg.bounds.size.width / 2.0, height: self.bg.bounds.size.height)
        }, completion: nil)
    }

    private func animate(index: Int) {
        self.images[index].isHidden = false
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
            self.images[index].alpha = 0
        }, completion: nil)
    }
}
