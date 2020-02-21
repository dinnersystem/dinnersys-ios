//
//  confirmTableViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2020/2/21.
//  Copyright © 2020 DinnerSystem Team. All rights reserved.
//

import UIKit
import Alamofire
import Crashlytics

class confirmTableViewController: UITableViewController {

    //IBOutlets
    @IBOutlet var dishCell: UITableViewCell!
    @IBOutlet var timeCell: UITableViewCell!
    @IBOutlet var paymentCell: UITableViewCell!
    
    let feedbackGenerator = UINotificationFeedbackGenerator()
    let datePicker = UIDatePicker()
    var payBool = false
    var orderTime = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedbackGenerator.prepare()
        payBool = false
        orderTime = ""
        
        //set cell
        dishCell.textLabel?.text = ConfirmFood.name
        dishCell.detailTextLabel?.text = ConfirmFood.cost + "$"
        timeCell.detailTextLabel?.adjustsFontSizeToFitWidth = true
        timeCell.detailTextLabel?.minimumScaleFactor = 0.5
        
        //update balance
        do{
            let balanceRepsonse = try Data(contentsOf: URL(string: dsURL("get_pos"))!)
            do{
                POSInfo = try decoder.decode(CardInfo.self, from: balanceRepsonse)
                balance = Int(POSInfo.money!)!
            }catch let error{
                Crashlytics.sharedInstance().recordError(error)
                print(String(data: balanceRepsonse, encoding: .utf8)!)
                let alert = UIAlertController(title: "請重新登入", message: "查詢餘額失敗，我們已經派出最精銳的猴子去修理這個問題，若長時間出現此問題請通知開發人員！", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                    (action: UIAlertAction!) -> () in
                    logout()
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }catch let error{
            Crashlytics.sharedInstance().recordError(error)
            print(error)
            let errorAlert = UIAlertController(title: "Bad Internet.", message: "Please check your internet connection and retry.", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                (action: UIAlertAction!) -> () in
                logout()
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(errorAlert, animated: true, completion: nil)
        }
    }
    
    
    func sendOrder(){
        var orderResult = ""
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let currentDate = formatter.string(from: date)
        
        //time lock
        let calander = Calendar.current
        let lower_bound = calander.date(bySettingHour: 10, minute: 10, second: 0, of: date)
        //end
        if date > lower_bound! {
            //        if false{
            let alert = UIAlertController(title: "超過訂餐時間", message: "早上十點十分後無法訂餐，明日請早", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                (action: UIAlertAction!) -> () in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true)
        }else{
            //TIME of order Parameter
            AF.request(dsRequestURL, method: .post, parameters: orderParameter).responseData{response in
                if response.error != nil {
                    let errorAlert = UIAlertController(title: "Bad Internet.", message: "Please check your internet connection and retry.", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        (action: UIAlertAction!) -> () in
                        logout()
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(errorAlert, animated: true, completion: nil)
                }
                let responseString = String(data: response.data!, encoding: .utf8)!
                print(responseString)
                if responseString.contains("Off") || responseString.contains("Impossible"){
                    orderResult = "DTError"
                }else if responseString == "" {
                    orderResult = "Logout"
                }else if responseString.contains("Invalid"){
                    orderResult = "Error"
                }else if responseString.contains("exceed"){
                    orderResult = "limitExceed"
                }else{
                    
                    do{
                        orderInfo = try decoder.decode([Order].self, from: response.data!)
                        orderResult = "Success"
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
                    
                }
                let result = orderResult
                switch result {
                case "DTError":
                    let alert = UIAlertController(title: "時間/日期發生錯誤", message: "請不要在00:00-04:00之間點餐，或請確認您手機的日期正確，或嘗試重新開啟程式，若持續發生問題，請通知開發人員！", preferredStyle: .alert)
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
                    self.feedbackGenerator.notificationOccurred(.success)
                    self.present(alert, animated: true)
                case "Error":
                    let alert = UIAlertController(title: "Unexpected Error", message: "發生了不知名的錯誤。請嘗試重新登入，或嘗試重新開啟程式，若持續發生問題，請通知開發人員！", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                case "limitExceed":
                    let alert = UIAlertController(title: "餐點已售完", message: "您的訂單中似乎有一或多項餐點已售完", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        (action: UIAlertAction!) -> () in
                        logout()
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true)
                default:
                    let alert = UIAlertController(title: "Unexpected Error", message: "發生了不知名的錯誤。請嘗試重新登入，或嘗試重新開啟程式，若持續發生問題，請通知開發人員！", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return factoryInfoArray[ConfirmFood.fID]!.name!
        }else{
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            //time
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = NSTimeZone.local
            let now = Date()
            dateFormatter.dateFormat = "YYYY/MM/dd"
            let nowDate = dateFormatter.string(from: now)
            let factory = factoryInfoArray[ConfirmFood.fID]!
            let upperBoundTimeString = factory.availUpperBound! //11:00:00
            let lowerBoundTimeString = factory.upperBound! //12:00:00
            let upperBoundDateString = nowDate + " " + upperBoundTimeString
            let lowerBoundDateString = nowDate + " " + lowerBoundTimeString
            dateFormatter.dateFormat = "YYYY/MM/dd HH:mm:ss"
            let upperBound = dateFormatter.date(from: upperBoundDateString)!
            let lowerBound = dateFormatter.date(from: lowerBoundDateString)!
            var availTime = upperBound
            var pickerValue: [[String]] = [[]]
            while availTime <= lowerBound {
                pickerValue[0].append(dateFormatter.string(from: availTime))
                availTime.add(.hour, value: 1)
            }
            let alert = UIAlertController(style: .actionSheet, title: "請選擇取餐時間")
            alert.addPickerView(values: pickerValue){  vc, picker, index, values in
                self.timeCell.detailTextLabel?.text = values[0][index.row]
                if #available(iOS 13.0, *) {
                    self.timeCell.detailTextLabel?.textColor = .label
                } else {
                    self.timeCell.detailTextLabel?.textColor = .black
                }
                self.orderTime = values[0][index.row]
            }
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {_ in
                if self.orderTime == ""{
                    self.timeCell.detailTextLabel?.text = pickerValue[0][0]
                    if #available(iOS 13.0, *) {
                        self.timeCell.detailTextLabel?.textColor = .label
                    } else {
                        self.timeCell.detailTextLabel?.textColor = .black
                    }
                    self.orderTime = pickerValue[0][0]
                }
            }))
            self.present(alert, animated: true, completion: nil)
            self.tableView.deselectRow(at: indexPath, animated: true)
        }else if indexPath.section == 2{
            //payment
            let alert = UIAlertController(style: .actionSheet, title: "請選擇付款方式")
            if Int(ConfirmFood.cost)! <= balance{
                alert.addAction(UIAlertAction(title: "學生證付款(餘額:\(balance)元)", style: .default, handler: { _ in
                    self.payBool = true
                    self.paymentCell.detailTextLabel?.text = "學生證付款"
                    if #available(iOS 13.0, *) {
                        self.paymentCell.detailTextLabel?.textColor = .label
                    } else {
                        self.paymentCell.detailTextLabel?.textColor = .black
                    }
                }))
            }else{
                let action = UIAlertAction(title: "學生證餘額不足(\(balance)元)", style: .default, handler: nil)
                action.isEnabled = false
                action.setValue(UIColor.gray, forKey: "titleTextColor")
                alert.addAction(action)
            }
            
            alert.addAction(UIAlertAction(title: "暫不付款", style: .default, handler: { _ in
                self.payBool = false
                self.paymentCell.detailTextLabel?.text = "暫不付款"
                if #available(iOS 13.0, *) {
                    self.paymentCell.detailTextLabel?.textColor = .label
                } else {
                    self.paymentCell.detailTextLabel?.textColor = .black
                }
            }))
            self.present(alert, animated: true, completion: nil)
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }

}
