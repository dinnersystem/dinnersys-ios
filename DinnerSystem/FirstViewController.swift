//
//  FirstViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2018/8/13.
//  Copyright © 2018年 Sean.Inc. All rights reserved.
//0

import UIKit
import Alamofire
import Reachability

class FirstViewController: UIViewController {
    @IBOutlet var label: UILabel!
    let reachability = Reachability()!
    @IBOutlet var button: UIButton!
    override func viewDidLoad() {
        if reachability.connection == .none{
            self.button.isHidden = false
            self.label.isHidden = false
        }else{
            self.performSegue(withIdentifier: "internet", sender: nil)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if reachability.connection == .none{
            self.button.isHidden = false
            self.label.isHidden = false
        }else{
            self.performSegue(withIdentifier: "internet", sender: nil)
        }
    }
}
