//
//  BackgroundView.swift
//  demo
//
//  Created by Johan Halin on 15.9.2020.
//  Copyright © 2020 Dekadence. All rights reserved.
//

import Foundation
import UIKit

class BackgroundView: UIView {
    let viewCount = 64
    let views: [UIView]
    let viewContainer = UIView()

    override init(frame: CGRect) {
        var views = [UIView]()

        for _ in 0...self.viewCount {
            let view = UIView()
            view.backgroundColor = .white
            views.append(view)
        }

        self.views = views

        super.init(frame: frame)

        for view in views {
            self.viewContainer.addSubview(view)
        }

        addSubview(self.viewContainer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func animate(configuration: Configuration, duration: TimeInterval) {
        self.transform = .identity
        self.layer.removeAllAnimations()
        self.viewContainer.layer.removeAllAnimations()
        self.frame = self.superview!.bounds
        self.viewContainer.frame = self.superview!.bounds

        switch configuration {
        case .verticalRandom:
            verticalRandom(duration: duration)
        case .verticalLinear:
            verticalLinear(duration: duration)
        case .horizontalRandom:
            horizontalRandom(duration: duration)
        case .horizontalLinear:
            horizontalLinear(duration: duration)
        case .angledRandom:
            angledRandom(duration: duration)
        case .angledLinear:
            angledLinear(duration: duration)
        }
    }

    private func verticalRandom(duration: TimeInterval) {
        let width = (self.bounds.size.width / CGFloat(self.viewCount)) / 2.0
        let colorConfig = Bool.random() ? Color.random : Color.white

        for (i, view) in self.views.enumerated() {
            view.frame = CGRect(
                x: (width * CGFloat(i)) * 2.0,
                y: 0,
                width: width,
                height: self.bounds.size.height
            )
            view.backgroundColor = color(colorConfig)
        }

        UIView.animate(withDuration: duration, delay: 0, options: [.curveLinear], animations: {
            for view in self.views {
                view.frame.origin.x += CGFloat.random(in: -100...100)
            }
        }, completion: nil)
    }

    private func verticalLinear(duration: TimeInterval) {
        let width = (self.bounds.size.width / CGFloat(self.viewCount)) / 2.0

        for (i, view) in self.views.enumerated() {
            view.frame = CGRect(
                x: (width * CGFloat(i)) * 2.0,
                y: 0,
                width: width,
                height: self.bounds.size.height
            )
            view.backgroundColor = color(.black)
        }

        let animation = CABasicAnimation(keyPath: "position.x")
        animation.fromValue = NSNumber(floatLiteral: Double(self.bounds.size.width / 2.0) - (Double(width) * 2.0))
        animation.toValue = NSNumber(floatLiteral: Double(self.bounds.size.width / 2.0))
        animation.duration = duration / 4.0
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.repeatCount = Float.infinity
        self.viewContainer.layer.add(animation, forKey: "xposition")
    }

    private func horizontalRandom(duration: TimeInterval) {
        let height = self.bounds.size.height / CGFloat(self.viewCount)
        let colorConfig = randomColorConfig()

        for (i, view) in self.views.enumerated() {
            view.frame = CGRect(
                x: 0,
                y: height * CGFloat(i),
                width: self.bounds.size.width,
                height: height
            )
            view.backgroundColor = color(colorConfig)
        }

        UIView.animate(withDuration: duration, delay: 0, options: [.curveLinear], animations: {
            for view in self.views {
                view.frame.origin.y += CGFloat.random(in: -100...100)
            }
        }, completion: nil)
    }

    private func horizontalLinear(duration: TimeInterval) {
        let height = (self.bounds.size.height / CGFloat(self.viewCount)) / 2.0

        for (i, view) in self.views.enumerated() {
            view.frame = CGRect(
                x: 0,
                y: (height * CGFloat(i)) * 2.0,
                width: self.bounds.size.width,
                height: height
            )
            view.backgroundColor = color(.black)
        }

        let animation = CABasicAnimation(keyPath: "position.y")
        animation.fromValue = NSNumber(floatLiteral: Double(self.bounds.size.height / 2.0) - (Double(height) * 2.0))
        animation.toValue = NSNumber(floatLiteral: Double(self.bounds.size.height / 2.0))
        animation.duration = duration / 4.0
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.repeatCount = Float.infinity
        self.viewContainer.layer.add(animation, forKey: "yposition")
    }

    private func angledRandom(duration: TimeInterval) {
        let parentBounds = self.superview!.bounds
        let length = sqrt(pow(parentBounds.size.width, 2.0) + pow(parentBounds.size.width, 2.0))

        self.frame = CGRect(
            x: parentBounds.midX - (length / 2.0),
            y: parentBounds.midY - (length / 2.0),
            width: length,
            height: length
        )

        self.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi * (0.25 + CGFloat(Int.random(in: 0...3)) * 0.5))

        let height = (self.bounds.size.height / CGFloat(self.viewCount)) / 2.0
        let colorConfig = randomColorConfig()

        for (i, view) in self.views.enumerated() {
            view.frame = CGRect(
                x: 0,
                y: 2.0 * height * CGFloat(i),
                width: self.bounds.size.width,
                height: height
            )
            view.backgroundColor = color(colorConfig)
        }

        UIView.animate(withDuration: duration, delay: 0, options: [.curveLinear], animations: {
            for view in self.views {
                view.frame.origin.y += CGFloat.random(in: -100...100)
            }
        }, completion: nil)
    }

    private func angledLinear(duration: TimeInterval) {
        let parentBounds = self.superview!.bounds
        let length = sqrt(pow(parentBounds.size.width, 2.0) + pow(parentBounds.size.width, 2.0))

        self.frame = CGRect(
            x: parentBounds.midX - (length / 2.0),
            y: parentBounds.midY - (length / 2.0),
            width: length,
            height: length
        )
        self.viewContainer.frame = CGRect(
            x: 0,
            y: 0,
            width: length,
            height: length
        )

        self.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi * (0.25 + CGFloat(Int.random(in: 0...3)) * 0.5))

        let height = (self.bounds.size.height / CGFloat(self.viewCount)) / 2.0

        for (i, view) in self.views.enumerated() {
            view.frame = CGRect(
                x: 0,
                y: (height * CGFloat(i)) * 2.0,
                width: self.bounds.size.width,
                height: height
            )
            view.backgroundColor = color(.black)
        }

        let animation = CABasicAnimation(keyPath: "position.y")
        animation.fromValue = NSNumber(floatLiteral: Double(self.bounds.size.height / 2.0) - (Double(height) * 2.0))
        animation.toValue = NSNumber(floatLiteral: Double(self.bounds.size.height / 2.0))
        animation.duration = duration / 4.0
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.repeatCount = Float.infinity
        self.viewContainer.layer.add(animation, forKey: "yposition")
    }

    private func randomColorConfig() -> Color {
        switch Int.random(in: 0...2) {
        case 0:
            return .white
        case 1:
            return .black
        case 2:
            return .random
        default:
            abort()
        }
    }

    private func color(_ color: Color) -> UIColor {
        switch color {
        case .white:
            return .white
        case .black:
            return .black
        case .random:
            return Bool.random() ? .white : .black
        }
    }

    enum Configuration {
        case verticalRandom
        case verticalLinear
        case horizontalRandom
        case horizontalLinear
        case angledRandom
        case angledLinear
    }

    enum Color {
        case white
        case black
        case random
    }

    enum Position {
        case back
        case mask
        case fore
    }
}
