//
//  TextFlickerView.swift
//  demo
//
//  Created by Johan Halin on 27/02/2019.
//  Copyright © 2019 Dekadence. All rights reserved.
//

import UIKit

class TextFlickerView: UIView {
    let labels: [UILabel]
    private let labelMasks: [TextFlickerMaskView]
    let segmentCount: Int
    let textLength: Int
    
    init(frame: CGRect, text: String) {
        var labels = [UILabel]()
        var labelText = text
        
        self.textLength = text.count
        
        for _ in 0..<text.count {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
            label.font = UIFont(name: "Menlo-Bold", size: frame.size.height - 75)
            label.text = labelText
            label.textColor = .black
            label.textAlignment = .center
            label.backgroundColor = .clear
            label.lineBreakMode = .byClipping
            label.clipsToBounds = false
            labels.append(label)
            
            let suffix = labelText.suffix(1)
            let prefix = labelText.prefix(labelText.count - 1)
            labelText = String(suffix + prefix)
        }
        
        labels.last?.textColor = ModernPicturesConstants.redColor
        
        self.labels = labels
        self.segmentCount = text.count * 4
        
        var textRect = labels[0].textRect(forBounds: labels[0].bounds, limitedToNumberOfLines: 1)
        textRect.origin.y = 0
        textRect.size.height = frame.size.height
        
        var masks = [TextFlickerMaskView]()
        
        for label in labels {
            let flickerMaskView = TextFlickerMaskView(frame: textRect, segmentCount: self.segmentCount)
            label.mask = flickerMaskView
            masks.append(flickerMaskView)
        }
        
        self.labelMasks = masks
        
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        for label in labels {
            addSubview(label)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scramble(segmentCount: Int) {
        var scrambledSegments = [Int]()
        let segments = 0..<self.segmentCount
        
        for _ in 0..<segmentCount {
            var selectedSegment: Int
            
            repeat {
                selectedSegment = segments.randomElement()!
            } while (scrambledSegments.contains(selectedSegment))
            
            scrambledSegments.append(selectedSegment)
        }
        
        var scrambleds = [[Int]]()
        for _ in 0..<(self.textLength - 1) {
            scrambleds.append([Int]())
        }
        
        for segment in scrambledSegments {
            let index = Int.random(in: 0..<scrambleds.count)
            scrambleds[index].append(segment)
        }
        
        for (index, scrambledSegments) in scrambleds.enumerated() {
            self.labelMasks[index + 1].set(visibleSegments: scrambledSegments)
        }
        
        var unscrambledSegments = [Int]()
        for segment in segments {
            if !scrambledSegments.contains(segment) {
                unscrambledSegments.append(segment)
            }
        }
        
        self.labelMasks[0].set(visibleSegments: unscrambledSegments)
    }
}

private class TextFlickerMaskView: UIView {
    let segmentCount: Int
    var visibleSegments = [Int]()
    
    init(frame: CGRect, segmentCount: Int) {
        self.segmentCount = segmentCount
        
        super.init(frame: frame)
        
        self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(visibleSegments: [Int]) {
        self.visibleSegments.removeAll()
        self.visibleSegments.append(contentsOf: visibleSegments)
        
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setLineWidth(1.0 / self.contentScaleFactor)
        
        let segmentWidth = rect.width / CGFloat(self.segmentCount / 2)
        let segmentHeight = rect.height / 2
        
        // top
        for i in 0..<(self.segmentCount / 2) {
            if self.visibleSegments.contains(i) {
                context.setFillColor(UIColor.white.cgColor)
                context.setStrokeColor(UIColor.white.cgColor)
            } else {
                context.setFillColor(UIColor.clear.cgColor)
                context.setFillColor(UIColor.clear.cgColor)
            }
            
            context.fill(
                CGRect(
                    x: CGFloat(i) * segmentWidth,
                    y: 0,
                    width: segmentWidth,
                    height: segmentHeight
                )
            )
        }
        
        // bottom
        for i in (self.segmentCount / 2)..<self.segmentCount {
            if self.visibleSegments.contains(i) {
                context.setFillColor(UIColor.white.cgColor)
                context.setStrokeColor(UIColor.white.cgColor)
            } else {
                context.setFillColor(UIColor.clear.cgColor)
                context.setFillColor(UIColor.clear.cgColor)
            }
            
            let index = i - (self.segmentCount / 2)
            
            context.fill(
                CGRect(
                    x: CGFloat(index) * segmentWidth,
                    y: rect.size.height / 2 - 1,
                    width: segmentWidth,
                    height: segmentHeight + 1
                )
            )
        }
    }
}
