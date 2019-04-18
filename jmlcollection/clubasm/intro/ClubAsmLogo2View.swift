//
//  ClubAsmLogo2View.swift
//  demo
//
//  Created by Johan Halin on 13/04/2019.
//  Copyright © 2019 Dekadence. All rights reserved.
//

import UIKit

class ClubAsmLogo2View: UIView, ClubAsmActions {
    var images = [UIImageView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        for i in 1...4 {
            let image = UIImage(named: "clubasmlogo2-\(i)")!
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.frame = self.bounds
            imageView.isHidden = true
            addSubview(imageView)
            
            self.images.append(imageView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func action1() {
        for view in self.images {
            view.isHidden = true
            view.frame = self.bounds
            view.layer.removeAllAnimations()
        }
        
        showImage(index: 0, offset: -20)
    }
    
    func action2() {
        showImage(index: 1, offset: 20)
    }
    
    func action3() {
        showImage(index: 3, offset: -20)
    }
    
    func action4() {
        showImage(index: 2, offset: 20)
    }
    
    func action5() {
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
            self.images[2].frame.origin.x = self.bounds.size.width
            self.images[3].frame.origin.x = -self.images[3].bounds.size.width
        }, completion: nil)
        
        UIView.animate(withDuration: 1.5, delay: 0, options: [.curveEaseOut], animations: {
            let xOffset: CGFloat = 20
            self.images[0].frame.origin.x += xOffset
            self.images[1].frame.origin.x -= xOffset
        }, completion: nil)
    }
    
    private func showImage(index: Int, offset: CGFloat) {
        self.images[index].isHidden = false
        self.images[index].frame.origin.x += offset
        
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseOut], animations: {
            self.images[index].frame.origin.x = 0
        }, completion: nil)
    }
}
