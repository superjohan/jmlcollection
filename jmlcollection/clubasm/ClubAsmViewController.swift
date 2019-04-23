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

class ClubAsmViewController: UIViewController {
    let autostart = false
    
    let audioPlayer: AVAudioPlayer
    let startButton: UIButton
    let qtFoolingBgView: UIView = UIView.init(frame: CGRect.zero)
    
    var position = 0
    var part1position = 0
    
    let creditView = ClubAsmCreditView(frame: .zero)
    
    let logoView = UIView(frame: .zero)
    var logoViews = [ClubAsmActions]()
    
    let part1view = UIView(frame: .zero)
    var part1views = [ClubAsmActions]()
    
    let part2view = ClubAsmAssemblyView(frame: .zero)
    
    let part3view = UIView(frame: .zero)
    var part3views = [ClubAsmActions]()
    
    var currentView: ClubAsmActions?
    
    // MARK: - UIViewController
    
    init() {
        if let trackUrl = Bundle.main.url(forResource: "clubasmsoundtrack", withExtension: "m4a") {
            guard let audioPlayer = try? AVAudioPlayer(contentsOf: trackUrl) else {
                abort()
            }
            
            self.audioPlayer = audioPlayer
        } else {
            abort()
        }
        
        let startButtonText =
            "\"club asm\"\n" +
                "by dekadence\n" +
                "\n" +
                "programming, music, and design by ricky martin\n" +
                "shader programming by waffle and britelite\n" +
                "3d by spiikki\n" +
                "\n" +
                "special thanks to rimina and myy for invaluable help\n" +
                "\n" +
                "presented at revision 2019\n" +
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
        
        self.view.addSubview(self.creditView)
        self.view.addSubview(self.logoView)
        self.view.addSubview(self.part1view)
        self.view.addSubview(self.part2view)
        self.view.addSubview(self.part3view)
        
        if !self.autostart {
            self.view.addSubview(self.startButton)
        }
        
        self.blackView.backgroundColor = .black
        self.view.addSubview(self.blackView)
    }
    
    private let blackView = UIView(frame: .zero)
    
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
        
        let referenceSize = CGSize(width: 812, height: 375)
        let referenceRatio = referenceSize.width / referenceSize.height
        let screenSize = self.view.bounds.size
        let screenRatio = screenSize.width / screenSize.height
        self.view.bounds.size = referenceSize
        self.view.clipsToBounds = true
        
        if screenRatio <= referenceRatio {
            let ratio = screenSize.width / referenceSize.width
            self.view.transform = CGAffineTransform.identity.scaledBy(x: ratio, y: ratio)
        } else if screenRatio > referenceRatio {
            let ratio = screenSize.height / referenceSize.height
            self.view.transform = CGAffineTransform.identity.scaledBy(x: ratio, y: ratio)
        }
        
        // hack hack hack
        self.blackView.frame = CGRect(x: 0, y: self.view.bounds.size.height, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        
        self.qtFoolingBgView.frame = CGRect(
            x: (self.view.bounds.size.width / 2) - 1,
            y: (self.view.bounds.size.height / 2) - 1,
            width: 2,
            height: 2
        )

        self.creditView.frame = self.view.bounds
        self.creditView.isHidden = true
        
        self.logoView.frame = self.view.bounds
        self.logoView.isHidden = true
        
        let frame = self.view.bounds
        
        self.logoViews.append(ClubAsmLogo1View(frame: frame))
        self.logoViews.append(ClubAsmLogo2View(frame: frame))
        self.logoViews.append(ClubAsmLogo3View(frame: frame))
        self.logoViews.append(ClubAsmMacView(frame: frame))
        
        for view in self.logoViews {
            self.logoView.addSubview(view)
            view.isHidden = true
        }
        
        self.part1view.frame = self.view.bounds
        self.part1view.isHidden = true

        self.part2view.frame = self.view.bounds
        self.part2view.isHidden = true
        self.part2view.setupShaders()

        self.part1views.append(ClubAsmGlobalView(frame: frame))
        self.part1views.append(ClubAsmLocalView(frame: frame))
        self.part1views.append(ClubAsmLegendsView(frame: frame))
        self.part1views.append(ClubAsmContendersView(frame: frame))
        self.part1views.append(ClubAsmFriendsView(frame: frame))
        self.part1views.append(ClubAsmRivalsView(frame: frame))
        self.part1views.append(ClubAsmCompetitionsView(frame: frame))
        self.part1views.append(ClubAsmGamingView(frame: frame))
        self.part1views.append(ClubAsmLearnView(frame: frame))
        self.part1views.append(ClubAsmRelaxView(frame: frame))
        self.part1views.append(ClubAsmVictoryView(frame: frame))
        self.part1views.append(ClubAsmDefeatView(frame: frame))

        for view in self.part1views {
            self.part1view.addSubview(view)
            view.isHidden = true
        }

        self.part3view.frame = self.view.bounds
        self.part3view.isHidden = true
        
        self.part3views.append(ClubAsmDemoIntroView(frame: frame))
        self.part3views.append(ClubAsmCompoCircleView(frame: frame))
        self.part3views.append(ClubAsmCompoSquaresView(frame: frame))
        self.part3views.append(ClubAsmCompoCirclesView(frame: frame))
        self.part3views.append(ClubAsmEndView(frame: frame))

        for view in self.part3views {
            self.part3view.addSubview(view)
            view.isHidden = true
        }
        
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
//        self.sceneView.isHidden = false
        
        self.audioPlayer.play()
        
        scheduleEvents()
    }
    
    private func scheduleEvents() {
        let bar = ClubAsmConstants.barLength
        let tick = ClubAsmConstants.tickLength

        var position = 0
        
        for _ in 0...ClubAsmPositions.end {
            perform(#selector(kick1), with: nil, afterDelay: bar * Double(position))
            perform(#selector(kick2), with: nil, afterDelay: bar * Double(position) + tick)
            perform(#selector(kick3), with: nil, afterDelay: bar * Double(position) + (tick * 2.0))
            perform(#selector(kick4), with: nil, afterDelay: bar * Double(position) + (tick * 3.0))
            perform(#selector(clap), with: nil, afterDelay: bar * Double(position) + (tick * 4.0))
            
            position += 1
        }
    }
    
    @objc private func kick1() {
        selectCurrentView()

        self.position += 1
        
        self.currentView?.action1()
    }

    @objc private func kick2() {
        self.currentView?.action2()
    }

    @objc private func kick3() {
        self.currentView?.action3()
    }

    @objc private func kick4() {
        self.currentView?.action4()
    }

    @objc private func clap() {
        self.currentView?.action5()
    }

    private func selectCurrentView() {
        let currentView = self.currentView

        /*
        // for testing a specific view
        if self.position == 0 {
            self.part3view.isHidden = false
            self.currentView = self.part3views[4]
        }
*/
        
        if self.position == ClubAsmPositions.start {
            self.creditView.isHidden = false
            self.currentView = self.creditView
        }
        
        if self.position == ClubAsmPositions.beatNoBasslineStart {
            self.creditView.isHidden = true
            self.logoView.isHidden = false
            self.currentView = self.logoViews[0]
        }

        if self.position == ClubAsmPositions.beatNoBasslineStart + 1 {
            self.currentView = self.logoViews[1]
        }

        if self.position == ClubAsmPositions.beatNoBasslineStart + 2 {
            self.currentView = self.logoViews[2]
        }

        if self.position == ClubAsmPositions.beatNoBasslineStart + 3 {
            self.currentView = self.logoViews[3]
        }

        if self.position >= ClubAsmPositions.beatBasslineStart && self.position < ClubAsmPositions.raveStart {
            self.logoView.isHidden = true
            
            switch self.part1position {
            case 0:
                self.part1view.isHidden = false
                self.currentView = self.part1views[0]
            case 1:
                self.currentView = self.part1views[1]
            case 2:
                self.currentView = self.part1views[2]
            case 3:
                self.currentView = self.part1views[3]
            case 4, 5:
                self.currentView = self.part1views[4]
            case 6, 7:
                self.currentView = self.part1views[5]
            case 8:
                self.currentView = self.part1views[6]
            case 9:
                self.currentView = self.part1views[7]
            case 10:
                self.currentView = self.part1views[8]
            case 11:
                self.currentView = self.part1views[9]
            case 12, 13:
                self.currentView = self.part1views[10]
            case 14, 15:
                self.currentView = self.part1views[11]
            default:
                abort()
            }
            
            self.part1position += 1
        }
        
        if self.position == ClubAsmPositions.raveStart {
            self.part1view.isHidden = true
            self.currentView = self.part2view
        }
        
        if self.position == ClubAsmPositions.beatBassline2Start {
            self.part3view.isHidden = false
            self.currentView = self.part3views[0]
        }
        
        if self.position == ClubAsmPositions.beatBassline2Start + 4 {
            self.currentView = self.part3views[1]
        }

        if self.position == ClubAsmPositions.beatBassline2Start + 8 {
            self.currentView = self.part3views[2]
        }

        if self.position == ClubAsmPositions.beatBassline2Start + 12 {
            self.currentView = self.part3views[3]
        }

        if self.position == ClubAsmPositions.beatBassline2NoKick {
            self.currentView = self.part3views[4]
        }

        if currentView !== self.currentView {
            currentView?.isHidden = true
            self.currentView?.isHidden = false
        }
    }
}
