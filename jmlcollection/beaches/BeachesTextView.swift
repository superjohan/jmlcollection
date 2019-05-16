//
//  BeachesTextView.swift
//  demo
//
//  Created by Johan Halin on 15/05/2019.
//  Copyright © 2019 Dekadence. All rights reserved.
//

import UIKit

class BeachesTextView: UIView {
    private var images = [UIView]()
    private var position = -1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        for i in 1...5 {
            let image = UIImage(named: "beachesleavetext\(i)")
            let imageView = UIImageView(image: image)
            imageView.frame = self.bounds
            imageView.contentMode = .scaleAspectFit
            addSubview(imageView)
            
            let mask = UIView(frame: CGRect(x: self.bounds.size.width, y: 0, width: 0, height: self.bounds.size.height))
            mask.backgroundColor = .white
            imageView.mask = mask
            
            self.images.append(imageView)
        }
    }
    
    func showNextImage() {
        let previousView = self.position >= 0 ? self.images[self.position] : nil

        self.position += 1
        
        if self.position >= self.images.count {
            self.position = 0
        }

        let view = self.images[self.position]
        view.mask?.frame = CGRect(x: self.bounds.size.width, y: 0, width: 0, height: self.bounds.size.height)
        view.alpha = 0
        
        UIView.animate(withDuration: 1, animations: {
            previousView?.mask?.frame = CGRect(x: 0, y: 0, width: 0, height: self.bounds.size.height)
            previousView?.alpha = 0
            view.mask?.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
            view.alpha = 1
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
