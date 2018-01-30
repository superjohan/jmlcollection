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

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let demos: [Demo] = [
        Demo(name: "Δ", group: "Jumalauta", year: "2017", viewController: nil, htmlDescription: HtmlDemoDescription(htmlFilename: "jmldeltaindex.html", path: "jmldelta")),
        Demo(name: "Worlds", group: "Dekadence", year: "2017", viewController: { return WorldsViewController() }, htmlDescription: nil),
        Demo(name: "#jumalauta", group: "Jumalauta", year: "2017", viewController: nil, htmlDescription: HtmlDemoDescription(htmlFilename: "jml_irc_ad.html", path: "jml_irc_ad")),
        Demo(name: "α", group: "Jumalauta", year: "2017", viewController: nil, htmlDescription: HtmlDemoDescription(htmlFilename: "jmlalpha.html", path: "jmlalpha")),
        Demo(name: "Thinkpiece", group: "Dekadence", year: "2017", viewController: nil, htmlDescription: HtmlDemoDescription(htmlFilename: "thinkpiece.html", path: "thinkpiece")),
        Demo(name: "Destroy All Humans", group: "Jumalauta", year: "2015", viewController: nil, htmlDescription: HtmlDemoDescription(htmlFilename: "jmldstr.html", path: "jmldstr")),
    ]

    let tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        self.tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.view.addSubview(self.tableView)
    }

    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.demos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let demo = self.demos[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier") ?? UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cellIdentifier")
        
        cell.textLabel?.text = demo.name
        cell.textLabel?.font = UIFont.init(name: "Superclarendon-BoldItalic", size: 36)
        
        cell.detailTextLabel?.text = "\(demo.group), \(demo.year)"
        cell.detailTextLabel?.font = UIFont.init(name: "Superclarendon-Regular", size: 24)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let demo = self.demos[indexPath.row]

        if let viewController = demo.viewController?() {
            self.navigationController?.pushViewController(viewController, animated: true)
        } else if let htmlDescription = demo.htmlDescription {
            let webViewController = WebViewController(demoDescription: htmlDescription)
            self.navigationController?.pushViewController(webViewController, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
}
