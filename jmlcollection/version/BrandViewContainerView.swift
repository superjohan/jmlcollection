//
//  BrandViewContainerView.swift
//  demo
//
//  Created by Johan Halin on 17/03/2018.
//  Copyright © 2018 Dekadence. All rights reserved.
//

import Foundation
import UIKit

class BrandViewContainerView: UIView {
    // MARK: - UIView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        self.addSubview(BrandViewAntiflex(frame: self.frame))
        self.addSubview(BrandViewBotastica(frame: self.frame))
        self.addSubview(BrandViewBrentax(frame: self.frame))
        self.addSubview(BrandViewCromteq(frame: self.frame))
        self.addSubview(BrandViewDistando(frame: self.frame))
        self.addSubview(BrandViewEftua(frame: self.frame))
        self.addSubview(BrandViewEkrom(frame: self.frame))
        self.addSubview(BrandViewFantisol(frame: self.frame))
        self.addSubview(BrandViewFreemo(frame: self.frame))
        self.addSubview(BrandViewGiontas(frame: self.frame))
        self.addSubview(BrandViewHaemo(frame: self.frame))
        self.addSubview(BrandViewIodyne(frame: self.frame))
        self.addSubview(BrandViewJoolenta(frame: self.frame))
        self.addSubview(BrandViewKreaten(frame: self.frame))
        self.addSubview(BrandViewLateqniq(frame: self.frame))
        self.addSubview(BrandViewMurtelio(frame: self.frame))
        self.addSubview(BrandViewNeandertek(frame: self.frame))
        self.addSubview(BrandViewOeland(frame: self.frame))
        self.addSubview(BrandViewOventus(frame: self.frame))
        self.addSubview(BrandViewPreolio(frame: self.frame))
        self.addSubview(BrandViewQuantifex(frame: self.frame))
        self.addSubview(BrandViewRemotex(frame: self.frame))
        self.addSubview(BrandViewSantafelos(frame: self.frame))
        self.addSubview(BrandViewSeptogon(frame: self.frame))
        self.addSubview(BrandViewTechnikon(frame: self.frame))
        self.addSubview(BrandViewUltrox(frame: self.frame))
        self.addSubview(BrandViewUniventa(frame: self.frame))
        self.addSubview(BrandViewVisioland(frame: self.frame))
        self.addSubview(BrandViewWebtraks(frame: self.frame))
        self.addSubview(BrandViewXerion(frame: self.frame))
        self.addSubview(BrandViewYamageruto(frame: self.frame))
        self.addSubview(BrandViewZophario(frame: self.frame))

        for view in self.subviews {
            view.isHidden = true
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    func adjustFrames() {
        for view in self.subviews {
            view.frame = self.bounds
            
            for subview in view.subviews {
                subview.frame = self.bounds
            }
        }
    }
    
    func showBrand(_ index: Int, animated: Bool) {
        for view in self.subviews {
            if self.subviews.firstIndex(of: view) == index {
                view.isHidden = false
            } else {
                view.isHidden = true
            }
        }
        
        let brandView = self.subviews[index] as! BrandView

        if animated {
            brandView.animateBrand()
        } else {
            brandView.showBrand()
        }
    }
}
