//
//  MainOrderTableViewController.swift
//  DinnerSystemBeta
//
//  Created by Sean on 2018/9/24.
//  Copyright © 2018年 Sean.Inc. All rights reserved.
//

import UIKit
import Alamofire

class adminMainOrderTableViewController: UITableViewController {

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





class adminOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var textView:UITextView!
    @IBOutlet var button:UIButton!
    var orderResult = ""
    var peopleCount = 0
    let singleCost = Int(selectedFood.cost)
    var selArray:[String] = []
    override func viewDidLoad() {
        
        textView.text! = "您點的餐為\(selectedFood.name)，共\(peopleCount)人，價錢為\(singleCost! * peopleCount)元，請於下方選擇座號並進行點餐"
        button.isEnabled = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seatNumArr.count
    }
    @IBAction func adminOrder(_ sender: Any) {
        selArray = []
        var successIDArr:[String] = []
        var successCount = 0
        var failIDArr:[String] = []
        var failCount = 0
        //var message = ""
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let currentDate = formatter.string(from: date)
        //let queue = DispatchQueue(label: "app.dinnersys.queue", qos: .userInteractive)
        let sr = self.tableView.indexPathsForSelectedRows
        print (sr!)
        for index in sr!{                       //make selArr
            let indexNum = index[1]
            let seatNum = seatNumArr[indexNum]
            if seatNum/10 == 0{
                selArray.append("\(userInfo.classField!.classNo!)0\(String(seatNum))")
            }else{
                selArray.append("\(userInfo.classField!.classNo!)\(String(seatNum))")
            }
        }
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
            for classSeat in self.selArray{                    //make order
                Alamofire.request("\(dsURL("make_class_order"))&target_id=\(classSeat)&dish_id=\(selectedFood.id)&time=\(currentDate)-12:00:00").responseData{ response in
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
                        self.orderResult = "DTError"
                    }else if responseString == "" {
                        self.orderResult = "Logout"
                    }else if responseString == "Invalid seat_id."{
                        self.orderResult = "SeatError"
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
                        self.orderResult = "Success"
                    }
                    self.orderResult = ""
                    switch self.orderResult{
                    case "DTError":
                        let alert = UIAlertController(title: "時間/日期發生錯誤", message: "請確認您手機的日期正確，或嘗試重新開啟程式，若持續發生問題，請通知開發人員！", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    case "Logout":
                        let alert = UIAlertController(title: "您已經登出", message: "請嘗試重新登入，或嘗試重新開啟程式，若持續發生問題，請通知開發人員！", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                            (action: UIAlertAction!) -> () in
                            logout()
                            self.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true)
                    case "Success":
                        successIDArr.append(orderInfo[0].id!)
                        successCount += 1
                    case "SeatError":
                        failIDArr.append(classSeat)
                        failCount += 1
                    default:
                        let alert = UIAlertController(title: "Unexpected Error", message: "發生了不知名的錯誤。請嘗試重新登入，或嘗試重新開啟程式，若持續發生問題，請通知開發人員！", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                            (action: UIAlertAction!) -> () in
                            self.navigationController?.popViewController(animated: true)
                        }))
                        //self.present(alert, animated: true)
                        }
                    
                    }
                
                }/*
                if successCount != 0{
                    message = "點餐結果：共\(String(successCount))項點餐成功，訂單編號分別為"
                    for num in successIDArr{
                        message += "\(num),"
                    }
                    message.remove(at: message.index(before: message.endIndex))
                    message += "\n請記得收款！"
                }
                if failCount != 0{
                    message += "\n有\(failCount)項點餐不成功，座號分別為"
                    for num in failIDArr{
                        message += "\(num),"
                    }
                    message.remove(at: message.index(before: message.endIndex))
                    message += "\n請確定座號正確！"
                }
                if self.orderResult == "DTError"{
                    message = "日期/時間發生錯誤，請確認您手機的日期正確，或嘗試重新開啟程式，若持續發生問題，請通知開發人員！"
                }
                if self.orderResult == "Logout"{
                    message = "你已經登出，請重新登入。"
                }
                let alert = UIAlertController(title: "", message: message, preferredStyle: .actionSheet)
                let backAction = UIAlertAction(title: "OK", style: .default, handler: {
                    (action: UIAlertAction!) -> () in
                    self.navigationController?.popViewController(animated: true)
                })
                let logoutAction = UIAlertAction(title: "OK", style: .default, handler: {
                    (action: UIAlertAction!) -> () in
                    logout()
                    self.dismiss(animated: true, completion: nil)
                })
                if self.orderResult == "Logout"{
                    alert.addAction(logoutAction)
                }else{
                    alert.addAction(backAction)
                }
                self.present(alert,animated: true)
 */
                let alert = UIAlertController(title: "", message: "請至管理點餐檢視點餐結果，請注意若無該座號對應之同學將自動跳過！", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                    (action: UIAlertAction!) -> () in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert,animated: true)
            }
            
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "seatNumCell", for: indexPath)
        let info = seatNumArr[indexPath.row]
        cell.textLabel?.text! = String(info)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected  \(indexPath.row)")
        //if let cell = tableView.cellForRow(at: indexPath) {
          //  if cell.isSelected {
            //    cell.accessoryType = .checkmark
            //}
        //}
        if let sr = tableView.indexPathsForSelectedRows {
            print("didDeselectRowAtIndexPath selected rows:\(sr)")
            peopleCount = sr.count
        }else{
            peopleCount = 0
        }
        if peopleCount>0{
            self.textView.text! = "您點的餐為\(selectedFood.name)，共\(peopleCount)人，價錢為\(singleCost! * peopleCount)元，請於下方選擇座號並進行點餐"
            self.button.isEnabled = true
        }else{
            self.textView.text! = "您點的餐為\(selectedFood.name)，共\(peopleCount)人，價錢為\(singleCost! * peopleCount)元，請於下方選擇座號並進行點餐"
            self.button.isEnabled = false
        }
        
        
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("deselected  \(indexPath.row)")
        //if let cell = tableView.cellForRow(at: indexPath) {
          //  if cell.isSelected {
            //    cell.accessoryType = .none
           // }
        //}
        if let sr = tableView.indexPathsForSelectedRows {
            print("didDeselectRowAtIndexPath deselected rows:\(sr)")
            peopleCount = sr.count
        }else{
            peopleCount = 0
        }
        if peopleCount>0{
            self.textView.text! = "您點的餐為\(selectedFood.name)，共\(peopleCount)人，價錢為\(singleCost! * peopleCount)元，請於下方選擇座號並進行點餐"
            self.button.isEnabled = true
        }else{
            self.textView.text! = "您點的餐為\(selectedFood.name)，共\(peopleCount)人，價錢為\(singleCost! * peopleCount)元，請於下方選擇座號並進行點餐"
            self.button.isEnabled = false
        }
    }
    
}
