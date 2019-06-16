//
//  ViewController.swift
//  demo
//
//  Created by Johan Halin on 12/03/2018.
//  Copyright © 2018 Dekadence. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation

class BadKerningViewController: UIViewController {
    let autostart = false
    let animationDuration = 0.2
    let timestamps = [4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 20.625, 20.75, 21, 21.375, 22, 22.75, 23, 23.375, 24, 24.625, 25, 25.375, 26, 27, 27.375, 28, 29, 30, 30.625, 30.75, 31, 31.375, 32, 32.75, 33, 33.375, 34, 34.625, 35, 35.375, 36, 37, 37.375, 38, 38.625, 38.75, 39, 39.375, 40, 41, 42, 43, 44, 44.625, 44.75, 45, 45.375, 46, 46.75, 47, 47.375, 48, 48.625, 49, 49.375, 50, 51, 51.375, 52, 52.625, 52.75, 53, 53.375, 54, 54.75, 55, 55.375, 56, 56.625, 57, 57.375, 58, 59]
    let shapes: [Int]
    
    let audioPlayer: AVAudioPlayer
    let startButton: UIButton
    let qtFoolingBgView: UIView = UIView.init(frame: CGRect.zero)
    let contentView = UIView()

    let text = "“Like oratory, music, dance, calligraphy – like anything that lends its grace to language – typography is an art that can be deliberately misused. It is a craft by which the meanings of a text (or its absence of meaning) can be clarified, honored and shared, or knowingly disguised.”\n\nRobert Bringhurst, “The Elements of Typographic Style”"
    var labels = [UILabel]()
    var position = 0
    
    // MARK: - UIViewController
    
    init() {
        if let trackUrl = Bundle.main.url(forResource: "beaches2", withExtension: "m4a") {
            guard let audioPlayer = try? AVAudioPlayer(contentsOf: trackUrl) else {
                abort()
            }
            
            self.audioPlayer = audioPlayer
        } else {
            abort()
        }

        let startButtonText =
            "\"bad kerning\"\n" +
                "by dekadence\n" +
                "\n" +
                "programming and music by ricky martin\n" +
                "\n" +
                "presented at beaches leave 2019\n" +
                "\n" +
        "tap anywhere to start"
        self.startButton = UIButton.init(type: UIButton.ButtonType.custom)
        self.startButton.setTitle(startButtonText, for: UIControl.State.normal)
        self.startButton.titleLabel?.numberOfLines = 0
        self.startButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.startButton.backgroundColor = UIColor.black
        
        let shapeCount = 5
        var shapes = [Int]()
        var lastShape = -1
        
        while shapes.count < self.timestamps.count {
            var shapeBag = (0..<shapeCount).shuffled()
            while shapeBag.first! == lastShape {
                shapeBag = (0..<shapeCount).shuffled()
            }
            
            lastShape = shapeBag.last!
            
            shapes.append(contentsOf: shapeBag)
        }
        
        self.shapes = shapes
        
        super.init(nibName: nil, bundle: nil)
        
        self.startButton.addTarget(self, action: #selector(startButtonTouched), for: UIControl.Event.touchUpInside)
        
        self.view.backgroundColor = .black
        
        self.qtFoolingBgView.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        
        // barely visible tiny view for fooling Quicktime player. completely black images are ignored by QT
        self.view.addSubview(self.qtFoolingBgView)
        
        self.contentView.isHidden = true
        self.contentView.backgroundColor = .white
        self.view.addSubview(self.contentView)
        
        if !self.autostart {
            self.view.addSubview(self.startButton)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.audioPlayer.prepareToPlay()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.qtFoolingBgView.frame = CGRect(
            x: (self.view.bounds.size.width / 2) - 1,
            y: (self.view.bounds.size.height / 2) - 1,
            width: 2,
            height: 2
        )

        self.startButton.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        
        self.contentView.frame = self.startButton.frame
        
        createLabels()
    }
    
    private func createLabels() {
        let textBoxWidth: CGFloat = 510
        let left = (self.contentView.bounds.size.width / 2.0) - (textBoxWidth / 2.0)
        let right = left + textBoxWidth
        let font = UIFont(name: "Palatino", size: 20)
        
        var previousFrame: CGRect? = nil
        
        for i in self.text.indices {
            let char = self.text[i]
        
            let label = UILabel(frame: .zero)
            label.text = "\(char)"
            label.font = font
            label.sizeToFit()

            if char != " " && char != "\n" {
                self.contentView.addSubview(label)
                self.labels.append(label)
            }

            if var previousFrame = previousFrame {
                if char == "\n" {
                    previousFrame.origin = CGPoint(x: left, y: previousFrame.origin.y + (previousFrame.size.height * (2.0 / 3.0)))
                }

                func setFrame(previousFrame: CGRect) -> CGRect {
                    label.frame.origin = CGPoint(x: previousFrame.origin.x + previousFrame.size.width, y: previousFrame.origin.y)
                    return label.frame
                }
                
                if char == " " {
                    var nextIndex = self.text.index(after: i)
                    var nextCharacter = self.text[nextIndex]
                    var prevFrame = previousFrame
                    label.text = "\(nextCharacter)"
                    prevFrame = setFrame(previousFrame: prevFrame)
                    
                    while nextCharacter != " " && nextCharacter != "\n" {
                        nextIndex = self.text.index(after: nextIndex)
                        if nextIndex == self.text.indices.endIndex {
                            break
                        }
                        
                        nextCharacter = self.text[nextIndex]
                        label.text = "\(nextCharacter)"
                        
                        prevFrame = setFrame(previousFrame: prevFrame)
                    }
                    
                    if label.frame.origin.x > right {
                        label.frame.origin = CGPoint(x: left, y: previousFrame.origin.y + previousFrame.size.height + 4)
                    } else {
                        previousFrame = setFrame(previousFrame: previousFrame)
                    }
                } else {
                    previousFrame = setFrame(previousFrame: previousFrame)
                }
            } else {
                label.frame.origin = CGPoint(x: left, y: 0)
            }
            
            previousFrame = label.frame
        }
        
        guard let lastLabel = self.labels.last else { return }
        
        let boxHeight = lastLabel.frame.origin.y + lastLabel.bounds.size.height
        let top = (self.contentView.bounds.size.height / 2.0) - (boxHeight / 2.0)
        
        for label in self.labels {
            label.frame.origin.y += top
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.autostart {
            start()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.audioPlayer.stop()
    }
    
    // MARK: - Private
    
    @objc
    fileprivate func startButtonTouched(button: UIButton) {
        self.startButton.isUserInteractionEnabled = false
        
        // long fadeout to ensure that the home indicator is gone
        UIView.animate(withDuration: 4, animations: {
            self.startButton.alpha = 0
        }, completion: { _ in
            self.start()
        })
    }
    
    fileprivate func start() {
        self.audioPlayer.play()
        
        self.view.backgroundColor = .white
        self.contentView.isHidden = false
        
        scheduleEvents()
    }
    
    private func scheduleEvents() {
        for timestamp in self.timestamps {
            perform(#selector(event), with: nil, afterDelay: timestamp)
        }
    }
    
    @objc private func event() {
        shake(long: self.position < 16)
        
        if self.position >= 16 {
            resetContentView()
        }
        
        if self.position < 16 {
            randomize()
        } else if self.position == 32 {
            circle()
            rotateContentView(full: false)
        } else if self.position == 33 {
            equilateralTriangle()
            rotateContentView(full: false)
        } else if self.position == 55 {
            circle()
            rotateContentView(full: true)
        } else if self.position == 56 {
            rectangle()
            rotateContentView(full: true)
        } else if self.position == 57 {
            equilateralTriangle()
            rotateContentView(full: true)
        } else if self.position == 58 {
            rectangle()
            rotateContentView(full: true)
        } else if self.position == 88 {
            equilateralTriangle()
            rotateContentView(full: true)
        } else if self.position == 89 {
            circle(position: self.position)
            end()
        } else {
            switch self.shapes[self.position] {
            case 0: rectangle()
            case 1: quad()
            case 2: circle()
            case 3: triangle()
            case 4: equilateralTriangle()
            default: abort()
            }
        }
        
        if self.position >= 34 && self.position < 55 {
            if Int.random(in: 0...2) == 0 {
                rotateContentView(full: false)
            }
        } else if self.position >= 59 && self.position < 88 {
            switch Int.random(in: 0...4) {
            case 0: rotateContentView(full: false)
            case 1: rotateContentView(full: true)
            default: break
            }
        }
        
        self.position += 1
    }
    
    private func end() {
        for (index, label) in self.labels.enumerated() {
            UIView.animate(withDuration: 2, delay: TimeInterval(index) * 0.02, options: [.beginFromCurrentState], animations: {
                label.alpha = 0
            }, completion: nil)
        }
    }
    
    private func shake(long: Bool) {
        let offset: CGFloat = 20
        let sign: CGFloat = Bool.random() ? 1 : -1
        let x = CGFloat.random(in: offset...(offset * 2)) * sign
        let y = CGFloat.random(in: offset...(offset * 2)) * sign
        
        self.contentView.center = CGPoint(x: self.view.center.x + x, y: self.view.center.y + y)
        
        UIView.animate(withDuration: long ? 0.2 : 0.1, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0.2, options: [.curveEaseOut], animations: {
            self.contentView.center = self.view.center
        }, completion: nil)
    }
    
    private func randomize() {
        let count = (self.position + 1) * 3

        for _ in 0..<count {
            let label = self.labels.randomElement()!
            label.layer.removeAllAnimations()

            animateCharacter(label, short: true)
        }
    }
    
    private func rectangle() {
        let maxWidth = self.view.bounds.size.width - 40
        let maxHeight = self.view.bounds.size.height - 40
        let width = CGFloat.random(in: 50...maxWidth)
        let height = CGFloat.random(in: 50...maxHeight)
        let point1 = CGPoint(x: self.view.center.x - (width / 2.0), y: self.view.center.y - (height / 2.0))
        let point2 = CGPoint(x: self.view.center.x + (width / 2.0), y: self.view.center.y - (height / 2.0))
        let point3 = CGPoint(x: self.view.center.x + (width / 2.0), y: self.view.center.y + (height / 2.0))
        let point4 = CGPoint(x: self.view.center.x - (width / 2.0), y: self.view.center.y + (height / 2.0))

        quad(point1, point2, point3, point4)
    }
    
    private func quad() {
        let offset: CGFloat = 40
        let width = self.view.bounds.size.width
        let height = self.view.bounds.size.height
        let point1 = CGPoint(x: CGFloat.random(in: offset...(width - (offset * 2))), y: CGFloat.random(in: offset...(height - (offset * 2))))
        let point2 = CGPoint(x: CGFloat.random(in: offset...(width - (offset * 2))), y: CGFloat.random(in: offset...(height - (offset * 2))))
        let point3 = CGPoint(x: CGFloat.random(in: offset...(width - (offset * 2))), y: CGFloat.random(in: offset...(height - (offset * 2))))
        let point4 = CGPoint(x: CGFloat.random(in: offset...(width - (offset * 2))), y: CGFloat.random(in: offset...(height - (offset * 2))))
        
        quad(point1, point2, point3, point4)
    }
    
    private func circle(position: Int = 0) {
        let offset: CGFloat = 40
        let radius = CGFloat.random(in: 75...((self.view.bounds.size.height / 2.0) - offset))
        let shuffledLabels = self.labels.shuffled()
        
        for (index, label) in shuffledLabels.enumerated() {
            let angle = (CGFloat(index) / CGFloat(shuffledLabels.count)) * (CGFloat.pi * 2.0)
            
            UIView.animate(withDuration: self.animationDuration, delay: 0, options: [.curveEaseOut], animations: {
                label.center = CGPoint(
                    x: self.view.center.x + (radius * cos(angle)),
                    y: self.view.center.y + (radius * sin(angle))
                )
            }, completion: { _ in
                self.animateCharacter(label, small: true, position: position)
            })
        }
    }
    
    private func triangle() {
        let offset: CGFloat = 40
        let width = self.view.bounds.size.width
        let height = self.view.bounds.size.height
        let point1 = CGPoint(x: CGFloat.random(in: offset...(width - (offset * 2))), y: CGFloat.random(in: offset...(height - (offset * 2))))
        let point2 = CGPoint(x: CGFloat.random(in: offset...(width - (offset * 2))), y: CGFloat.random(in: offset...(height - (offset * 2))))
        let point3 = CGPoint(x: CGFloat.random(in: offset...(width - (offset * 2))), y: CGFloat.random(in: offset...(height - (offset * 2))))

        triangle(point1, point2, point3)
    }
    
    private func equilateralTriangle() {
        let offset: CGFloat = 40
        let height = CGFloat.random(in: 75...(self.view.bounds.size.height - (offset * 2.0)))
        let sideLength = (2.0 * height) / sqrt(3.0)
        let point1 = CGPoint(x: (self.view.bounds.size.width / 2.0), y: (self.view.bounds.size.height / 2.0) - (height / 2.0))
        let point2 = CGPoint(x: (self.view.bounds.size.width / 2.0) + (sideLength / 2.0), y: (self.view.bounds.size.height / 2.0) + (height / 2.0))
        let point3 = CGPoint(x: (self.view.bounds.size.width / 2.0) - (sideLength / 2.0), y: (self.view.bounds.size.height / 2.0) + (height / 2.0))

        triangle(point1, point2, point3)
    }
    
    private func quad(_ point1: CGPoint, _ point2: CGPoint, _ point3: CGPoint, _ point4: CGPoint) {
        let p1p2d = hypot(point1.x - point2.x, point1.y - point2.y)
        let p2p3d = hypot(point2.x - point3.x, point2.y - point3.y)
        let p3p4d = hypot(point3.x - point4.x, point3.y - point4.y)
        let p4p1d = hypot(point4.x - point1.x, point4.y - point1.y)
        let totalLength = p1p2d + p2p3d + p3p4d + p4p1d
        let shuffledLabels = self.labels.shuffled()
        let p1p2charCount = Int((p1p2d / totalLength) * CGFloat(shuffledLabels.count))
        let p2p3charCount = Int((p2p3d / totalLength) * CGFloat(shuffledLabels.count))
        let p3p4charCount = Int((p3p4d / totalLength) * CGFloat(shuffledLabels.count))
        let p4p1charCount = Int((p4p1d / totalLength) * CGFloat(shuffledLabels.count))
        let p1p2slice = shuffledLabels[0..<p1p2charCount]
        let p2p3slice = shuffledLabels[p1p2slice.count..<(p1p2slice.count + p2p3charCount)]
        let p3p4slice = shuffledLabels[(p1p2slice.count + p2p3slice.count)..<(p1p2slice.count + p2p3slice.count + p3p4charCount)]
        let p4p1slice = shuffledLabels[(p1p2slice.count + p2p3slice.count + p3p4charCount)..<(p1p2slice.count + p2p3slice.count + p3p4charCount + p4p1charCount)]
        let endIndex = p1p2charCount + p2p3charCount + p3p4charCount + p4p1charCount
        
        line(startPoint: point1, endPoint: point2, slice: p1p2slice)
        line(startPoint: point2, endPoint: point3, slice: p2p3slice)
        line(startPoint: point3, endPoint: point4, slice: p3p4slice)
        line(startPoint: point4, endPoint: point1, slice: p4p1slice)
        
        let remainingCharacters = shuffledLabels[endIndex..<shuffledLabels.count]
        
        for label in remainingCharacters {
            animateCharacter(label)
        }
    }
    
    private func triangle(_ point1: CGPoint, _ point2: CGPoint, _ point3: CGPoint) {
        let p1p2d = hypot(point1.x - point2.x, point1.y - point2.y)
        let p2p3d = hypot(point2.x - point3.x, point2.y - point3.y)
        let p3p1d = hypot(point3.x - point1.x, point3.y - point1.y)
        let totalLength = p1p2d + p2p3d + p3p1d
        let shuffledLabels = self.labels.shuffled()
        let p1p2charCount = Int((p1p2d / totalLength) * CGFloat(shuffledLabels.count))
        let p2p3charCount = Int((p2p3d / totalLength) * CGFloat(shuffledLabels.count))
        let p3p1charCount = Int((p3p1d / totalLength) * CGFloat(shuffledLabels.count))
        let p1p2slice = shuffledLabels[0..<p1p2charCount]
        let p2p3slice = shuffledLabels[p1p2slice.count..<(p1p2slice.count + p2p3charCount)]
        let p3p1slice = shuffledLabels[(p1p2slice.count + p2p3slice.count)..<(p1p2slice.count + p2p3slice.count + p3p1charCount)]
        let endIndex = p1p2charCount + p2p3charCount + p3p1charCount
        
        line(startPoint: point1, endPoint: point2, slice: p1p2slice)
        line(startPoint: point2, endPoint: point3, slice: p2p3slice)
        line(startPoint: point3, endPoint: point1, slice: p3p1slice)
        
        let remainingCharacters = shuffledLabels[endIndex..<shuffledLabels.count]
        
        for label in remainingCharacters {
            animateCharacter(label)
        }
    }
    
    private func line(startPoint: CGPoint, endPoint: CGPoint, slice: ArraySlice<UILabel>) {
        for (index, label) in slice.enumerated() {
            let position = CGFloat(index) / CGFloat(slice.count)
            
            label.layer.removeAllAnimations()
            
            UIView.animate(withDuration: self.animationDuration, delay: 0, options: [.curveEaseOut], animations: {
                label.center = CGPoint(
                    x: ((endPoint.x - startPoint.x) * position) + startPoint.x,
                    y: ((endPoint.y - startPoint.y) * position) + startPoint.y
                )
            }, completion: { _ in
                self.animateCharacter(label, small: true)
            })
        }
    }
    
    private func animateCharacter(_ label: UIView, small: Bool = false, short: Bool = false, position: Int = 0) {
        let offset: CGFloat = small ? 5 : 20
        let x = -offset + CGFloat.random(in: 0...(offset * 2))
        let y = -offset + CGFloat.random(in: 0...(offset * 2))
        let endOffset = position == 89 ? x * 10 : 0
        let longEndDuration: TimeInterval = position == 89 ? 8 : 1
        
        UIView.animate(withDuration: short ? 0.1 : self.animationDuration, delay: 0, options: [.curveLinear], animations: {
            label.center = CGPoint(x: label.center.x + x, y: label.center.y + y)
        }, completion: { _ in
            UIView.animate(withDuration: short ? 8 : longEndDuration, delay: 0, options: [.curveEaseOut], animations: {
                label.center = CGPoint(x: label.center.x + x + endOffset, y: label.center.y + y + endOffset)
            }, completion: nil)
        })
    }
    
    private func resetContentView() {
        self.contentView.layer.removeAllAnimations()
        self.contentView.layer.transform = CATransform3DIdentity
        self.contentView.layer.transform.m34 = -0.002
    }
    
    private func rotateContentView(full: Bool) {
        let angleX = full ? 0 : (Double.random(in: 0.5...1.0) * (Bool.random() ? -1 : 1))
        let angleY = full ? -Double.pi : (Double.random(in: 0.5...1.0) * (Bool.random() ? -1 : 1))
        let timingFunction = full ? CAMediaTimingFunction(name: .linear) : CAMediaTimingFunction(name: .easeOut)
        
        let animationX = CABasicAnimation(keyPath: "transform.rotation.x")
        animationX.toValue = NSNumber(floatLiteral: angleX)
        animationX.duration = 1
        animationX.timingFunction = timingFunction
        self.contentView.layer.add(animationX, forKey: "rotationX")

        let animationY = CABasicAnimation(keyPath: "transform.rotation.y")
        animationY.toValue = NSNumber(floatLiteral: angleY)
        animationY.duration = 1
        animationY.timingFunction = timingFunction
        self.contentView.layer.add(animationY, forKey: "rotationY")
    }
}
