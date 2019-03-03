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

class ModernPicturesViewController: UIViewController {
    let audioPlayer: AVAudioPlayer
    let startButton: UIButton
    let qtFoolingBgView: UIView = UIView.init(frame: CGRect.zero)
    let contentView = UIView()
    
    var textMaskView1: MaskedTextContainerView?
    var textMaskView2: MaskedTextContainerView?
    var textMaskView3: MaskedTextContainerView?

    var circlesMaskView1: MaskedCirclesContainerView?
    var circlesMaskView2: MaskedHorizontalCirclesContainerView?
    
    var boyView: TextFlickerView?
    var girlView: TextFlickerView?
    
    var squaresMaskView1: MaskedSquaresRotationContainerView?
    var squaresMaskView2: MaskedSquaresFlipContainerView?
    
    let tunnelView = UIImageView(image: UIImage(named: "tunnel"))
    let tunnelContentView = UIView()
    
    // MARK: - UIViewController
    
    init() {
        if let trackUrl = Bundle.main.url(forResource: "placeholder", withExtension: "m4a") {
            guard let audioPlayer = try? AVAudioPlayer(contentsOf: trackUrl) else {
                abort()
            }
            
            self.audioPlayer = audioPlayer
        } else {
            abort()
        }
        
        let startButtonText =
            "\"modern pictures\"\n" +
                "by dekadence\n" +
                "\n" +
                "programming and music by ricky martin\n" +
                "\n" +
                "presented at instanssi 2019\n" +
                "\n" +
        "tap anywhere to start"
        self.startButton = UIButton.init(type: UIButton.ButtonType.custom)
        self.startButton.setTitle(startButtonText, for: UIControl.State.normal)
        self.startButton.titleLabel?.numberOfLines = 0
        self.startButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.startButton.backgroundColor = UIColor.black
        
        super.init(nibName: nil, bundle: nil)
        
        self.startButton.addTarget(self, action: #selector(startButtonTouched), for: UIControl.Event.touchUpInside)
        
        self.view.backgroundColor = .black
        
        self.qtFoolingBgView.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        
        // barely visible tiny view for fooling Quicktime player. completely black images are ignored by QT
        self.view.addSubview(self.qtFoolingBgView)
        
        self.contentView.isHidden = true
        self.contentView.backgroundColor = .black
        self.view.addSubview(self.contentView)
        
        self.tunnelContentView.addSubview(self.tunnelView)
        
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

        self.contentView.frame = self.view.bounds
        
        self.textMaskView1 = MaskedTextContainerView(frame: self.view.bounds, labelCount: 2)
        self.contentView.addSubview(self.textMaskView1!)

        self.textMaskView2 = MaskedTextContainerView(frame: self.view.bounds, labelCount: 3)
        self.contentView.addSubview(self.textMaskView2!)

        self.textMaskView3 = MaskedTextContainerView(frame: self.view.bounds, labelCount: 4)
        self.contentView.addSubview(self.textMaskView3!)

        self.circlesMaskView1 = MaskedCirclesContainerView(frame: self.view.bounds)
        self.contentView.addSubview(self.circlesMaskView1!)

        self.circlesMaskView2 = MaskedHorizontalCirclesContainerView(frame: self.view.bounds)
        self.contentView.addSubview(self.circlesMaskView2!)

        self.boyView = TextFlickerView(frame: self.view.bounds, text: "BOY")
        self.boyView?.mask = MaskVerticalView(frame: self.view.bounds, offset: 2, count: 1)
        self.boyView?.scramble(segmentCount: 0)
        self.contentView.addSubview(self.boyView!)
        
        self.girlView = TextFlickerView(frame: self.view.bounds, text: "GIRL")
        self.girlView?.mask = MaskVerticalView(frame: self.view.bounds, offset: 2, count: 1)
        self.girlView?.scramble(segmentCount: 0)
        self.contentView.addSubview(self.girlView!)
        
        self.squaresMaskView1 = MaskedSquaresRotationContainerView(frame: self.view.bounds)
        self.contentView.addSubview(self.squaresMaskView1!)
        
        self.squaresMaskView2 = MaskedSquaresFlipContainerView(frame: self.view.bounds)
        self.contentView.addSubview(self.squaresMaskView2!)
        
        self.tunnelContentView.frame = self.view.bounds
        self.tunnelContentView.mask = MaskVerticalView(frame: self.view.bounds, offset: 2, count: 1)
        self.contentView.addSubview(self.tunnelContentView)

        self.tunnelView.frame = self.view.bounds
        
        self.startButton.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.audioPlayer.stop()
    }
    
    // MARK: - Private
    
    fileprivate func start() {
        self.contentView.isHidden = false
        
        self.audioPlayer.play()
        
        self.textMaskView1?.setText(text1: "Modern", text2: "Modern")

        showContentView(identifier: 0)

        scheduleEvents()
    }
    
    private func scheduleEvents() {
        let tick = ((120.0 / 130.0) / 8.0)
        let length = tick * 36.0
        let loops = 3 * 8
        
        for position in 0..<loops {
            let startTime = length * Double(position)
            
            let hit1 = startTime + (tick * 15.0)
            if position == 14 {
                perform(#selector(tunnelEvent1), with: nil, afterDelay: hit1)
            } else if position == 19 {
                perform(#selector(tunnelEvent2), with: nil, afterDelay: hit1)
            } else if position == 21 {
                perform(#selector(tunnelEvent3), with: nil, afterDelay: hit1)
            } else {
                perform(#selector(event1), with: nil, afterDelay: hit1)
            }
            
            let hit2 = startTime + (tick * 32.0)
            if position != 21 {
                perform(#selector(event2), with: nil, afterDelay: hit2)
            }
            
            let hit3 = startTime + (tick * 33.0)
            if position == 2 {
                perform(#selector(event4), with: nil, afterDelay: hit3)
                perform(#selector(event3), with: nil, afterDelay: hit3 + ModernPicturesConstants.shapeAnimationDuration)
            } else if position == 5 {
                perform(#selector(boyEvent1), with: nil, afterDelay: hit3)
            } else if position == 8 {
                perform(#selector(girlEvent1), with: nil, afterDelay: hit3)
            } else if position == 11 {
                perform(#selector(event6), with: nil, afterDelay: hit3)
                perform(#selector(event3), with: nil, afterDelay: hit3 + ModernPicturesConstants.shapeAnimationDuration)
            } else if position == 12 {
                perform(#selector(tunnelEvent1), with: nil, afterDelay: hit3)
            } else if position == 14 {
                perform(#selector(event5), with: nil, afterDelay: hit3)
                perform(#selector(event3), with: nil, afterDelay: hit3 + ModernPicturesConstants.shapeAnimationDuration)
            } else if position == 17 {
                perform(#selector(boyEvent2), with: nil, afterDelay: hit3)
            } else if position == 20 {
                perform(#selector(event7), with: nil, afterDelay: hit3)
                perform(#selector(girlEvent2), with: nil, afterDelay: hit3 + ModernPicturesConstants.shapeAnimationDuration)
            } else if position != 21 {
                perform(#selector(event3), with: nil, afterDelay: hit3)
            }
        }

        let endTime = length * Double(loops)
        perform(#selector(endEvent1), with: nil, afterDelay: endTime - (tick * 2))
        perform(#selector(endEvent2), with: nil, afterDelay: endTime + (tick * 32))
    }
    
    @objc
    private func event1() {
        if Bool.random() {
            let word = randomWord()
            self.textMaskView2?.setText(text1: word, text2: word, text3: word)
        } else {
            self.textMaskView2?.setText(text1: randomWord(), text2: randomWord(), text3: randomWord())
        }
        
        showContentView(identifier: 1)
    }
    
    @objc
    private func event2() {
        if Bool.random() {
            let word = randomWord()
            self.textMaskView3?.setText(text1: word, text2: word, text3: word, text4: word)
        } else {
            self.textMaskView3?.setText(text1: randomWord(), text2: randomWord(), text3: randomWord(), text4: randomWord())
        }
        
        showContentView(identifier: 2)
    }

    @objc
    private func event3() {
        if Bool.random() {
            let word = randomWord()
            self.textMaskView1?.setText(text1: word, text2: word)
        } else {
            self.textMaskView1?.setText(text1: randomWord(), text2: randomWord())
        }

        showContentView(identifier: 0)
    }

    @objc
    private func event4() {
        self.circlesMaskView1?.animate()
        
        showContentView(identifier: 3)
    }

    @objc
    private func event5() {
        self.circlesMaskView2?.animate()
        
        showContentView(identifier: 4)
    }

    @objc
    private func event6() {
        self.squaresMaskView1?.animate()
        
        showContentView(identifier: 7)
    }
    
    @objc
    private func event7() {
        self.squaresMaskView2?.animate()
        
        showContentView(identifier: 8)
    }
    
    @objc
    private func boyEvent1() {
        showContentView(identifier: 5)
        
        Timer.scheduledTimer(withTimeInterval: 1.2, repeats: false, block: { timer in
            self.boyView?.scramble(segmentCount: 1)
        })
    }

    @objc
    private func boyEvent2() {
        showContentView(identifier: 5)
        
        self.boyView?.scramble(segmentCount: 0)
        
        var count = 1
        
        Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true, block: { timer in
            self.boyView?.scramble(segmentCount: count)
            
            count += 1
            if count == 10 {
                timer.invalidate()
            }
        })
    }

    @objc
    private func tunnelEvent1() {
        showContentView(identifier: 9)

        UIView.animate(withDuration: ModernPicturesConstants.tunnelAnimationDuration, delay: 0, options: [.curveLinear], animations: {
            self.tunnelView.transform = self.tunnelView.transform.scaledBy(x: 1.05, y: 1.05)
        }, completion: nil)
    }
    
    @objc
    private func tunnelEvent2() {
        showContentView(identifier: 9)
        
        UIView.animate(withDuration: ModernPicturesConstants.tunnelAnimationDuration, delay: 0, options: [.curveLinear], animations: {
            let transform = self.tunnelView.transform.scaledBy(x: 1.1, y: 1.1)
            self.tunnelView.transform = transform.rotated(by: 0.02)
        }, completion: nil)
    }
    
    @objc
    private func tunnelEvent3() {
        showContentView(identifier: 9)
        
        UIView.animate(withDuration: ModernPicturesConstants.tunnelAnimationDuration * 2, delay: 0, options: [.curveLinear], animations: {
            let transform = self.tunnelView.transform.scaledBy(x: 1.1, y: 1.1)
            self.tunnelView.transform = transform.rotated(by: 0.1)
        }, completion: nil)
    }
    
    @objc
    private func girlEvent1() {
        showContentView(identifier: 6)
        
        Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false, block: { timer in
            self.girlView?.scramble(segmentCount: 2)
        })

        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { timer in
            self.girlView?.scramble(segmentCount: 5)
        })
    }

    @objc
    private func girlEvent2() {
        showContentView(identifier: 6)

        self.girlView?.scramble(segmentCount: 4)
        
        var count = 1
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { timer in
            self.girlView?.scramble(segmentCount: count)
            
            count += 1
            if count == 10 {
                timer.invalidate()
            }
        })
    }

    @objc
    private func endEvent1() {
        showContentView(identifier: 5)

        var count = 0
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { timer in
            self.boyView?.scramble(segmentCount: self.boyView!.segmentCount)
            self.girlView?.scramble(segmentCount: self.girlView!.segmentCount)
            
            count += 1
            if (count >= 50) {
                timer.invalidate()
            }
            
            if Int.random(in: 0...1) % 2 == 0 {
                self.showContentView(identifier: 5)
            } else {
                self.showContentView(identifier: 6)
            }
        })
    }

    @objc
    private func endEvent2() {
        self.contentView.isHidden = true
    }
    
    private func randomWord() -> String {
        let word = ModernPicturesConstants.vocabulary[Int.random(in: 0..<ModernPicturesConstants.vocabulary.count)]
        
        switch arc4random_uniform(3) {
        case 0:
            return word.capitalized
        case 1:
            return word.uppercased()
        default:
            return word
        }
    }
    
    private func showContentView(identifier: Int) {
        for (index, view) in self.contentView.subviews.enumerated() {
            view.isHidden = identifier != index
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
}

extension Bool {
    static func random() -> Bool {
        return arc4random_uniform(2) == 0
    }
}
