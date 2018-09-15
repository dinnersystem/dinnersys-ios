//
//  DevViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2018/8/13.
//  Copyright © 2018年 Sean.Inc. All rights reserved.
//

import UIKit

class DevViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder()
    }
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
        }
    }

    

}
