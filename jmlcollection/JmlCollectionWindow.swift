//
//  JmlCollectionWindow.swift
//  jmlcollection
//
//  Created by Johan Halin on 16/09/2018.
//  Copyright © 2018 Jumalauta. All rights reserved.
//

import UIKit

class JmlCollectionWindow: UIWindow {
    private var _isShowingDemo: Bool = false
    
    var isShowingDemo: Bool {
        get {
            return _isShowingDemo
        }
        set(newValue) {
            _isShowingDemo = newValue

            if !_isShowingDemo {
                setCloseButtonVisible(false)
            }
        }
    }
    
    let closeButton = UIImageView(image: UIImage(named: "closebutton"))
    
    // MARK: - Public
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.closeButton.frame = CGRect(x: 10, y: 10, width: 44, height: 44)
        setCloseButtonVisible(false)
        addSubview(self.closeButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sendEvent(_ event: UIEvent) {
        if !self.isShowingDemo {
            setCloseButtonVisible(false)
            
            super.sendEvent(event)

            return
        }
        
        // this sucks major ass
        if didTouchCloseButton(event) {
            closeButtonTouched()
        } else {
            if singleTouch(fromEvent: event)?.phase == UITouch.Phase.ended {
                bringSubviewToFront(self.closeButton)
                
                setCloseButtonVisible(true)
                
                UIView.animate(withDuration: 0.2, delay: 3, options: [], animations: {
                    self.closeButton.alpha = 0
                }, completion: nil)
            }
            
            super.sendEvent(event)
        }
    }
    
    // MARK: - Private
    
    private func setCloseButtonVisible(_ visible: Bool) {
        self.closeButton.isHidden = !visible
        self.closeButton.alpha = visible ? 1 : 0
    }
    
    private func singleTouch(fromEvent event: UIEvent) -> UITouch? {
        if let touches = event.allTouches {
            if touches.count == 1 {
                return touches.first
            }
        }
        
        return nil
    }
    
    private func didTouchCloseButton(_ event: UIEvent) -> Bool {
        if let touch = singleTouch(fromEvent: event) {
            if touch.phase == UITouch.Phase.ended {
                let location = touch.location(in: self.closeButton)
                
                if self.closeButton.point(inside: location, with: event) {
                    return true
                }
            }
        }
        
        return false
    }
    
    private func closeButtonTouched() {
        if let navigationController = self.rootViewController as? UINavigationController {
            self.isShowingDemo = false
            
            navigationController.popViewController(animated: true)
        }
    }
}
