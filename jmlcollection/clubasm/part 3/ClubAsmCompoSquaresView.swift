//
//  ClubAsmCompoSquaresView.swift
//  demo
//
//  Created by Johan Halin on 11/04/2019.
//  Copyright © 2019 Dekadence. All rights reserved.
//

import UIKit

class ClubAsmCompoSquaresView: UIView, ClubAsmActions {
    private let border: CGFloat = 100
    private let baseline: CGFloat = 15
    private let box = UIView()
    private let imageView1 = UIImageView()
    private let imageView2 = UIImageView()
    private let imageView3 = UIImageView()
    private let imageView4 = UIImageView()
    private let images: [UIImage]
    private var segments = [UIView]()
    
    private var position = 0
    
    private let colors = [
        UIColor(red:0.482, green:0.322, blue:0.831, alpha:1.000),
        UIColor(red:0.980, green:0.416, blue:0.180, alpha:1.000),
        UIColor(red:0.973, green:0.200, blue:0.631, alpha:1.000),
        UIColor(red:0.200, green:0.710, blue:0.294, alpha:1.000)
    ]
    
    override init(frame: CGRect) {
        var images = [UIImage]()
        images.append(UIImage(named: "clubasmcompo_3-4")!)
        images.append(UIImage(named: "clubasmcompo_3-3")!)
        images.append(UIImage(named: "clubasmcompo_3-2")!)
        images.append(UIImage(named: "clubasmcompo_3-1")!)

        self.images = images

        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        self.box.frame = CGRect(
            x: self.bounds.minX + self.border,
            y: self.bounds.minY + self.border,
            width: self.bounds.size.width - (self.border * 2.0),
            height: self.bounds.size.height - (self.border * 2.0)
        )
        self.box.backgroundColor = self.colors[0]
    
        for i in 0...3 {
            let width = self.box.bounds.size.width / 4.0
            let segmentFrame = CGRect(
                x: CGFloat(i) * width,
                y: 0,
                width: width,
                height: self.box.bounds.size.height
            )
            let segment = UIView(frame: segmentFrame)
            segment.backgroundColor = self.colors[0]
            self.box.addSubview(segment)
            
            self.segments.append(segment)
        }
        
        let width: CGFloat = images[0].size.width
        let height: CGFloat = images[0].size.height
        
        self.imageView1.frame = CGRect(
            x: 0,
            y: self.box.bounds.minY - height + self.baseline,
            width: width,
            height: height
        )
        self.box.addSubview(self.imageView1)

        self.imageView2.frame = CGRect(
            x: 0,
            y: 0,
            width: width,
            height: height
        )
        self.imageView2.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi * 0.5)
        setImageView2origin()
        self.box.addSubview(self.imageView2)

        self.imageView3.frame = CGRect(
            x: 0,
            y: 0,
            width: width,
            height: height
        )
        self.imageView3.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi)
        setImageView3origin()
        self.box.addSubview(self.imageView3)

        self.imageView4.frame = CGRect(
            x: 0,
            y: 0,
            width: width,
            height: height
        )
        self.imageView4.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi * 1.5)
        setImageView4origin()
        self.box.addSubview(self.imageView4)

        updatePosition()
        
        addSubview(self.box)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func action1() {
        let colorIndex = self.position > 0 ? self.position - 1 : self.colors.count - 1
        
        for view in self.segments {
            view.backgroundColor = self.colors[colorIndex]
            view.alpha = 1
        }
        
        self.box.backgroundColor = self.colors[self.position]
        
        animateSegment(0)
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
        UIView.animate(withDuration: ClubAsmConstants.animationDuration - 0.1, delay: 0, options: [.curveEaseOut], animations: {
            self.box.frame.size.width = self.bounds.size.height - (self.border * 2.0)
            self.box.frame.size.height = self.bounds.size.width - (self.border * 2.0)
            self.box.frame.origin.x = self.bounds.midX - (self.box.bounds.size.width / 2.0)
            self.box.frame.origin.y = self.bounds.midY - (self.box.bounds.size.height / 2.0)
            self.box.transform = self.box.transform.rotated(by: CGFloat.pi * 0.5)

            self.setImageView2origin()
            self.setImageView3origin()
            self.setImageView4origin()
        }, completion: { done in
            self.box.transform = .identity
            self.box.frame = CGRect(
                x: self.bounds.minX + self.border,
                y: self.bounds.minY + self.border,
                width: self.bounds.size.width - (self.border * 2.0),
                height: self.bounds.size.height - (self.border * 2.0)
            )
            
            self.setImageView2origin()
            self.setImageView3origin()
            self.setImageView4origin()

            self.updatePosition()
        })
    }
    
    private func setImageView2origin() {
        self.imageView2.frame.origin.x = self.box.bounds.size.width - self.baseline
        self.imageView2.frame.origin.y = self.box.bounds.minY
    }
    
    private func setImageView3origin() {
        self.imageView3.frame.origin.x = self.box.bounds.size.width - self.imageView3.bounds.size.width
        self.imageView3.frame.origin.y = self.box.bounds.size.height - self.baseline
    }
    
    private func setImageView4origin() {
        self.imageView4.frame.origin.x = self.box.bounds.minX - self.imageView4.bounds.size.height + self.baseline
        self.imageView4.frame.origin.y = self.box.bounds.maxY - self.imageView4.bounds.size.width
    }
    
    private func updatePosition() {
        self.position += 1
        if self.position >= 4 {
            self.position = 0
        }
        
        switch self.position {
        case 0:
            self.imageView1.image = self.images[0]
            self.imageView2.image = self.images[1]
            self.imageView3.image = self.images[2]
            self.imageView4.image = self.images[3]
        case 1:
            self.imageView1.image = self.images[3]
            self.imageView2.image = self.images[0]
            self.imageView3.image = self.images[1]
            self.imageView4.image = self.images[2]
        case 2:
            self.imageView1.image = self.images[2]
            self.imageView2.image = self.images[3]
            self.imageView3.image = self.images[0]
            self.imageView4.image = self.images[1]
        case 3:
            self.imageView1.image = self.images[1]
            self.imageView2.image = self.images[2]
            self.imageView3.image = self.images[3]
            self.imageView4.image = self.images[0]
        default:
            abort()
        }
    }
    
    private func animateSegment(_ index: Int) {
        let view = self.segments[index]
        view.alpha = 1
        
        UIView.animate(withDuration: ClubAsmConstants.tickLength, delay: 0, options: [.curveEaseOut], animations: {
            view.alpha = 0
        }, completion: nil)
    }
}
