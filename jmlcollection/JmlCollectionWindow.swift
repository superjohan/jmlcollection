//
//  JmlCollectionWindow.swift
//  jmlcollection
//
//  Created by Johan Halin on 16/09/2018.
//  Copyright © 2018 Jumalauta. All rights reserved.
//

import UIKit

class JmlCollectionWindow: UIWindow {
    var isShowingDemo: Bool = false
    
    let closeButton = UIImageView(image: UIImage(named: "closebutton"))
    
    // MARK: - Public
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.closeButton.frame = CGRect(x: 10, y: 10, width: 44, height: 44)
        self.closeButton.alpha = 0
        addSubview(self.closeButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sendEvent(_ event: UIEvent) {
        if !self.isShowingDemo {
            self.closeButton.alpha = 0
            
            super.sendEvent(event)

            return
        }
        
        // this sucks major ass
        if didTouchCloseButton(event) {
            closeButtonTouched()
        } else {
            bringSubviewToFront(self.closeButton)
            
            self.closeButton.isHidden = false
            self.closeButton.alpha = 1
            
            UIView.animate(withDuration: 0.2, delay: 3, options: [], animations: {
                self.closeButton.alpha = 0
            }, completion: nil)

            super.sendEvent(event)
        }
    }
    
    // MARK: - Private
    
    private func didTouchCloseButton(_ event: UIEvent) -> Bool {
        if let touches = event.allTouches {
            if touches.count == 1 {
                let touch = touches.first!
                
                if touch.phase == UITouch.Phase.ended {
                    let location = touch.location(in: self.closeButton)
                    
                    if self.closeButton.point(inside: location, with: event) {
                        return true
                    }
                }
            }
        }
        
        return false
    }
    
    private func closeButtonTouched() {
        if let navigationController = self.rootViewController as? UINavigationController {
            self.isShowingDemo = false
            self.closeButton.isHidden = true
            
            navigationController.popViewController(animated: true)
        }
    }
}
