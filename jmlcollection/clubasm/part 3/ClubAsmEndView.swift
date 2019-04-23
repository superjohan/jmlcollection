//
//  ClubAsmEndView.swift
//  demo
//
//  Created by Johan Halin on 14/04/2019.
//  Copyright © 2019 Dekadence. All rights reserved.
//

import UIKit

class ClubAsmEndView: UIView, ClubAsmActions {
    private var images = [UIView]()
    private let container = UIView()
    
    private let assemblyLogo = UIImageView()
    private let assemblyUrl = UIImageView()

    private var position = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.container.frame = self.bounds
        self.container.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(self.container)
        
        for i in 1...5 {
            let image = UIImage(named: "clubasmend\(i)")!
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.frame = self.bounds
            imageView.isHidden = true
            self.container.addSubview(imageView)
            
            self.images.append(imageView)
        }
        
        let assemblyLogoImage = UIImage(named: "clubasmendlogo1")!
        self.assemblyLogo.image = assemblyLogoImage
        self.assemblyLogo.frame = CGRect(
            x: (self.bounds.size.width / 2.0) - (assemblyLogoImage.size.width / 2.0),
            y: (self.bounds.size.height / 2.0) - (assemblyLogoImage.size.height / 2.0),
            width: assemblyLogoImage.size.width,
            height: assemblyLogoImage.size.height
        )
        self.assemblyLogo.isHidden = true
        addSubview(self.assemblyLogo)

        let assemblyUrlImage = UIImage(named: "clubasmendlogo2")!
        self.assemblyUrl.image = assemblyUrlImage
        self.assemblyUrl.frame = CGRect(
            x: (self.bounds.size.width / 2.0) - (assemblyUrlImage.size.width / 2.0),
            y: (self.bounds.size.height / 2.0) - (assemblyUrlImage.size.height / 2.0),
            width: assemblyUrlImage.size.width,
            height: assemblyUrlImage.size.height
        )
        self.assemblyUrl.isHidden = true
        addSubview(self.assemblyUrl)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func action1() {
        hideViews()
        showNextImage()
    }
    
    func action2() {
        showNextImage()
    }
    
    func action3() {
        showNextImage()
    }
    
    func action4() {
        showNextImage()
    }
    
    func action5() {
        showNextImage()
        
        let delay = ClubAsmConstants.barLength - (ClubAsmConstants.tickLength * 8)
        perform(#selector(hideViews), with: nil, afterDelay: delay)
    }
    
    @objc private func hideViews() {
        for view in self.images {
            view.isHidden = true
        }
    }
    
    private func showNextImage() {
        if self.position <= 4 {
            self.images[self.position].isHidden = false
        } else if self.position >= 5 && self.position <= 9 {
            switch self.position {
            case 5:
                self.assemblyLogo.isHidden = false
                self.assemblyLogo.transform = CGAffineTransform.identity.scaledBy(x: 0.2, y: 0.2)
            case 6:
                self.assemblyLogo.transform = CGAffineTransform.identity.scaledBy(x: 0.4, y: 0.4)
            case 7:
                self.assemblyLogo.transform = CGAffineTransform.identity.scaledBy(x: 0.6, y: 0.6)
            case 8:
                self.assemblyLogo.transform = CGAffineTransform.identity.scaledBy(x: 0.8, y: 0.8)
            case 9:
                self.assemblyLogo.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
                
                let duration = ClubAsmConstants.barLength - (ClubAsmConstants.tickLength * 4.0)
                
                UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: [.curveEaseOut], animations: {
                    self.assemblyLogo.bounds.size.width *= 2
                    self.assemblyLogo.frame.origin.x = (self.bounds.size.width / 2.0) - (self.assemblyLogo.bounds.size.width / 2.0)
                    self.assemblyLogo.bounds.size.height = 0
                    self.assemblyLogo.frame.origin.y = self.bounds.size.height / 2.0
                }, completion: nil)
                
                self.assemblyUrl.alpha = 0
                self.assemblyUrl.isHidden = false
                
                UIView.animate(withDuration: duration, delay: 0, options: [], animations: {
                    self.assemblyUrl.alpha = 1
                }, completion: nil)
            default:
                abort()
            }
        }
    
        if self.position < 10 {
            self.position += 1
        }
    }
}
