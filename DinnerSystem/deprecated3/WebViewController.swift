//
//  WebViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2018/6/17.
//  Copyright © 2018年 Sean.Inc. All rights reserved.
//

import UIKit
import WebKit
import Reachability

class WebViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet var toolBar: UIToolbar!
    @IBOutlet var backButton: UIBarButtonItem!
    @IBOutlet var frontButton: UIBarButtonItem!
    let reachability = Reachability()!
    var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - toolBar.frame.height - (tabBarController?.tabBar.frame.height)!)
        webView = WKWebView(frame: viewFrame)
        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = self
        let homeUrl = URL(string: "http://dinnersystem.ddns.net/dinnersys_beta/frontend/login.html")
        let homeRequest = URLRequest(url: homeUrl!)
        webView.load(homeRequest)
        view.addSubview(webView)
        if (webView.canGoBack){
            backButton.isEnabled = true
        }else{
            backButton.isEnabled = false
        }
        if (webView.canGoForward){
            frontButton.isEnabled = true
        }else{
            frontButton.isEnabled = false
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if reachability.connection == .none{
            self.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func back(_ sender: Any) {
        webView.goBack()
        if (webView.canGoBack){
            backButton.isEnabled = true
        }else{
            backButton.isEnabled = false
        }
    }
    @IBAction func front(_ sender: Any) {
        webView.goForward()
        if (webView.canGoForward){
            frontButton.isEnabled = true
        }else{
            frontButton.isEnabled = false
        }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if (webView.canGoForward){
            frontButton.isEnabled = true
        }else{
            frontButton.isEnabled = false
        }
        if (webView.canGoBack){
            backButton.isEnabled = true
        }else{
            backButton.isEnabled = false
        }
    }
    


}
