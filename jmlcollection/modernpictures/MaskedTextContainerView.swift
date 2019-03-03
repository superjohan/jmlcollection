//
//  MaskedTextContainerView.swift
//  demo
//
//  Created by Johan Halin on 26/02/2019.
//  Copyright © 2019 Dekadence. All rights reserved.
//

import UIKit

class MaskedTextContainerView: UIView {
    private let labelCount: Int
    
    private let contentView1 = UIView()
    private let contentView2 = UIView()
    private let contentView3 = UIView()
    private let contentView4 = UIView()
    
    private var label1: UILabel? = nil
    private var label2: UILabel? = nil
    private var label3: UILabel? = nil
    private var label4: UILabel? = nil

    init(frame: CGRect, labelCount: Int) {
        assert(labelCount >= 2 && labelCount <= 4)
        
        self.labelCount = labelCount
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(white: 0.1, alpha: 1)
        
        self.contentView1.frame = self.bounds
        self.contentView2.frame = self.bounds
        
        self.contentView1.mask = MaskView(frame: self.bounds, offset: 2, count: labelCount)
        self.contentView2.mask = MaskView(frame: self.bounds, offset: 6, count: labelCount)

        self.label1 = addLabel(toView: self.contentView1)
        self.label1?.clipsToBounds = false
        self.label1?.textColor = UIColor(white: 1.0, alpha: 1.0)

        self.label2 = addLabel(toView: self.contentView2)
        self.label2?.textColor = UIColor(white: 0.6, alpha: 1.0)
        self.label2?.clipsToBounds = false

        self.addSubview(self.contentView1)
        self.addSubview(self.contentView2)

        if labelCount >= 3 {
            self.addSubview(self.contentView3)
            self.contentView3.frame = self.bounds
            self.contentView3.mask = MaskView(frame: self.bounds, offset: 10, count: labelCount)
            self.label3 = addLabel(toView: self.contentView3)
            self.label3?.textColor = UIColor(white: 0.4, alpha: 1.0)
            self.label3?.clipsToBounds = false
        }

        if labelCount >= 4 {
            self.addSubview(self.contentView4)
            self.contentView4.frame = self.bounds
            self.contentView4.mask = MaskView(frame: self.bounds, offset: 14, count: labelCount)
            self.label4 = addLabel(toView: self.contentView4)
            self.label4?.textColor = UIColor(white: 0.8, alpha: 1.0)
            self.label4?.clipsToBounds = false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addLabel(toView parent: UIView) -> UILabel {
        let label = UILabel(frame: parent.bounds)
        label.font = UIFont.boldSystemFont(ofSize: self.bounds.size.height)
        label.lineBreakMode = .byClipping
        label.textColor = UIColor(white: 0.7, alpha: 1.0)
        parent.addSubview(label)
        
        return label
    }
    
    func setText(text1: String, text2: String) {
        assert(self.labelCount == 2)
        
        updateLabels(text1: text1, text2: text2)
    }
    
    func setText(text1: String, text2: String, text3: String) {
        assert(self.labelCount == 3)

        updateLabels(text1: text1, text2: text2, text3: text3)
    }
    
    func setText(text1: String, text2: String, text3: String, text4: String) {
        assert(self.labelCount == 4)

        updateLabels(text1: text1, text2: text2, text3: text3, text4: text4)
    }
    
    private func updateLabels(text1: String, text2: String, text3: String? = nil, text4: String? = nil) {
        let angle1: CGFloat
        let angle2: CGFloat
        let angle3: CGFloat
        let angle4: CGFloat

        switch RotationOption.random() {
        case .none:
            angle1 = CGFloat.random(in: -0.2...0.2)
            angle2 = angle1
            angle3 = angle1
            angle4 = angle1
        case .some:
            angle1 = CGFloat.random(in: -0.2...0.2)
            angle2 = angle1 + CGFloat.random(in: -0.2...0.2)
            angle3 = angle1 + CGFloat.random(in: -0.2...0.2)
            angle4 = angle1 + CGFloat.random(in: -0.2...0.2)
        default:
            angle1 = CGFloat.random(in: -1...1)
            angle2 = CGFloat.random(in: -1...1)
            angle3 = CGFloat.random(in: -1...1)
            angle4 = CGFloat.random(in: -1...1)
        }

        setTextAndCenter(label: self.label1, text: text1, rotationAngle: angle1)
        setTextAndCenter(label: self.label2, text: text2, rotationAngle: angle2)
        
        if let text3 = text3 {
            setTextAndCenter(label: self.label3, text: text3, rotationAngle: angle3)
        }

        if let text4 = text4 {
            setTextAndCenter(label: self.label4, text: text4, rotationAngle: angle4)
        }
        
        if Int.random(in: 0...3) == 0 {
            self.label2?.textColor = ModernPicturesConstants.redColor
        } else {
            self.label2?.textColor = UIColor(white: 0.6, alpha: 1.0)
        }
    }
    
    private func setTextAndCenter(label: UILabel?, text: String, rotationAngle: CGFloat) {
        if let label = label {
            label.transform = CGAffineTransform.identity
            label.bounds = self.bounds
            label.text = text
            label.bounds.size.width = label.intrinsicContentSize.width

            label.transform = CGAffineTransform.init(rotationAngle: rotationAngle)
            
            UIView.animate(withDuration: 2, delay: 0, options: [.curveLinear], animations: {
                label.transform = label.transform.translatedBy(x: CGFloat.random(in: -20...20), y: CGFloat.random(in: -20...20))
            }, completion: nil)
        }
    }

    enum RotationOption {
        case none
        case some
        case lots
        
        static func random() -> RotationOption {
            switch arc4random_uniform(3) {
            case 0:
                return RotationOption.none
            case 1:
                return RotationOption.some
            default:
                return RotationOption.lots
            }
        }
    }
}
