//
//  TutorialView.swift
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

import Foundation
import UIKit
import WebKit

class TutorialView: UIView {
    let webView: WKWebView
    let button: UIButton
    let completion: (TutorialView) -> ()
    
    init(frame: CGRect, completion: @escaping (TutorialView) -> ()) {
        let webViewConfiguration = WKWebViewConfiguration()
        webViewConfiguration.mediaTypesRequiringUserActionForPlayback = []
        webViewConfiguration.allowsInlineMediaPlayback = true
        self.webView = WKWebView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height), configuration: webViewConfiguration)
        self.webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.webView.loadFileURL(Bundle.main.bundleURL.appendingPathComponent("tutorial.html"), allowingReadAccessTo: Bundle.main.bundleURL)
        self.webView.scrollView.isScrollEnabled = false
        self.webView.backgroundColor = UIColor.clear
        self.webView.isOpaque = false
        self.webView.scrollView.backgroundColor = UIColor.clear
        
        self.button = UIButton(type: UIButtonType.custom)
        self.button.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.button.frame = frame
        
        self.completion = completion
        
        super.init(frame: frame)
        
        self.addSubview(self.webView)

        self.button.addTarget(self, action: #selector(buttonTouched), for: UIControlEvents.touchUpInside)
        self.addSubview(self.button)

        self.backgroundColor = UIColor.clear
    }
    
    override init(frame: CGRect) {
        fatalError("init(coder:) has not been implemented")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonTouched(button: UIButton) {
        self.completion(self)
    }
}
