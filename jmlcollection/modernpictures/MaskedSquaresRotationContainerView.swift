//
//  MaskedSquaresRotationContainerView.swift
//  demo
//
//  Created by Johan Halin on 28/02/2019.
//  Copyright © 2019 Dekadence. All rights reserved.
//

import UIKit

class MaskedSquaresRotationContainerView: UIView {
    private let contentView1 = UIView()
    private let contentView2 = UIView()
    
    private let square1 = UIView()
    private let square2 = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(white: 0.1, alpha: 1)
        
        self.contentView1.frame = self.bounds
        self.addSubview(self.contentView1)
        
        self.contentView2.frame = self.bounds
        self.addSubview(self.contentView2)
        
        self.contentView1.mask = MaskVerticalView(frame: self.bounds, offset: 2, count: 2)
        self.contentView2.mask = MaskVerticalView(frame: self.bounds, offset: 6, count: 2)
        
        let length = self.bounds.size.height - 50
        
        self.square1.frame = CGRect(
            x: (self.bounds.size.width / 2.0) - (length / 2.0),
            y: (self.bounds.size.height / 2.0) - (length / 2.0),
            width: length,
            height: length
        )
        self.square1.backgroundColor = .white
        self.contentView1.addSubview(self.square1)
        
        self.square2.frame = CGRect(
            x: (self.bounds.size.width / 2.0) - (length / 2.0),
            y: (self.bounds.size.height / 2.0) - (length / 2.0),
            width: length,
            height: length
        )
        self.square2.backgroundColor = .gray
        self.contentView2.addSubview(self.square2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animate() {
        UIView.animate(withDuration: ModernPicturesConstants.shapeAnimationDuration, delay: 0, options: [], animations: {
            self.square1.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi / 2)
        }, completion: nil)

        UIView.animate(withDuration: ModernPicturesConstants.shapeAnimationDuration, delay: 0, options: [], animations: {
            self.square2.transform = CGAffineTransform.identity.rotated(by: -(CGFloat.pi / 2))
        }, completion: nil)
    }
}
