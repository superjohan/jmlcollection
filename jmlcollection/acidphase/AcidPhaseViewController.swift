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

class AcidPhaseViewController: UIViewController {
    let audioPlayer: AVAudioPlayer
    let startButton: UIButton
    let contentView: UIView = UIView.init(frame: .zero)
    let qtFoolingBgView: UIView = UIView.init(frame: CGRect.zero)

    private let sequenceCount = 260
    private let rotatedViewCount = 8
    
    private var rotatedViews = [AcidPhaseShufflingView]()
    private var sequences = [[AcidPhaseBoard]]()
    private var sequenceCounter = 1
    
    // MARK: - UIViewController
    
    init() {
        if let trackUrl = Bundle.main.url(forResource: "literalacidphase", withExtension: "m4a") {
            guard let audioPlayer = try? AVAudioPlayer(contentsOf: trackUrl) else {
                abort()
            }
            
            self.audioPlayer = audioPlayer
        } else {
            abort()
        }
        
        let startButtonText =
            "\"literal acid phase\"\n" +
                "by dekadence\n" +
                "\n" +
                "programming and music by ricky martin\n" +
                "\n" +
                "presented at vortex 2018\n" +
                "\n" +
        "tap anywhere to start"
        self.startButton = UIButton.init(type: UIButton.ButtonType.custom)
        self.startButton.setTitle(startButtonText, for: UIControl.State.normal)
        self.startButton.titleLabel?.numberOfLines = 0
        self.startButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.startButton.backgroundColor = UIColor.black
        
        super.init(nibName: nil, bundle: nil)
        
        createBoards()
        
        self.startButton.addTarget(self, action: #selector(startButtonTouched), for: UIControl.Event.touchUpInside)
        
        self.view.backgroundColor = .black
        
        self.qtFoolingBgView.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        
        // barely visible tiny view for fooling Quicktime player. completely black images are ignored by QT
        self.view.addSubview(self.qtFoolingBgView)
        
        self.contentView.backgroundColor = .white
        self.contentView.isHidden = true
        self.view.addSubview(self.contentView)
        
        let colors = [
            UIColor(red: (168.0 / 255.0), green: (173.0 / 255.0), blue: (168.0 / 255.0), alpha: 1.0),
            UIColor(red: (249.0 / 255.0), green: (209.0 / 255.0), blue: (71.0 / 255.0), alpha: 1.0),
            UIColor(red: (237.0 / 255.0), green: (72.0 / 255.0), blue: (56.0 / 255.0), alpha: 1.0),
            UIColor(red: (68.0 / 255.0), green: (162.0 / 255.0), blue: (231.0 / 255.0), alpha: 1.0)
        ]
        
        for i in 0..<self.rotatedViewCount {
            let rotatedView = AcidPhaseShufflingView(frame: .zero, color: colors[i % 4])
            self.rotatedViews.append(rotatedView)
            self.contentView.addSubview(rotatedView)
        }

        self.view.addSubview(self.startButton)
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
        
        self.contentView.frame = self.view.bounds
        
        for rotatedView in self.rotatedViews {
            let length = self.contentView.bounds.size.height * 0.6
            rotatedView.frame = CGRect(
                x: (self.contentView.bounds.size.width / 2.0) - (length / 2.0),
                y: (self.contentView.bounds.size.height / 2.0) - (length / 2.0),
                width: length,
                height: length
            )
            
            rotatedView.layer.compositingFilter = "multiplyBlendMode"
            rotatedView.adjustViews(toBoard: AcidPhaseBoard.initialBoard(), animated: false)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.audioPlayer.stop()
    }
    
    // MARK: - Private
    
    private func createBoards() {
        var baseBoards = [AcidPhaseBoard]()
        baseBoards.append(AcidPhaseBoard.boardByMovingOnePosition(fromBoard: AcidPhaseBoard.initialBoard()))
        
        let middle = (self.sequenceCount / 2)

        for i in 1..<self.sequenceCount {
            let previousBoard = baseBoards[i - 1]

            if i > middle {
                baseBoards.append(baseBoards[self.sequenceCount - i - 1])
            } else {
                baseBoards.append(AcidPhaseBoard.boardByMovingOnePosition(fromBoard: previousBoard))
            }
        }
        
        self.sequences.append(baseBoards)

        let initialOffset = 30
        
        for i in 1..<self.rotatedViewCount {
            var boards = [AcidPhaseBoard]()
            let offset = initialOffset + (16 * (i - 1))
            
            for (index, board) in baseBoards.enumerated() {
                if (index > middle) {
                    boards.append(boards[self.sequenceCount - index - 1])
                } else if (index < offset || index > (self.sequenceCount - offset)) {
                    boards.append(board)
                } else {
                    boards.append(AcidPhaseBoard.boardByMovingOnePosition(fromBoard: boards[index - 1]))
                }
            }

            self.sequences.append(boards)
        }
    }
    
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
        
        self.contentView.isHidden = false
        
        let totalDuration = 240.0 / AcidPhaseConstants.timeDivider
        let durationDelta = 7.0 / AcidPhaseConstants.timeDivider
        
        for (index, rotatedView) in self.rotatedViews.enumerated() {
            let duration = TimeInterval(totalDuration - (Double(index) * durationDelta))
            rotate(view: rotatedView, from: 0, to: CGFloat.pi * 2.0, duration: duration)
        }
        
        scheduleEvents()
    }
    
    private func scheduleEvents() {
        let interval = 120.0 / 130.0 / AcidPhaseConstants.timeDivider
        var position = -0.1
        var counter = 1
        
        while counter < self.sequenceCount {
            position = Double(counter) * interval
            perform(#selector(refreshBoards), with: nil, afterDelay: position)
            
            counter += 1
        }
        
        position = Double(counter) * interval
        perform(#selector(resetBoards), with: nil, afterDelay: position)
    }
    
    @objc
    private func refreshBoards() {
        for (index, rotatedView) in self.rotatedViews.enumerated() {
            let sequence = self.sequences[index]
            let board = sequence[self.sequenceCounter]
            
            rotatedView.adjustViews(toBoard: board, animated: true)

            if self.sequenceCounter == 30 {
                rotatedView.fadeColors()
            }

            if self.sequenceCounter == self.sequenceCount / 4 {
                let x: CGFloat = (CGFloat(index) / CGFloat(self.rotatedViewCount)) * self.view.bounds.width
                
                UIView.animate(withDuration: 180 / AcidPhaseConstants.timeDivider, delay: 0, options: [], animations: {
                    rotatedView.center.x = x
                }, completion: nil)
            }
            
            if self.sequenceCounter == self.sequenceCount - 33 {
                UIView.animate(withDuration: 30 / AcidPhaseConstants.timeDivider, delay: 0, options: [.beginFromCurrentState, .overrideInheritedCurve], animations: {
                    rotatedView.center.x = self.view.center.x
                })
            }
        }
        
        if self.sequenceCounter == self.sequenceCount / 4 {
            self.rotatedViews[Int.random(in: 0..<self.rotatedViewCount)].startRotation()
        }
        
        if self.sequenceCounter == self.sequenceCount / 2 {
            for (index, view) in self.rotatedViews.enumerated() {
                let scale = 1.0 - (CGFloat(index) / CGFloat(self.rotatedViewCount))
                view.startRotation(doScale: true, scale: scale)
            }
        }

        if self.sequenceCounter == self.sequenceCount - 33 {
            for view in self.rotatedViews {
                view.endRotation()
            }
        }
        
        self.sequenceCounter += 1
    }
    
    @objc
    private func resetBoards() {
        for rotatedView in self.rotatedViews {
            rotatedView.adjustViews(toBoard: AcidPhaseBoard.initialBoard(), animated: true)
        }
    }
    
    private func rotate(view: UIView, from: CGFloat, to: CGFloat, duration: TimeInterval) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = NSNumber(floatLiteral: Double(from))
        animation.toValue = NSNumber(floatLiteral: Double(to))
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        view.layer.add(animation, forKey: "rotation")
    }
}

struct AcidPhaseConstants {
    static let timeDivider = 1.0
}
