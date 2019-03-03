//
//  MaskedHorizontalCirclesContainerView.swift
//  demo
//
//  Created by Johan Halin on 27/02/2019.
//  Copyright © 2019 Dekadence. All rights reserved.
//

import UIKit

class MaskedHorizontalCirclesContainerView: UIView {
    private let contentView1 = UIView()
    private let contentView2 = UIView()
    
    private let circle1 = UIView()
    private let circle2 = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(white: 0.1, alpha: 1)
        
        self.contentView1.frame = self.bounds
        self.addSubview(self.contentView1)
        
        self.contentView2.frame = self.bounds
        self.addSubview(self.contentView2)
        
        self.contentView1.mask = MaskVerticalView(frame: self.bounds, offset: 2, count: 2)
        self.contentView2.mask = MaskVerticalView(frame: self.bounds, offset: 6, count: 2)
        
        let length = self.bounds.size.height - 25
        
        self.circle1.frame = CGRect(
            x: (self.bounds.size.width / 2.0) - (length / 2.0),
            y: (self.bounds.size.height / 2.0) - (length / 2.0),
            width: length,
            height: length
        )
        self.circle1.layer.cornerRadius = length / 2
        self.circle1.backgroundColor = .white
        self.contentView1.addSubview(self.circle1)
        
        self.circle2.frame = CGRect(
            x: (self.bounds.size.width / 2.0) - (length / 2.0),
            y: (self.bounds.size.height / 2.0) - (length / 2.0),
            width: length,
            height: length
        )
        self.circle2.layer.cornerRadius = self.circle1.layer.cornerRadius
        self.circle2.backgroundColor = .gray
        self.contentView2.addSubview(self.circle2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animate() {
        UIView.animate(withDuration: ModernPicturesConstants.shapeAnimationDuration, delay: 0, options: [], animations: {
            self.circle1.frame.origin.x -= self.circle1.bounds.size.width / 4
            self.circle2.frame.origin.x += self.circle2.bounds.size.width / 4
        }, completion: nil)
    }
}
