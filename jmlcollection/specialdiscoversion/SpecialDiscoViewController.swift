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

typealias CurrentModifier = (modifier: Modifier, value1: CGFloat, value2: CGFloat, value3: CGFloat)
typealias Background = (config: BackgroundView.Configuration, position: BackgroundView.Position)

class SpecialDiscoViewController: UIViewController {
    let autostart = false
    
    let audioPlayer: AVAudioPlayer

    let startButton: UIButton
    let qtFoolingBgView: UIView = UIView.init(frame: CGRect.zero)
    let contentView = UIView()
    let yellow = UIColor(red: 247.0 / 255.0, green: 237.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
    let modifiers: [Modifier]
    let labelContainer = UIView()
    let backgroundView = BackgroundView(frame: .zero)
    let maskView = BackgroundView(frame: .zero)
    let foregroundView = BackgroundView(frame: .zero)
    let endViews: [EndView]
    let backgrounds: [Background]
    let endLabel = UILabel()

    var wordLabels = [UILabel]()

    var currentBar = 0
    var currentTickInBar = 0
    var currentWord: (word: String, index: Int) = ("", 0)
    var currentWordIndex = 1
    var currentModifier: CurrentModifier? = nil
    var currentModifierIndex = 0
    var modifierStartIndex = -1
    var wordIndex = [0, 0, 0]
    var backgroundIndex = 0

    // MARK: - UIViewController
    
    init() {
        if let trackUrl = Bundle.main.url(forResource: "specialdiscoversion", withExtension: "m4a") {
            guard let audioPlayer = try? AVAudioPlayer(contentsOf: trackUrl) else {
                abort()
            }
            
            self.audioPlayer = audioPlayer
        } else {
            abort()
        }

        let startButtonText =
            "\"special disco version\"\n" +
                "by jumalauta\n" +
                "\n" +
                "programming and music by ylvaes\n" +
                "\n" +
                "presented at jumalauta 20 years party\n" +
                "\n" +
        "tap anywhere to start"
        self.startButton = UIButton.init(type: UIButton.ButtonType.custom)
        self.startButton.setTitle(startButtonText, for: UIControl.State.normal)
        self.startButton.titleLabel?.numberOfLines = 0
        self.startButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.startButton.backgroundColor = UIColor.black

        self.modifiers = generateModifierList()

        self.endViews = [
            EndView(frame: .zero),
            EndView(frame: .zero),
            EndView(frame: .zero)
        ]

        var backgrounds = [Background]()

        let backgroundOrder: [BackgroundView.Configuration] = [
            .verticalRandom,
            .verticalLinear,
            .horizontalRandom,
            .horizontalLinear,
            .angledRandom,
            .angledLinear
        ].shuffled()
        var backgroundOrderIndex = 0

        let backgroundViewOrder: [BackgroundView.Position] = [
            .back,
            .mask,
            .fore,
        ].shuffled()
        var backgroundViewOrderIndex = 0

        for _ in 0...30 {
            backgrounds.append((
                config: backgroundOrder[backgroundOrderIndex],
                position: backgroundViewOrder[backgroundViewOrderIndex]
            ))

            backgroundOrderIndex += 1
            if backgroundOrderIndex >= backgroundOrder.count {
                backgroundOrderIndex = 0
            }

            backgroundViewOrderIndex += 1
            if backgroundViewOrderIndex >= backgroundViewOrder.count {
                backgroundViewOrderIndex = 0
            }
        }

        self.backgrounds = backgrounds

        super.init(nibName: nil, bundle: nil)
        
        self.startButton.addTarget(self, action: #selector(startButtonTouched), for: UIControl.Event.touchUpInside)
        
        self.view.backgroundColor = .black

        self.qtFoolingBgView.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        
        // barely visible tiny view for fooling Quicktime player. completely black images are ignored by QT
        self.view.addSubview(self.qtFoolingBgView)

        self.contentView.backgroundColor = self.yellow
        self.contentView.isHidden = true
        self.view.addSubview(self.contentView)

        self.backgroundView.isHidden = true
        self.backgroundView.layer.zPosition = -1000
        self.contentView.addSubview(self.backgroundView)

        self.maskView.isHidden = true

        let labelCount = DemoDictionary.words
            .flatMap { $0 }
            .max(by: { $1.count > $0.count })!
            .count

        for i in 0..<labelCount {
            let label = UILabel()
            label.backgroundColor = .clear
            label.textColor = .black
            label.isHidden = true
            label.lineBreakMode = .byClipping
            label.layer.zPosition = CGFloat(-100 + (i * 10))
            self.labelContainer.addSubview(label)
            self.wordLabels.append(label)
        }

        self.contentView.addSubview(self.labelContainer)

        self.endLabel.font = UIFont.boldSystemFont(ofSize: 12)
        self.endLabel.backgroundColor = .clear
        self.endLabel.isHidden = true
        self.endLabel.text = "jML! 2020"
        self.endLabel.textColor = .white
        self.endLabel.sizeToFit()
        self.view.addSubview(self.endLabel)

        self.foregroundView.isHidden = true
        self.contentView.addSubview(self.foregroundView)

        for view in self.endViews {
            view.layer.zPosition = 1000
            view.isHidden = true
            self.contentView.addSubview(view)
        }

        self.wordLabels[0].isHidden = false

        self.currentWord = word(index: 0)

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

        self.contentView.frame = self.view.bounds
        self.labelContainer.frame = self.view.bounds
        self.backgroundView.frame = self.view.bounds
        self.maskView.frame = self.view.bounds
        self.foregroundView.frame = self.view.bounds

        self.startButton.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)

        setWordLabelFont()

        for view in self.endViews {
            view.frame = self.view.bounds
        }

        self.endViews[0].setup(font: self.wordLabels[0].font, text: "Special")
        self.endViews[1].setup(font: self.wordLabels[0].font, text: "Disco")
        self.endViews[2].setup(font: self.wordLabels[0].font, text: "Version")

        for label in self.wordLabels {
            positionLabel(label)
        }

        self.endLabel.frame = CGRect(
            x: self.view.bounds.midX - (self.endLabel.bounds.size.width / 2.0),
            y: self.view.bounds.midY - (self.endLabel.bounds.size.height / 2.0),
            width: self.endLabel.bounds.size.width,
            height: self.endLabel.bounds.size.height
        )
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

        self.contentView.isHidden = false

        scheduleEvents()
    }
    
    private func scheduleEvents() {
        let bars = SoundtrackStructure.length

        for bar in 0...bars {
            let barStart = Double(bar) * SoundtrackConfig.barLength

            for tick in 0..<16 {
                let currentTick = barStart + (Double(tick) * SoundtrackConfig.tickLength)

                perform(#selector(event), with: nil, afterDelay: currentTick)
            }
        }
    }

    @objc private func event() {
        self.currentTickInBar += 1

        if self.currentTickInBar >= 16 {
            self.currentTickInBar = 0
            self.currentBar += 1

            switch self.currentBar {
            case SoundtrackStructure.loudHit1:
                self.endViews[0].isHidden = false
            case SoundtrackStructure.loudHit2:
                 self.endViews[1].isHidden = false
            case SoundtrackStructure.loudHit3:
                self.endViews[2].isHidden = false
            case SoundtrackStructure.end:
                self.contentView.isHidden = true
                self.endLabel.isHidden = false
            case SoundtrackStructure.endActual:
                self.endLabel.isHidden = true
            default:
                for view in self.endViews {
                    view.isHidden = true
                }
            }

            if self.currentBar >= SoundtrackStructure.backgroundStart && self.currentBar % 2 == 1 {
                let backgroundConfig = self.backgrounds[self.backgroundIndex]

                switch backgroundConfig.position {
                case .back:
                    self.backgroundView.isHidden = false
                    self.backgroundView.animate(
                        configuration: backgroundConfig.config,
                        duration: SoundtrackConfig.barLength
                    )
                case .mask:
                    self.maskView.isHidden = false
                    self.labelContainer.mask = self.maskView
                    self.maskView.animate(
                        configuration: backgroundConfig.config,
                        duration: SoundtrackConfig.barLength
                    )
                case .fore:
                    self.foregroundView.isHidden = false
                    self.foregroundView.animate(
                        configuration: backgroundConfig.config,
                        duration: SoundtrackConfig.barLength
                    )
                }

                self.backgroundIndex += 1
            } else {
                self.backgroundView.isHidden = true
                self.labelContainer.mask = nil
                self.foregroundView.isHidden = true
            }
        }

        for view in self.endViews {
            if !view.isHidden {
                view.showTick(self.currentTickInBar, duration: SoundtrackConfig.tickLength * 4.0)
            }
        }

        for label in self.wordLabels {
            if self.currentWordIndex == 0 {
                for label in self.wordLabels {
                    label.isHidden = true
                    positionLabel(label)
                    label.transform = .identity
                    label.layer.transform = CATransform3DIdentity
                }

                self.wordLabels[0].isHidden = false
            }

            label.text = String(self.currentWord.word.prefix(self.currentWordIndex))
        }

        if let modifier = self.currentModifier {
            if self.modifierStartIndex == self.currentWord.index || self.modifierStartIndex > 2 {
                applyModifier(modifier, index: self.currentWordIndex, count: self.currentWord.word.count)
            }
        }

        self.currentWordIndex += 1

        if self.currentWordIndex > self.currentWord.word.count {
            self.currentWordIndex = 0

            let groupIndex: Int
            if self.currentWord.index == 2 {
                groupIndex = 0

                if self.currentBar >= SoundtrackStructure.modifierStart {
                    self.currentModifier = (
                        modifier: self.modifiers[self.currentModifierIndex],
                        value1: randomRange(),
                        value2: randomRange(),
                        value3: randomRange()
                    )

                    self.currentModifierIndex += 1
                    self.modifierStartIndex += 1
                }
            } else {
                groupIndex = self.currentWord.index + 1
            }

            self.currentWord = word(index: groupIndex)
        }
    }

    func positionLabel(_ label: UILabel) {
        label.text = self.currentWord.word
        label.sizeToFit()
        label.frame = CGRect(
            x: self.view.bounds.midX - (label.bounds.size.width / 2.0),
            y: self.view.bounds.midY - (label.bounds.size.height / 2.0),
            width: label.bounds.size.width,
            height: label.bounds.size.height
        )
        label.text = ""
    }
    
    func word(index: Int) -> (word: String, index: Int) {
        if self.currentBar < SoundtrackStructure.loudHit1 {
            let word = DemoDictionary.words[index][self.wordIndex[index]]

            self.wordIndex[index] += 1
            if self.wordIndex[index] >= DemoDictionary.words[index].count {
                self.wordIndex[index] = 0
            }

            return (word, index)
        } else {
            return (DemoDictionary.words[index][0], index)
        }
    }

    func applyModifier(_ modifier: CurrentModifier, index: Int, count: Int) {
        if index < 2 || modifier.modifier == .none {
            return
        }

        let correctedIndex = index - 1
        let label = self.wordLabels[correctedIndex]
        label.isHidden = false
        label.textColor = UIColor(white: CGFloat(correctedIndex) / CGFloat(count), alpha: 1.0)

        switch modifier.modifier {
        case .none:
            break
        case .modifyX:
            label.frame.origin.x += modifier.value1 * CGFloat(correctedIndex)
        case .modifyY:
            label.frame.origin.y += modifier.value1 * CGFloat(correctedIndex)
        case .modifyXModifyY:
            label.frame.origin.x += modifier.value1 * CGFloat(correctedIndex)
            label.frame.origin.y += modifier.value2 * CGFloat(correctedIndex)
        case .random:
            label.frame.origin.x += CGFloat.random(in: abs(modifier.value1)...abs(modifier.value1) * 2) * (Bool.random() ? -1 : 1)
            label.frame.origin.y += CGFloat.random(in: abs(modifier.value1)...abs(modifier.value1) * 2) * (Bool.random() ? -1 : 1)
        case .rotate2d:
            let rotation = (CGFloat.pi / 4.0) * (((modifier.value1 - modifierRange.lowerBound) / (modifierRange.upperBound - modifierRange.lowerBound)) * (CGFloat(correctedIndex) / CGFloat(count)))

            label.transform = CGAffineTransform.identity
                .translatedBy(x: CGFloat(modifier.value1 * CGFloat(correctedIndex - 1)), y: CGFloat(modifier.value2 * CGFloat(correctedIndex - 1)))
                .rotated(by: rotation)
        case .rotate3d:
            let rotation = (CGFloat.pi / 4.0) * (modifier.value1 / modifierRange.upperBound) * (CGFloat(correctedIndex) / CGFloat(count))
            let x = (modifier.value1 / modifierRange.upperBound) * (CGFloat(correctedIndex) / CGFloat(count))
            let y = (modifier.value2 / modifierRange.upperBound) * (CGFloat(correctedIndex) / CGFloat(count))
            let z = (modifier.value3 / modifierRange.upperBound) * (CGFloat(correctedIndex) / CGFloat(count))

            label.layer.transform.m34 = -0.002
            label.layer.transform = CATransform3DRotate(label.layer.transform, rotation, x, y, z)
            break
        }
    }

    func setWordLabelFont() {
        // first pass: figure out which word is the widest

        let firstPassFont = UIFont.systemFont(ofSize: 24, weight: .heavy)
        let label = UILabel(frame: .zero)
        label.font = firstPassFont

        var widestWord: (word: String, width: CGFloat)? = nil

        for wordGroup in DemoDictionary.words {
            for word in wordGroup {
                label.text = word
                label.sizeToFit()

                if let wideWord = widestWord {
                    if label.bounds.size.width > wideWord.width {
                        widestWord = (word, label.bounds.size.width)
                    }
                } else {
                    widestWord = (word, label.bounds.size.width)
                }
            }
        }

        // second pass: figure out the max width

        var maxSizeFound = false
        let maxWidth = self.view.bounds.size.width
        var fontSize = 24

        label.text = widestWord!.word

        while !maxSizeFound {
            let font = UIFont.systemFont(ofSize: CGFloat(fontSize), weight: .heavy)
            label.font = font
            label.sizeToFit()

            if label.bounds.size.width < maxWidth {
                fontSize += 1
            } else {
                fontSize -= 1
                maxSizeFound = true
            }
        }

        // done!

        for label in self.wordLabels {
            label.font = UIFont.systemFont(ofSize: CGFloat(fontSize), weight: .heavy)
        }
    }
}
