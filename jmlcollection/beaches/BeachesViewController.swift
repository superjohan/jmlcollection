//
//  ViewController.swift
//  demo
//
//  Created by Johan Halin on 12/03/2018.
//  Copyright © 2018 Dekadence. All rights reserved.
//

import UIKit
import AVFoundation
import SceneKit
import Foundation

class BeachesViewController: UIViewController {
    let autostart = false
    
    let audioPlayer: AVAudioPlayer
    let startButton: UIButton
    let qtFoolingBgView: UIView = UIView.init(frame: CGRect.zero)
    let containerView = UIView(frame: .zero)
    
    var wobblyViews = [BeachesWobblyView]()
    var wobblyView: BeachesWobblyView?
    var textView: BeachesTextView?
    var bg: UIView?
    var scroller: UILabel?
    
    var introPosition = 0
    
    var textTimer: Timer?
    
    // MARK: - UIViewController
    
    init() {
        if let trackUrl = Bundle.main.url(forResource: "beaches", withExtension: "m4a") {
            guard let audioPlayer = try? AVAudioPlayer(contentsOf: trackUrl) else {
                abort()
            }

            audioPlayer.numberOfLoops = 99999
            
            self.audioPlayer = audioPlayer
        } else {
            abort()
        }
        
        let startButtonText =
            "\"beaches leave\"\n" +
                "by jumalauta\n" +
                "\n" +
                "programming and music by ylvaes\n" +
                "text by soluttautuja\n" +
                "\n" +
                "presented at skeneklubi annual meeting 2019\n" +
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
        
        self.containerView.backgroundColor = .black
        self.containerView.isHidden = true
        self.view.addSubview(self.containerView)
        
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

        self.containerView.frame = self.view.bounds
        
        self.bg = UIView()
        self.bg?.frame = CGRect(x: self.view.bounds.size.width / 2.0, y: 0, width: 0, height: self.view.bounds.size.height)
        self.bg?.backgroundColor = .black
        self.containerView.addSubview(self.bg!)

        for i in 0...7 {
            let color: UIColor
            switch i {
            case 0:
                color = UIColor(red: (127.0 / 255.0), green: 0, blue: 1, alpha: 1)
            case 1:
                color = UIColor(red: (63.0 / 255.0), green: 0, blue: 1, alpha: 1)
            case 2:
                color = .blue
            case 3:
                color = .green
            case 4:
                color = .yellow
            case 5:
                color = .orange
            case 6:
                color = .red
            case 7:
                color = .white
            default:
                abort()
            }
            
            let scale: CGFloat = 3.0 - ((CGFloat(i) / 7.0) * 2.0)
            
            let wobblyView = BeachesWobblyView(frame: self.view.bounds, tintColor: color, singleImage: true)
            wobblyView.transform = CGAffineTransform.identity.scaledBy(x: scale, y: scale)
            wobblyView.isHidden = true
            self.containerView.addSubview(wobblyView)

            self.wobblyViews.append(wobblyView)
        }

        let wobblyView = BeachesWobblyView(frame: self.view.bounds, tintColor: .black, singleImage: false)
        self.containerView.addSubview(wobblyView)
        self.wobblyView = wobblyView
        
        let textView = BeachesTextView(frame: self.view.bounds)
        self.containerView.addSubview(textView)
        self.textView = textView
        
        let scroller = UILabel(frame: CGRect.zero)
        scroller.text = "Hey there! The last invitation I made didn't have a scroller so this one has to have one, right? Anyway uh I don't have that much to say. Greetings to all Jumalauta members present at the Skeneklubi Annual Meeting 2019, and also greetings to everyone who's coming to either Beaches Leave, Jumalauta 19 Years (aka JumaCon), or both! As you may already have noticed, this whole thing is on a loop, so feel free to quit any time. This whole thing was done in a few evenings the same week as the party. Most of it's recycled from older demos, which comes as a huge surprise I'm sure. I hope the scroller is readable. Anyway let's drink some beers and have fun. Have a good summer!"
        scroller.font = UIFont(name: "Futura-Medium", size: 36)
        scroller.backgroundColor = .clear
        scroller.textColor = .black
        scroller.shadowColor = .white
        scroller.shadowOffset = CGSize(width: 1, height: 1)
        scroller.sizeToFit()
        self.containerView.addSubview(scroller)
        
        scroller.frame = CGRect(
            x: self.view.bounds.size.width,
            y: self.view.bounds.size.height - scroller.bounds.size.height - 10,
            width: scroller.bounds.size.width,
            height: scroller.bounds.size.height
        )
        
        self.scroller = scroller
        
        self.startButton.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
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
        
        self.textTimer?.invalidate()
        self.textTimer = nil
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
        
        self.containerView.isHidden = false
        
        scheduleEvents()
    }
    
    private func scheduleEvents() {
        let bpm = 120.0
        let bar = (120.0 / bpm)
        let tick = bar / 16.0
        let introStart = 4.0

        perform(#selector(startTransition), with: nil, afterDelay: 0)
        perform(#selector(introEvent), with: nil, afterDelay: introStart)
        perform(#selector(introEvent), with: nil, afterDelay: introStart + (tick * 6.0))
        perform(#selector(introEvent), with: nil, afterDelay: introStart + (tick * 12.0))
        perform(#selector(introEvent), with: nil, afterDelay: introStart + (tick * 16.0))
        perform(#selector(introEvent), with: nil, afterDelay: introStart + (tick * 28.0))
        perform(#selector(introEvent), with: nil, afterDelay: introStart + (tick * 30.0))
        perform(#selector(introEvent), with: nil, afterDelay: introStart + (tick * 32.0))
        perform(#selector(introEvent), with: nil, afterDelay: introStart + (tick * 38.0))
        perform(#selector(introEvent), with: nil, afterDelay: introStart + (tick * 44.0))
        perform(#selector(introEvent), with: nil, afterDelay: introStart + (tick * 48.0))
        perform(#selector(introEvent), with: nil, afterDelay: introStart + (tick * 52.0))
        perform(#selector(introEvent), with: nil, afterDelay: introStart + (tick * 60.0))
        perform(#selector(startAnimation), with: nil, afterDelay: 8)
        perform(#selector(startShowingText), with: nil, afterDelay: 16)
        perform(#selector(startScroller), with: nil, afterDelay: 32)
        perform(#selector(moreBounce), with: nil, afterDelay: 56)
    }
    
    @objc private func startTransition() {
        UIView.animate(withDuration: 4, delay: 0, options: [.curveEaseInOut], animations: {
            self.bg?.bounds.size.width = self.view.bounds.size.width
            self.bg?.frame.origin.x = 0
            self.bg?.backgroundColor = .white
        }, completion: nil)
    }
    
    @objc private func introEvent() {
        self.wobblyView?.showImage(index: self.introPosition)
        
        if self.introPosition == 11 {
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseIn], animations: {
                self.wobblyView?.transform = CGAffineTransform.identity.scaledBy(x: 3, y: 3)
            })
        }
        
        self.introPosition += 1
    }
    
    @objc private func startAnimation() {
        self.wobblyView?.isHidden = true
        
        for view in self.wobblyViews {
            view.isHidden = false
            view.animate()
        }
    }
    
    @objc private func startShowingText() {
        self.textView?.showNextImage()

        self.textTimer = Timer.scheduledTimer(withTimeInterval: 8, repeats: true, block: { timer in
            self.textView?.showNextImage()
        })
    }
    
    @objc private func startScroller() {
        guard let scroller = self.scroller else { return }
        
        UIView.animate(withDuration: 60, delay: 0, options: [UIView.AnimationOptions.repeat, UIView.AnimationOptions.curveLinear], animations: {
            scroller.frame = CGRect(
                x: -scroller.bounds.size.width,
                y: scroller.frame.origin.y,
                width: scroller.bounds.size.width,
                height: scroller.bounds.size.height
            )
        })
    }
    
    @objc private func moreBounce() {
        for (index, view) in self.wobblyViews.enumerated() {
            Timer.scheduledTimer(withTimeInterval: Double(index) * 0.05, repeats: false, block: { timer in
                view.moreBounce()
            })
        }
    }
}
