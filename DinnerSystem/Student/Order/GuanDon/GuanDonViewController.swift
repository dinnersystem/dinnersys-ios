//
//  GuanDonViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2018/12/21.
//  Copyright © 2018 Sean.Inc. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

class GuanDonViewController: UIViewController{
    
    @IBOutlet var label: UILabel!
    @IBOutlet var picker: UISegmentedControl!
    
    override func viewDidLoad() {
        label.text = ""
    }
    
    @IBAction func sendOrder(_ sender: Any) {
        let selectedTime = (picker.selectedSegmentIndex == 0 ? "-11:00:00" : "12:00:00")
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        var currentDate = formatter.string(from: date)
        currentDate += selectedTime
        
    }
    
    
}
