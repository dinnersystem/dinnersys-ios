//
//  websiteViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2018/2/28.
//  Copyright © 2018年 Sean.Inc. All rights reserved.
//

import UIKit
import WebKit

class websiteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let viewFrame = CGRect(x: 0, y: 64, width: view.frame.width, height: ((view.frame.height)-49))
        let webView = WKWebView(frame: viewFrame)
        webView.allowsBackForwardNavigationGestures = true
        let homeURL = URL(string: "http://dinnersys.ddns.net/")
        let homeRequest = URLRequest(url: homeURL!)
        webView.load(homeRequest)
        view.addSubview(webView)
        
    }

}
