//
//  WebViewController.swift
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
import WebKit

class WebViewController: UIViewController {
    let webView: WKWebView
    let demoDescription: HtmlDemoDescription
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.webView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        self.webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.webView.loadFileURL(Bundle.main.bundleURL.appendingPathComponent(self.demoDescription.htmlFilename), allowingReadAccessTo: Bundle.main.bundleURL.appendingPathComponent(self.demoDescription.path))
        self.webView.scrollView.isScrollEnabled = false
        self.view.addSubview(self.webView)
    }
    
    override func prefersHomeIndicatorAutoHidden() -> Bool {
        return true
    }

    init(demoDescription: HtmlDemoDescription) {
        let webViewConfiguration = WKWebViewConfiguration()
        webViewConfiguration.mediaTypesRequiringUserActionForPlayback = []
        self.webView = WKWebView(frame: CGRect.zero, configuration: webViewConfiguration)
        self.demoDescription = demoDescription
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
