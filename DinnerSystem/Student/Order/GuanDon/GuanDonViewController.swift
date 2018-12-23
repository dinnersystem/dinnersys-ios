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
        label.text = "您選擇的餐點是\(selectedFood.name)，價錢為\(selectedFood.cost)元，確定請選擇取餐時間後按下訂餐。\n請注意早上十點後將無法點餐!"
    }
    
    @IBAction func sendOrder(_ sender: Any) {
        let selectedTime = (picker.selectedSegmentIndex == 0 ? "-11:00:00" : "12:00:00")
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        var orderResult = ""
        var currentDate = formatter.string(from: date)
        currentDate += selectedTime
        Alamofire.request("\(ord.url)&time=\(currentDate)").responseData{response in
            if response.error != nil {
                let errorAlert = UIAlertController(title: "Error", message: "不知名的錯誤，請注意網路連線狀態或聯絡管理員。", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                    (action: UIAlertAction!) -> () in
                    logout()
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(errorAlert, animated: true, completion: nil)
            }
            let responseString = String(data: response.data!, encoding: .utf8)!
            if responseString.contains("廠商"){
                orderResult = "DTError"
            }else if responseString == "" {
                orderResult = "Logout"
            }else if responseString.contains("Invalid"){
                orderResult = "Error"
            }else{
                
                do{
                    orderInfo = try decoder.decode([Order].self, from: response.data!)
                }catch let error{
                    print(error)
                    let alert = UIAlertController(title: "請重新登入", message: "發生了不知名的錯誤，若重複發生此錯誤請務必通知開發人員！", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        (action: UIAlertAction!) -> () in
                        logout()
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                orderResult = "Success"
            }
            let result = orderResult
            switch result {
            case "DTError":
                let alert = UIAlertController(title: "時間/日期發生錯誤", message: "請確認您手機的日期正確，或嘗試重新開啟程式，若持續發生問題，請通知開發人員！", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            case "Logout":
                let alert = UIAlertController(title: "您已經登出", message: "請嘗試重新登入，或嘗試重新開啟程式，若持續發生問題，請通知開發人員！", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                logout()
                self.present(alert, animated: true)
            case "Success":
                let alert = UIAlertController(title: "點餐成功", message: "訂單編號\(orderInfo[0].id!),請記得付款！", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                    (action: UIAlertAction!) -> () in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true)
            case "Error":
                let alert = UIAlertController(title: "Unexpected Error", message: "發生了不知名的錯誤。請嘗試重新登入，或嘗試重新開啟程式，若持續發生問題，請通知開發人員！", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            default:
                let alert = UIAlertController(title: "Unexpected Error", message: "發生了不知名的錯誤。請嘗試重新登入，或嘗試重新開啟程式，若持續發生問題，請通知開發人員！", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            }
    }
    
    
}
