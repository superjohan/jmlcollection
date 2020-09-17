//
//  EndView.swift
//  demo
//
//  Created by Johan Halin on 16.9.2020.
//  Copyright © 2020 Dekadence. All rights reserved.
//

import Foundation
import UIKit

class EndView: UIView {
    let labelCount = 8
    let labels: [UILabel]

    override init(frame: CGRect) {
        var labels = [UILabel]()

        for i in 0...self.labelCount {
            let label = UILabel()
            label.backgroundColor = .clear
            label.textColor = UIColor(white: 1.0 - (CGFloat(i) / CGFloat(self.labelCount)), alpha: 1)
            label.isHidden = true
            labels.append(label)
        }

        self.labels = labels

        super.init(frame: frame)

        self.backgroundColor = .black

        for label in labels {
            addSubview(label)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("peepee")
    }

    func setup(font: UIFont, text: String) {
        for label in self.labels {
            label.font = font
            label.text = text
            label.sizeToFit()
            label.frame = CGRect(
                x: self.bounds.midX - (label.bounds.size.width / 2.0),
                y: self.bounds.midY - (label.bounds.size.height / 2.0),
                width: label.bounds.size.width,
                height: label.bounds.size.height
            )
        }
    }

    func showTick(_ tick: Int, duration: TimeInterval) {
        if tick % 2 == 1 {
            return
        }

        if tick == 0 {
            self.backgroundColor = .white

            UIView.animate(withDuration: SoundtrackConfig.barLength, delay: 0, options: [.curveLinear], animations: {
                self.backgroundColor = .black
            }, completion: nil)
        }

        let viewIndex = tick / 2
        let label = self.labels[viewIndex]
        label.isHidden = false
        let startScale = CGFloat((self.labelCount + 1) - viewIndex) / CGFloat(self.labelCount)
        let endScale = CGFloat(self.labelCount - viewIndex) / CGFloat(self.labelCount)

        label.transform = CGAffineTransform.identity.scaledBy(x: startScale, y: startScale)

        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseIn], animations: {
            label.transform = CGAffineTransform.identity.scaledBy(x: endScale, y: endScale)
        }, completion: nil)
    }
}
