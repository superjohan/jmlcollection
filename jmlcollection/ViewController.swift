//
//  ViewController.swift
//  jmlcollection
//
//  Copyright 2018 Johan Halin.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit

let TutorialShownKey = "tutorialShownKey";

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var demos: [Demo] = [
        Demo(name: "Special Disco Version", group: "Jumalauta", year: "2020", requirements: nil, viewController: { return SpecialDiscoViewController() }, htmlFilename: nil),
        Demo(name: "It's More Fun To Consume", group: "Dekadence", year: "2019", requirements: nil, viewController: { return ConsumeViewController() }, htmlFilename: nil),
        Demo(name: "Bad Kerning", group: "Dekadence", year: "2019", requirements: nil, viewController: { return BadKerningViewController() }, htmlFilename: nil),
        Demo(name: "Beaches Leave", group: "Jumalauta", year: "2019", requirements: nil, viewController: { return BeachesViewController() }, htmlFilename: nil),
        Demo(name: "CLUB ASM", group: "Dekadence", year: "2019", requirements: nil, viewController: { return ClubAsmViewController() }, htmlFilename: nil),
        Demo(name: "White Ale In Benin", group: "Matt Current", year: "2019", requirements: nil, viewController: nil, htmlFilename: "white_ale_in_benin.html"),
        Demo(name: "technofundamental (2019 edition)", group: "CRTC + RiFT", year: "2019", requirements: .metal_v4, viewController: { return TechnofundamentalViewController() }, htmlFilename: nil),
        Demo(name: "Techno-Utopian Edict", group: "Jumalauta", year: "2019", requirements: nil, viewController: nil, htmlFilename: "techno-utopian_edict.html"),
        Demo(name: "Modern Pictures", group: "Dekadence", year: "2019", requirements: nil, viewController: { return ModernPicturesViewController() }, htmlFilename: nil),
        Demo(name: "Literal Acid Phase", group: "Dekadence", year: "2018", requirements: nil, viewController: { return AcidPhaseViewController() }, htmlFilename: nil),
        Demo(name: "Finlandstidsmaskinen", group: "Jumalauta", year: "2018", requirements: nil, viewController: nil, htmlFilename: "finlandstidsmaskinen.html"),
        Demo(name: "Basilisk", group: "Jumalauta", year: "2018", requirements: nil, viewController: nil, htmlFilename: "basilisk.html"),
        Demo(name: "Night Drive", group: "Jumalauta", year: "2018", requirements: nil, viewController: { return NightDriveViewController() }, htmlFilename: nil),
        Demo(name: "Rock For Metal", group: "Jumalauta", year: "2018", requirements: nil, viewController: nil, htmlFilename: "rock_for_metal.html"),
        Demo(name: "Understand", group: "Jumalauta", year: "2018", requirements: nil, viewController: { return UnderstandViewController() }, htmlFilename: nil),
        Demo(name: "Version: Labor", group: "Dekadence", year: "2018", requirements: nil, viewController: { return VersionViewController() }, htmlFilename: nil),
        Demo(name: "Production", group: "Dekadence", year: "2018", requirements: nil, viewController: { return ProductionViewController() }, htmlFilename: nil),
        Demo(name: "Finlandsfärjan '18", group: "Jumalauta", year: "2018", requirements: nil, viewController: { return FfViewController() }, htmlFilename: nil),
        Demo(name: "α", group: "Jumalauta", year: "2017", requirements: nil, viewController: nil, htmlFilename: "jmlalpha.html"),
        Demo(name: "Worlds", group: "Dekadence", year: "2017", requirements: nil, viewController: { return WorldsViewController() }, htmlFilename: nil),
        Demo(name: "#jumalauta", group: "Jumalauta", year: "2017", requirements: nil, viewController: nil, htmlFilename: "jml_irc_ad.html"),
        Demo(name: "Honey And Whore", group: "Jumalauta", year: "2017", requirements: nil, viewController: nil, htmlFilename: "jml17.html"),
        Demo(name: "Δ", group: "Jumalauta", year: "2017", requirements: nil, viewController: nil, htmlFilename: "jmldeltaindex.html"),
        Demo(name: "Thinkpiece", group: "Dekadence", year: "2017", requirements: nil, viewController: nil, htmlFilename: "thinkpiece.html"),
        Demo(name: "Party Hard 2", group: "Jumalauta", year: "2016", requirements: nil, viewController: nil, htmlFilename: "jmlpartyhard2index.html"),
        Demo(name: "thoron is not the answer to every quiplash question", group: "Jumalauta", year: "2016", requirements: nil, viewController: nil, htmlFilename: "halfhourshit.html"),
        Demo(name: "Destroy All Humans", group: "Jumalauta", year: "2015", requirements: nil, viewController: nil, htmlFilename: "jmldstr.html"),
    ]

    let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
        // Filter out any demos that won't work on this hardware
        prefilterDemoList()
        
        self.tableView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        self.tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.backgroundColor = UIColor.yellow
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.view.addSubview(self.tableView)
        
        let padding = 20
        let width = 480
        let height = 220
        
        let headerLabel = UILabel(frame: CGRect(x: padding, y: padding, width: width - (padding * 2), height: height - (padding * 2)))
        headerLabel.font = UIFont.init(name: "Superclarendon-Black", size: 48)
        headerLabel.textColor = UIColor.white
        headerLabel.backgroundColor = UIColor.black
        headerLabel.text = "The Jumalauta Collection"
        headerLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        headerLabel.numberOfLines = 0
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        headerView.backgroundColor = UIColor.yellow
        headerView.addSubview(headerLabel)
        
        self.tableView.tableHeaderView = headerView
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setShowingDemo(false)
    }
	
    /// Checks all the demos in the list, and removes any that don't meet hardware requirements
    func prefilterDemoList() {
        let metalDevice = MTLCreateSystemDefaultDevice()
        var supportedDemos = [Demo]()
        
        for demo in demos {
            if let reqs = demo.requirements {
                if reqs.contains(.metal_v4) {
                    // Requires a metal device support v4+ feature set and iOS 12
                    if #available(iOS 12.0, *) {
                        if metalDevice == nil {
                            // No metal capable hardware at all
                            continue
                        }
                        if !metalDevice!.supportsFeatureSet(.iOS_GPUFamily4_v2) {
                            // GPU is too old to run this
                            continue
                        }
                    } else {
                        // Device is too old, skip this demo
                        continue
                    }
                }
            }
            supportedDemos.append(demo)
        }
        demos = supportedDemos
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.demos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let demo = self.demos[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier") ?? UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cellIdentifier")
        
        cell.textLabel?.text = demo.name
        cell.textLabel?.font = UIFont.init(name: "Superclarendon-BoldItalic", size: 36)
        
        cell.detailTextLabel?.text = " \(demo.group), \(demo.year)"
        cell.detailTextLabel?.font = UIFont.init(name: "Superclarendon-Regular", size: 24)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let demo = self.demos[indexPath.row]

        let tutorialShown = UserDefaults.standard.bool(forKey: TutorialShownKey)
        
        if !tutorialShown {
            UserDefaults.standard.set(true, forKey: TutorialShownKey)
            
            let tutorialView = TutorialView(frame: self.view.bounds, completion: { view in
                view.removeFromSuperview()
                self.showDemo(demo)
            })
            self.view.addSubview(tutorialView)
        } else {
            self.showDemo(demo)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    // MARK: - Private
    
    private func showDemo(_ demo: Demo) {
        setShowingDemo(true)
        
        if let viewController = demo.viewController?() {
            self.navigationController?.pushViewController(viewController, animated: true)
        } else if let htmlFilename = demo.htmlFilename {
            let webViewController = WebViewController(htmlFilename: htmlFilename)
            self.navigationController?.pushViewController(webViewController, animated: true)
        }
    }
    
    private func setShowingDemo(_ isShowingDemo: Bool) {
        if let window = self.view.window as? JmlCollectionWindow {
            window.isShowingDemo = isShowingDemo
        }
    }
}
