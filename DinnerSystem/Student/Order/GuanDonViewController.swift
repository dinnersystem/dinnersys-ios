//
//  GuanDonViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2018/12/21.
//  Copyright © 2018 Sean.Inc. All rights reserved.
//

import Foundation
import Alamofire

class GuanDonViewController: UIViewController{
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        label.text = "您選的餐點是\(selectedFood.name)，價格總共\(selectedFood.cost)元，確定請選擇日期和時間後按下訂餐（取餐日期限制：該週週一到週五，取餐時間：）"
    }
    
    @IBAction func order(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd-HH:mm:ss"
        let date = formatter.string(from: datePicker.date)
        print(date)
        Alamofire.request("\(ord.url)&time=\(date)").responseString{response in
            //insert_ur_magic_here
        }
    }
    
    
    
    
    
}
