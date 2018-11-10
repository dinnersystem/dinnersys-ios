//
//  MainOrderTableViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2018/9/13.
//  Copyright © 2018年 Sean.Inc. All rights reserved.
//

import UIKit
import Alamofire
import TrueTime

class MainOrderTableViewController: UITableViewController {
    
    var activityIndicator = UIActivityIndicatorView()
    var indicatorBackView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        var foodCount = 0
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        indicatorBackView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        indicatorBackView.center = self.view.center
        indicatorBackView.isHidden = true
        indicatorBackView.layer.cornerRadius = 20
        indicatorBackView.alpha = 0.5
        indicatorBackView.backgroundColor = UIColor.black
        self.view.addSubview(indicatorBackView)
        self.view.addSubview(activityIndicator)
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        self.activityIndicator.startAnimating()
        self.indicatorBackView.isHidden = false
        
        Alamofire.request(dsURL("show_dish")).responseData{ response in
            if response.error != nil {
                let errorAlert = UIAlertController(title: "Error", message: "不知名的錯誤，請注意網路連線狀態或聯絡管理員。", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                    (action: UIAlertAction!) -> () in
                    logout()
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(errorAlert, animated: true, completion: nil)
            }else{
                
            let responseStr = String(data: response.data!, encoding: .utf8)
            if responseStr == ""{
                let alert = UIAlertController(title: "請重新登入", message: "您已經登出", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                    (action: UIAlertAction!) -> () in
                    logout()
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }else{
            mainMenuArr = []
            taiwanMenuArr = []
            aiJiaMenuArr = []
            cafetMenuArr = []
            //mainMenuArr = try! decoder.decode([Menu].self, from: response.data!)
                do{
                    mainMenuArr = try decoder.decode([Menu].self, from: response.data!)
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
            for food in mainMenuArr{
                if food.isIdle! == "1"{
                    mainMenuArr.remove(at: foodCount)
                }else{
                    foodCount += 1
                }
            }
            for food in mainMenuArr{
                if food.factory?.name! == "台灣小吃部"{
                    taiwanMenuArr.append(food)
                }else if food.factory?.name! == "愛佳便當"{
                    aiJiaMenuArr.append(food)
                }else if food.factory?.name! == "合作社"{
                    cafetMenuArr.append(food)
                }else{
                    
                }
            }
        }
                
            }
            self.indicatorBackView.isHidden = true
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }


}


class orderViewController: UIViewController{
    @IBOutlet var label: UILabel!
    override func viewDidLoad() {
        label.text! = "您選擇的餐點是\(selectedFood.name)，價錢為\(selectedFood.cost)元，確定請按訂餐。\n請注意早上十點後將無法點餐!"
        label.sizeToFit()
    }
    
    @IBAction func order(_ sender: Any)  {
        var orderResult = ""
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let currentDate = formatter.string(from: date)
        
        //time lock
        let calander = Calendar.current
        let lower_bound = calander.date(bySettingHour: 10, minute: 0, second: 0, of: date)
        //end
        if date > lower_bound! {
            let alert = UIAlertController(title: "超過訂餐時間", message: "早上十點後無法訂餐，明日請早", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                (action: UIAlertAction!) -> () in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true)
        }else{
            Alamofire.request("\(dsURL("make_self_order"))&dish_id=\(selectedFood.id)&time=\(currentDate)-12:00:00").responseData{response in
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
    
    
    
    
}
