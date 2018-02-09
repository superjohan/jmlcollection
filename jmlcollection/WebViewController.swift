//
//  WebViewController.swift
//  jmlcollection
//
//  Created by Johan Halin on 28/01/2018.
//  Copyright © 2018 Jumalauta. All rights reserved.
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
