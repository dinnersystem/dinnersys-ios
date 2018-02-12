//
//  MoreTableViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2018/1/20.
//  Copyright © 2018年 Sean.Inc. All rights reserved.
//

import UIKit
import WebKit

class MoreViewController: UIViewController {

    
    @IBOutlet var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let homeURL = URL(string: "http://dinnersys.ddns.net/")
        let homeRequest = URLRequest(url: homeURL!)
        webView.load(homeRequest)
    }

}
