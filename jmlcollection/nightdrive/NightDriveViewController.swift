//
//  ViewController.swift
//  finlandsfarjan
//
//  Created by Johan Halin on 03/03/2018.
//  Copyright © 2018 Jumalauta. All rights reserved.
//

import UIKit
import SceneKit
import AVFoundation

class NightDriveViewController: UIViewController {
    let audioPlayer: AVAudioPlayer
    let sceneView = SCNView()
    let camera = SCNNode()
    let startButton: UIButton
    let logo1View = UIImageView(image: UIImage(named: "ndjml"))
    let logo2View = UIImageView(image: UIImage(named: "ndtitle"))
    let scroller = UILabel(frame: CGRect.zero)
    let qtFoolingBgView: UIView = UIView.init(frame: CGRect.zero)

    var sunNode: SCNNode?
    var groundNode: SCNNode?
    var waterNode: SCNNode?
    var boatNode: SCNNode?
    var wheel1Node: SCNNode?
    var wheel2Node: SCNNode?
    var streetlightPoleNode: SCNNode?
    var streetlightLightNode: SCNNode?
    var streetlight: SCNNode?

    init() {
        if let trackUrl = Bundle.main.url(forResource: "synthfarjn", withExtension: "mp3") {
            guard let audioPlayer = try? AVAudioPlayer(contentsOf: trackUrl) else {
                abort()
            }
            
            self.audioPlayer = audioPlayer
        } else {
            abort()
        }
        
        let camera = SCNCamera()
        camera.zFar = 600
        camera.vignettingIntensity = 1
        camera.vignettingPower = 1
        camera.colorFringeStrength = 3
        camera.bloomIntensity = 10
        camera.bloomBlurRadius = 40
        camera.bloomThreshold = 0.1
        self.camera.camera = camera // lol

        let startButtonText =
            "\"night drive\"\n" +
                "by jumalauta\n" +
                "\n" +
                "programming and music by ylvaes\n" +
                "3d by tohtori kannabispiikki\n" +
                "\n" +
                "presented at jml18v postmortem sauna 2018\n" +
                "\n" +
        "tap anywhere to start"
        self.startButton = UIButton.init(type: UIButton.ButtonType.custom)
        self.startButton.setTitle(startButtonText, for: UIControl.State.normal)
        self.startButton.titleLabel?.numberOfLines = 0
        self.startButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.startButton.backgroundColor = UIColor.black

        self.logo1View.isHidden = true
        self.logo2View.isHidden = true
        
        self.qtFoolingBgView.backgroundColor = UIColor(white: 0.1, alpha: 1.0)

        super.init(nibName: nil, bundle: nil)

        self.startButton.addTarget(self, action: #selector(startButtonTouched), for: UIControl.Event.touchUpInside)

        self.view.addSubview(self.qtFoolingBgView)
        self.view.addSubview(self.sceneView)
        self.view.addSubview(self.logo1View)
        self.view.addSubview(self.logo2View)
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
        
        self.sceneView.scene = createScene()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.startButton.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)

        self.logo1View.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        self.logo2View.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)

        self.sceneView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        self.sceneView.isPlaying = true
        self.sceneView.isHidden = true

        self.qtFoolingBgView.frame = CGRect(
            x: (self.view.bounds.size.width / 2) - 1,
            y: (self.view.bounds.size.height / 2) - 1,
            width: 2,
            height: 2
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.scroller.text = "Welcome to Jumalauta 18 Years party 24.-26.8.2018 at Hauho in (as it turned out) quite rainy Finland! We have cabins and good times! If you're in Sweden, take the dang titular finlandsfärjan/time machine!! Greets to everyone at jML18v Postmortem Sauna 2018 and everyone who's been at the Jumalauta party before! See you there this year and next year! This remake was made by Ylvaes and Tohtori Kannabispiikki. The 2006 original was made by Anteeksi, Maitotuote, Saksan Perussanasto, and Ylvaes. Greets to everyone who has made incredible remakes this year, and special thanks to Haluttu etc for making a revolutionary new tool for even more Färjan creation!!"
        self.scroller.font = UIFont.init(name: "AvenirNextCondensed-HeavyItalic", size: 36)
        self.scroller.backgroundColor = .clear
        self.scroller.textColor = UIColor(white: 1.0, alpha: 0.8)
        self.scroller.sizeToFit()
        self.scroller.frame = CGRect(x: self.view.bounds.size.width, y: self.view.bounds.size.height - self.scroller.bounds.size.height - 10, width: self.scroller.bounds.size.width, height: self.scroller.bounds.size.height)
        self.view.addSubview(self.scroller)
    }
        
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.audioPlayer.stop()
    }
    
    @objc private func startButtonTouched(button: UIButton) {
        self.startButton.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 4, animations: {
            self.startButton.alpha = 0
        }, completion: { _ in
            self.start()
        })
    }

    fileprivate func start() {
        scheduleEvents()
        
        self.audioPlayer.play()
    }

    fileprivate func scheduleEvents() {
        perform(#selector(showLogo), with: NSNumber(booleanLiteral: true), afterDelay: 5.3333)
        perform(#selector(showLogo), with: NSNumber(booleanLiteral: false), afterDelay: 9.333275)
        perform(#selector(showLogo2), with: NSNumber(booleanLiteral: true), afterDelay: 10.6666)
        perform(#selector(showLogo2), with: NSNumber(booleanLiteral: false), afterDelay: 14.666575)
        perform(#selector(showSky), with: nil, afterDelay: 16)
        perform(#selector(showRestOfScene), with: nil, afterDelay: 21.3333)
        perform(#selector(showBoat), with: nil, afterDelay: 26.6666)
        perform(#selector(rotateBoat), with: nil, afterDelay: 66.6666)
        perform(#selector(showLogo2), with: NSNumber(booleanLiteral: true), afterDelay: 96)
        perform(#selector(end), with: nil, afterDelay: 101.3333)
    }
    
    @objc private func showLogo(show: NSNumber) {
        self.logo1View.isHidden = !show.boolValue
    }

    @objc private func showLogo2(show: NSNumber) {
        self.logo2View.isHidden = !show.boolValue
    }

    @objc private func showSky() {
        self.sceneView.isHidden = false
    }

    @objc private func showRestOfScene() {
        self.sunNode?.isHidden = false
        self.groundNode?.isHidden = false
        self.waterNode?.isHidden = false
        self.streetlightPoleNode?.isHidden = false
        self.streetlightLightNode?.isHidden = false
        self.streetlight?.isHidden = false
        
        self.sunNode?.opacity = 0
        self.groundNode?.opacity = 0
        self.waterNode?.opacity = 0
        self.streetlightPoleNode?.opacity = 0
        self.streetlightLightNode?.opacity = 0
        self.streetlight?.opacity = 0
        
        let action = SCNAction.fadeIn(duration: 5)
        self.sunNode?.runAction(action)
        self.groundNode?.runAction(action)
        self.waterNode?.runAction(action)
        self.streetlightPoleNode?.runAction(action)
        self.streetlightLightNode?.runAction(action)
        self.streetlight?.runAction(action)
    }

    @objc private func showBoat() {
        let action = SCNAction.moveBy(x: 100, y: 0, z: 0, duration: 3)
        action.timingMode = .easeOut
        self.boatNode?.runAction(action)
        self.wheel1Node?.runAction(action)
        self.wheel2Node?.runAction(action)

        perform(#selector(startBoatAnimation), with: nil, afterDelay: 3)

        UIView.animate(withDuration: 70, delay: 0, options: [UIView.AnimationOptions.curveLinear], animations: {
            self.scroller.frame = CGRect(x: -self.scroller.bounds.size.width, y: self.view.bounds.size.height - self.scroller.bounds.size.height - 15, width: self.scroller.bounds.size.width, height: self.scroller.bounds.size.height)
        })
    }
    
    @objc private func startBoatAnimation() {
        addRotateMoveActions(node: self.boatNode!, moveBy: SCNVector3Make(10, 0, 0), moveDuration: 3, rotateBy: SCNVector3Make(0, 0, 0), rotateDuration: 3)
        addRotateMoveActions(node: self.wheel1Node!, moveBy: SCNVector3Make(10, 0, 0), moveDuration: 3, rotateBy: SCNVector3Make(0, 0, 0), rotateDuration: 3)
        addRotateMoveActions(node: self.wheel2Node!, moveBy: SCNVector3Make(10, 0, 0), moveDuration: 3, rotateBy: SCNVector3Make(0, 0, 0), rotateDuration: 3)
    }
    
    @objc private func rotateBoat() {
        addRotateMoveActions(node: self.boatNode!, moveBy: SCNVector3Make(0, 0, 0), moveDuration: 3, rotateBy: SCNVector3Make(0, 0, 1.5), rotateDuration: 30)
    }
    
    @objc private func end() {
        self.sceneView.isHidden = true
        self.logo1View.isHidden = true
        self.logo2View.isHidden = true
        self.scroller.isHidden = true
    }
    
    fileprivate func createScene() -> SCNScene {
        let scene = SCNScene()
        scene.background.contents = UIImage(named: "ndbackground")
        
        self.camera.position = SCNVector3Make(0, 0, 20)
        
        scene.rootNode.addChildNode(self.camera)
        
        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        omniLightNode.light?.type = SCNLight.LightType.omni
        omniLightNode.light?.color = UIColor(white: 0.3, alpha: 1.0)
        omniLightNode.position = SCNVector3Make(10, 12, 0)
        scene.rootNode.addChildNode(omniLightNode)

        let sun = SCNSphere(radius: 7)
        sun.firstMaterial?.diffuse.contents = UIColor.white
        let sunNode = SCNNode(geometry: sun)
        sunNode.position = SCNVector3Make(16, 12, -10)
        scene.rootNode.addChildNode(sunNode)
        sunNode.isHidden = true
        self.sunNode = sunNode
        
        let ground = SCNBox(width: 100, height: 50, length: 20, chamferRadius: 10)
        ground.firstMaterial?.diffuse.contents = UIColor.cyan
        let groundNode = SCNNode(geometry: ground)
        groundNode.position = SCNVector3Make(0, -22, -15)
        scene.rootNode.addChildNode(groundNode)
        groundNode.isHidden = true
        self.groundNode = groundNode
        
        let water = SCNBox(width: 100, height: 50, length: 10, chamferRadius: 10)
        water.firstMaterial?.diffuse.contents = UIColor.purple
        let waterNode = SCNNode(geometry: water)
        waterNode.position = SCNVector3Make(0, -28, 0)
        scene.rootNode.addChildNode(waterNode)
        waterNode.isHidden = true
        self.waterNode = waterNode
        
        if let filePath = Bundle.main.path(forResource: "paatti", ofType: "dae", inDirectory: "") {
            let referenceURL = URL(fileURLWithPath: filePath)
            let referenceNode = SCNReferenceNode(url: referenceURL)
            referenceNode?.load()
            
            referenceNode?.runAction(
                SCNAction.rotateBy(
                    x: 3.14159 * 1.5,
                    y: 0,
                    z: 0,
                    duration: 0
                )
            )

            let boatImage: UIImage? = UIImage(named: "paatti")
            let childNodes = referenceNode?.childNodes
            for childNode in childNodes! {
                childNode.geometry?.firstMaterial = SCNMaterial()
                childNode.geometry?.firstMaterial?.diffuse.contents = boatImage
            }
            
            referenceNode?.position = SCNVector3Make(-110, -2, 0)
            
            let moveAction = SCNAction.moveBy(x: 0, y: -2, z: 0, duration: 2)
            moveAction.timingMode = SCNActionTimingMode.easeInEaseOut
            
            scene.rootNode.addChildNode(referenceNode!)
            
            self.boatNode = referenceNode
            
            let wheel1 = SCNSphere(radius: 1)
            wheel1.firstMaterial?.diffuse.contents = UIColor.darkGray
            let wheel1node = SCNNode(geometry: wheel1)
            wheel1node.position = SCNVector3Make(-114, -2, 0)
            scene.rootNode.addChildNode(wheel1node)
            self.wheel1Node = wheel1node
            
            let wheel2 = SCNSphere(radius: 1)
            wheel2.firstMaterial?.diffuse.contents = UIColor.darkGray
            let wheel2node = SCNNode(geometry: wheel1)
            wheel2node.position = SCNVector3Make(-106, -2, 0)
            scene.rootNode.addChildNode(wheel2node)
            self.wheel2Node = wheel2node
        }
        
        let lightDuration = 5.0
        
        let streetlightPole = SCNBox(width: 0.5, height: 20, length: 0.5, chamferRadius: 0.5)
        streetlightPole.firstMaterial?.diffuse.contents = UIColor.white
        let streetlightPoleNode = SCNNode(geometry: streetlightPole)
        scene.rootNode.addChildNode(streetlightPoleNode)
        let polemoveAction = SCNAction.move(to: SCNVector3Make(30, -13, 5), duration: 0)
        let polemoveAction2 = SCNAction.move(to: SCNVector3Make(-30, -13, 5), duration: lightDuration)
        streetlightPoleNode.runAction(SCNAction.repeatForever(SCNAction.sequence([polemoveAction, polemoveAction2])))
        streetlightPoleNode.isHidden = true
        self.streetlightPoleNode = streetlightPoleNode
        
        let streetlightLight = SCNSphere(radius: 1)
        streetlightLight.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
        let streetlightLightNode = SCNNode(geometry: streetlightLight)
        scene.rootNode.addChildNode(streetlightLightNode)
        let lightmoveAction = SCNAction.move(to: SCNVector3Make(30, -3, 5), duration: 0)
        let lightmoveAction2 = SCNAction.move(to: SCNVector3Make(-30, -3, 5), duration: lightDuration)
        streetlightLightNode.runAction(SCNAction.repeatForever(SCNAction.sequence([lightmoveAction, lightmoveAction2])))
        streetlightLightNode.isHidden = true
        self.streetlightLightNode = streetlightLightNode
        
        let streetlight = SCNNode()
        streetlight.light = SCNLight()
        streetlight.light?.type = SCNLight.LightType.omni
        streetlight.light?.color = UIColor(white: 1.0, alpha: 1.0)
        streetlight.light?.intensity = 4000
        scene.rootNode.addChildNode(streetlight)
        let moveAction = SCNAction.move(to: SCNVector3Make(30, -3, 3), duration: 0)
        let moveAction2 = SCNAction.move(to: SCNVector3Make(-30, -3, 3), duration: lightDuration)
        streetlight.runAction(SCNAction.repeatForever(SCNAction.sequence([moveAction, moveAction2])))
        streetlight.isHidden = true
        self.streetlight = streetlight
        
        let resetColor = SCNAction.customAction(duration: 0, action: { node, elapsedTime in
            node.light?.color = UIColor(white: 0, alpha: 0)
        })
        let fadeInAction = SCNAction.customAction(duration: lightDuration / 2.0, action: { node, elapsedTime in
            let value = elapsedTime / CGFloat(lightDuration / 2.0)
            node.light?.color = UIColor(white: value, alpha: value)
        })
        let fadeOutAction = SCNAction.customAction(duration: lightDuration / 2.0, action: { node, elapsedTime in
            let value = 1.0 - (elapsedTime / CGFloat(lightDuration / 2.0))
            node.light?.color = UIColor(white: value, alpha: value)
        })
        streetlight.runAction(SCNAction.repeatForever(SCNAction.sequence([resetColor, fadeInAction, fadeOutAction])))
        
        return scene
    }

    fileprivate func addRotateMoveActions(node: SCNNode, moveBy: SCNVector3, moveDuration: TimeInterval, rotateBy: SCNVector3, rotateDuration: TimeInterval) {
        let moveAction = SCNAction.moveBy(x: CGFloat(moveBy.x), y: CGFloat(moveBy.y), z: CGFloat(moveBy.z), duration: moveDuration)
        moveAction.timingMode = SCNActionTimingMode.easeInEaseOut
        
        let moveReverseAction = moveAction.reversed()
        let sequence = SCNAction.sequence([moveAction, moveReverseAction])
        
        node.runAction(
            SCNAction.repeatForever(
                sequence
            )
        )
        
        let rotateAction = SCNAction.rotateBy(x: CGFloat(rotateBy.x), y: CGFloat(rotateBy.y), z: CGFloat(rotateBy.z), duration: rotateDuration)
        rotateAction.timingMode = SCNActionTimingMode.easeInEaseOut
        
        let rotateReverseAction = rotateAction.reversed()
        let rotateSequence = SCNAction.sequence([rotateAction, rotateReverseAction])
        
        node.runAction(
            SCNAction.repeatForever(
                rotateSequence
            )
        )
    }
}

