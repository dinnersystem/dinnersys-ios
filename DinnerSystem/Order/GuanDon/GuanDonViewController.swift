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
import Crashlytics

class GuanDonViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let feedbackGenerator = UINotificationFeedbackGenerator()
    
    @IBOutlet var costView: UITableView!
    @IBOutlet var qtyView: UITableView!
    @IBOutlet var nameView: UITableView!
    @IBOutlet var picker: UISegmentedControl!
    
    override func viewDidLoad() {
        if #available(iOS 13.0, *) {
            if(traitCollection.userInterfaceStyle == .dark){
                self.view.backgroundColor = UIColor.black
            }else{
                self.view.backgroundColor = UIColor.white
            }
        } else {
            self.view.backgroundColor = UIColor.white
        }
        feedbackGenerator.prepare()
    }
    
    //MARK: - tableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if tableView == nameView{
            cell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath)
        }else if tableView == qtyView{
            cell = tableView.dequeueReusableCell(withIdentifier: "qtyCell", for: indexPath)
        }else if tableView == costView{
            cell = tableView.dequeueReusableCell(withIdentifier: "costCell", for: indexPath)
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath)
        }
        let info = foodArr[indexPath.row]
        if tableView == nameView{
            cell.textLabel?.text = info.name
            cell.textLabel?.adjustsFontSizeToFitWidth = true
            return cell
        }else if tableView == qtyView{
            cell.textLabel?.text = info.qty
            return cell
        }else if tableView == costView{
            cell.textLabel?.text = info.cost
            return cell
        }else{
            cell.textLabel?.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch tableView {
        case nameView: return "名稱"
        case qtyView: return "數量"
        case costView: return "單價"
        default: return nil
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(self.costView == scrollView){
            self.nameView.contentOffset = scrollView.contentOffset
            self.qtyView.contentOffset = scrollView.contentOffset
        }else if(self.nameView == scrollView){
            self.costView.contentOffset = scrollView.contentOffset
            self.qtyView.contentOffset = scrollView.contentOffset
        }else if(self.qtyView == scrollView){
            self.costView.contentOffset = scrollView.contentOffset
            self.nameView.contentOffset = scrollView.contentOffset
        }
    }
    
    //MARK: - orderButton
    @IBAction func sendOrder(_ sender: Any) {
        let selectedTime = (picker.selectedSegmentIndex == 0 ? "-11:00:00" : "-12:00:00")
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        var orderResult = ""
        var currentDate = formatter.string(from: date)
        currentDate += selectedTime
        guanDonParam.updateValue(currentDate, forKey: "time")
        //time lock
        let calander = Calendar.current
        let lower_bound_12 = calander.date(bySettingHour: 10, minute: 10, second: 0, of: date)
        let lower_bound_11 = calander.date(bySettingHour: 9, minute: 10, second: 0, of: date)
        //end
        if ((selectedTime == "-11:00:00" && date > lower_bound_11!) || (selectedTime == "-12:00:00" && date > lower_bound_12!)) {
//        if false {
            let alertStr = selectedTime == "-11:00:00" ? "早上九點十分後無法訂餐，明日請早" : "早上十點十分後無法訂餐，明日請早"
            let alert = UIAlertController(title: "超過訂餐時間", message: alertStr, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                (action: UIAlertAction!) -> () in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true)
        }else{
            Alamofire.request(dsRequestURL, method: .post, parameters: guanDonParam).responseData{response in
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
                if responseString.contains("Impossible") || responseString.contains("Off") || responseString.contains("tomorrow"){
                    orderResult = "DTError"
                }else if responseString == "" {
                    orderResult = "Logout"
                }else if responseString.contains("Invalid"){
                    orderResult = "Error"
                }else if responseString.contains("exceed"){
                    orderResult = "limitExceed"
                }else {
                    do{
                        orderInfo = try decoder.decode([Order].self, from: response.data!)
                        orderResult = "Success"
                    }catch let error{
                        print(error)
                        Crashlytics.sharedInstance().recordError(error)
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
                    let alert = UIAlertController(title: "時間/日期發生錯誤", message: "請確認您手機的日期正確，或嘗試重新開啟程式，若持續發生問題，請通知開發人員！", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                case "Logout":
                    let alert = UIAlertController(title: "您已經登出", message: "請嘗試重新登入，或嘗試重新開啟程式，若持續發生問題，請通知開發人員！", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        (action: UIAlertAction!) -> () in
                        logout()
                        self.dismiss(animated: true, completion: nil)
                    }))
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
}
