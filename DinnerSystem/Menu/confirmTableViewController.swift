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
    @IBOutlet var orderButton: UITableViewCell!
    
    let feedbackGenerator = UINotificationFeedbackGenerator()
    let datePicker = UIDatePicker()
    var payBool: Bool? = nil
    var orderTime = ""
    var prepareTime: [String] = []
    var paymentTime: [String] = []
    var activityIndicator = UIActivityIndicatorView()
    var indicatorBackView = UIView()
    var indicatorLabel = UILabel()
    
    func enablePay(){
        orderButton.backgroundColor = #colorLiteral(red: 0, green: 0.4980392157, blue: 1, alpha: 1)
        orderButton.textLabel?.text = "送出訂單"
        orderButton.isUserInteractionEnabled = true
    }
    
    func disablePay(){
        orderButton.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        orderButton.textLabel?.text = "請選擇內容"
        orderButton.isUserInteractionEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedbackGenerator.prepare()
        payBool = nil
        orderTime = ""
        disablePay()
        
        //set cell
        dishCell.textLabel?.text = ConfirmFood.name
        dishCell.detailTextLabel?.text = ConfirmFood.cost + "$"
        timeCell.detailTextLabel?.adjustsFontSizeToFitWidth = true
        timeCell.detailTextLabel?.minimumScaleFactor = 0.5
        
        //get factory order time bound
        let factory = factoryInfoArray[ConfirmFood.fID]!
        prepareTime = factory.prepareTime!.split(separator: ":").map(String.init)
        paymentTime = factory.paymentTime!.split(separator: ":").map(String.init)
        
        //indicator
        let centerX = UIScreen.main.bounds.width / 2
        let centerY = UIScreen.main.bounds.height / 2
        activityIndicator.center = CGPoint(x: centerX, y: centerY - 15)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        
        indicatorLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        indicatorLabel.textAlignment = .center
        indicatorLabel.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        indicatorLabel.center = CGPoint(x: centerX, y: centerY + 15)
        self.indicatorLabel.adjustsFontSizeToFitWidth = true
        indicatorLabel.isHidden = true
        
        indicatorBackView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        indicatorBackView.center = CGPoint(x: centerX, y: centerY)
        indicatorBackView.isHidden = true
        indicatorBackView.layer.cornerRadius = 20
        indicatorBackView.alpha = 0.5
        indicatorBackView.backgroundColor = UIColor.lightGray
        self.view.addSubview(indicatorBackView)
        self.view.addSubview(activityIndicator)
        self.view.addSubview(indicatorLabel)
        
    }
    
    
    func sendOrder(orderString: String, isPay: Bool){
        //indicator
        self.indicatorLabel.text = "正在訂餐"
        UIApplication.shared.beginIgnoringInteractionEvents()
        self.activityIndicator.startAnimating()
        self.indicatorBackView.isHidden = false
        self.indicatorLabel.isHidden = false
        
        
        var orderResult = ""
        let factory = factoryInfoArray[ConfirmFood.fID]!
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let currentDate = formatter.string(from: date)
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let upperBound = formatter.date(from: "\(currentDate) \(factory.upperBound!)")
        //let paymentDeadline = upperBound!.adding(.hour, value: -1*Int(paymentTime[0])!).adding(.minute, value: -1*Int(paymentTime[1])!).adding(.second, value: -1*Int(paymentTime[2])!)
        let orderDeadLine = upperBound!.adding(.hour, value: -1*Int(prepareTime[0])!).adding(.minute, value: -1*Int(prepareTime[1])!).adding(.second, value: -1*Int(prepareTime[2])!)
        let paymentDeadLine = upperBound!.adding(.hour, value: -1*Int(paymentTime[0])!).adding(.minute, value: -1*Int(paymentTime[1])!).adding(.second, value: -1*Int(paymentTime[2])!)
        
        if date > orderDeadLine {
//        if false{
            self.indicatorBackView.isHidden = true
            self.indicatorLabel.isHidden = true
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            formatter.dateFormat = "aHH:mm"
            formatter.amSymbol = "上午"
            formatter.pmSymbol = "下午"
            formatter.locale = Locale(identifier: "zh_Hant_TW")
            let time = formatter.string(from: orderDeadLine)
            let alert = UIAlertController(title: "超過訂餐時間", message: "\(time)後無法訂餐，明日請早", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                (action: UIAlertAction!) -> () in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true)
        }else{
            //TIME of order Parameter
            let orderDate = formatter.date(from: orderString)!
            formatter.dateFormat = "yyyy/MM/dd-HH:mm:ss"
            let timeString = formatter.string(from: orderDate)
            orderParameter.updateValue(timeString, forKey: "time")
            AF.request(dsRequestURL, method: .post, parameters: orderParameter).responseData{response in
                self.indicatorBackView.isHidden = true
                self.indicatorLabel.isHidden = true
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                if response.error != nil {
                    let errorAlert = UIAlertController(title: "Bad Internet.", message: "Please check your internet connection and retry.", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        (action: UIAlertAction!) -> () in
                        logout()
                        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                    }))
                    self.present(errorAlert, animated: true, completion: nil)
                }
                let responseString = String(data: response.data!, encoding: .utf8)!
                print(responseString)
                if responseString.contains("Off") || responseString.contains("Impossible"){
                    orderResult = "DTError"
                }else if responseString == "" || responseString.contains("Operation not allowed"){
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
                            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
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
                    
                    if isPay{
                        //indicator
                        self.indicatorLabel.text = "正在付款"
                        
                        self.indicatorBackView.isHidden = true
                        self.indicatorLabel.isHidden = true
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        
                        self.tableView.isUserInteractionEnabled = false                 //prevent from bugging
                        var _ = ""  //hash
                        var payment_pw = ""
                        //var timeStamp = String(Int(Date().timeIntervalSince1970))
                        let pwAttempt = UIAlertController(title: "請輸入繳款密碼", message: "預設為身分證字號後四碼", preferredStyle: .alert)
                        let sendAction = UIAlertAction(title: "確認", style: .default, handler: { (action: UIAlertAction!) -> () in
                            UIApplication.shared.beginIgnoringInteractionEvents()
                            self.activityIndicator.startAnimating()
                            self.indicatorBackView.isHidden = false
                            self.indicatorLabel.isHidden = false
                            
                            let date = Date()
                            if (date > paymentDeadLine){
//                            if(false){
                                formatter.dateFormat = "aHH:mm"
                                formatter.amSymbol = "上午"
                                formatter.pmSymbol = "下午"
                                formatter.locale = Locale(identifier: "zh_Hant_TW")
                                let time = formatter.string(from: orderDeadLine)
                                let alertStr = "\(time)無法付款，明日請早"
                                let alert = UIAlertController(title: "超過付款時間", message: alertStr, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                                    (action: UIAlertAction!) -> () in
                                    self.dismiss(animated: true, completion: nil)
                                }))
                                self.tableView.isUserInteractionEnabled = true
                                self.indicatorBackView.isHidden = true
                                self.indicatorLabel.isHidden = true
                                self.activityIndicator.stopAnimating()
                                UIApplication.shared.endIgnoringInteractionEvents()
                                self.present(alert, animated: true)
                            }else{
                                let paymentTextFields = pwAttempt.textFields![0] as UITextField
                                paymentTextFields.isSecureTextEntry = true
                                paymentTextFields.keyboardType = UIKeyboardType.numberPad
                                //timeStamp = String(Int(Date().timeIntervalSince1970))
                                payment_pw = paymentTextFields.text!
                                let dismissAction = UIAlertAction(title: "OK", style: .default, handler: {
                                    (action: UIAlertAction!) -> () in
                                    self.dismiss(animated: true, completion: nil)
                                })
                                AF.request("\(dsURL("payment_self"))&target=true&order_id=\(orderInfo[0].id!)&password=\(payment_pw)").responseData{ response in
                                    if response.error != nil {              //internetErr
                                        let errorAlert = UIAlertController(title: "Bad Internet.", message: "Please check your internet connection and retry.", preferredStyle: .alert)
                                        errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                                            (action: UIAlertAction!) -> () in
                                            logout()
                                            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                                        }))
                                        self.tableView.isUserInteractionEnabled = true
                                        self.indicatorBackView.isHidden = true
                                        self.indicatorLabel.isHidden = true
                                        self.activityIndicator.stopAnimating()
                                        UIApplication.shared.endIgnoringInteractionEvents()
                                        self.present(errorAlert, animated: true, completion: nil)
                                    }
                                    let responseStr = String(data: response.data!, encoding: .utf8)!            //parseStr
                                    print(responseStr)
                                    if responseStr == ""{               //empty str
                                        let alert = UIAlertController(title: "請重新登入", message: "您已經登出", preferredStyle: UIAlertController.Style.alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                                            (action: UIAlertAction!) -> () in
                                            logout()
                                            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                                        }))
                                        self.present(alert, animated: true, completion: nil)
                                    }else if responseStr.contains("denied"){                //no permission to act
                                        let errorAlert = UIAlertController(title: "Error", message: "請嘗試重新登入", preferredStyle: .alert)
                                        errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                                            (action: UIAlertAction!) -> () in
                                            logout()
                                            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                                        }))
                                        self.present(errorAlert, animated: true, completion: nil)
                                    }else if responseStr.contains("wrong"){                //wrong payment password
                                        let errorAlert = UIAlertController(title: "Error", message: "請確認密碼是否正確", preferredStyle: .alert)
                                        errorAlert.addAction(dismissAction)
                                        self.present(errorAlert, animated: true, completion: nil)
                                    }else if responseStr.contains("punish"){                //too many times
                                        let errorAlert = UIAlertController(title: "Error", message: "您輸入錯誤太多次，請稍候(約六十秒後)再試。", preferredStyle: .alert)
                                        errorAlert.addAction(dismissAction)
                                        self.present(errorAlert, animated: true, completion: nil)
                                    }else if responseStr.contains("Unable") || responseStr.contains("dead") ||  responseStr.contains("expired"){                //too many times
                                        let errorAlert = UIAlertController(title: "Error", message: "未成功付款，請聯絡開發人員", preferredStyle: .alert)
                                        errorAlert.addAction(dismissAction)
                                        self.present(errorAlert, animated: true, completion: nil)
                                    }else{                                                  //payment success, return menu, update
                                        do{
                                            _ = try JSONSerialization.jsonObject(with: response.data!)
                                            let oldBalance = balance
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
                                                        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                                                    }))
                                                    self.present(alert, animated: true, completion: nil)
                                                }
                                            }catch let error{
                                                print(error)
                                                let errorAlert = UIAlertController(title: "Bad Internet.", message: "Please check your internet connection and retry.", preferredStyle: .alert)
                                                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                                                    (action: UIAlertAction!) -> () in
                                                    logout()
                                                    self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                                                }))
                                                self.present(errorAlert, animated: true, completion: nil)
                                            }
                                            if (oldBalance - Int(ConfirmFood.cost)!) != balance{
                                                
                                                let error = NSError(domain: "dinnersystem.error.balanceNotCorresponding", code: 1313, userInfo: nil)
                                                let errorAlert = UIAlertController(title: "Error", message: "未成功付款，請聯絡開發人員", preferredStyle: .alert)
                                                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                                                    (action: UIAlertAction!) -> () in
                                                    self.dismiss(animated: true, completion: nil)
                                                }))
                                                self.present(errorAlert, animated: true, completion: nil)
                                                Crashlytics.sharedInstance().recordError(error)
                                            }
                                            let alert = UIAlertController(title: "繳款完成", message: "請注意付款狀況，實際情況仍以頁面為主", preferredStyle: .alert)
                                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                                                (action: UIAlertAction!) -> () in
                                                self.dismiss(animated: true, completion: nil)
                                            }))
                                            self.present(alert, animated: true, completion: nil)
                                        }catch let error{
                                            Crashlytics.sharedInstance().recordError(error)
                                            print(String(data: response.data!, encoding: .utf8)!)
                                            print(error)
                                            let errorAlert = UIAlertController(title: "Error", message: "未成功付款，請聯絡開發人員", preferredStyle: .alert)
                                            errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                                                (action: UIAlertAction!) -> () in
                                                self.dismiss(animated: true, completion: nil)
                                            }))
                                            self.present(errorAlert, animated: true, completion: nil)
                                        }
                                    }
                                    self.tableView.isUserInteractionEnabled = true
                                    self.indicatorBackView.isHidden = true
                                    self.indicatorLabel.isHidden = true
                                    self.activityIndicator.stopAnimating()
                                    UIApplication.shared.endIgnoringInteractionEvents()
                                }}
                        })
                        pwAttempt.addAction(sendAction)
                        pwAttempt.addTextField{
                            (textfield:UITextField!) -> Void in
                            textfield.isSecureTextEntry = true
                            textfield.placeholder = "請輸入付款密碼, 預設為身分證字號後四碼"
                            textfield.keyboardType = .numberPad
                        }
                        pwAttempt.addAction(UIAlertAction(title: "取消", style: .cancel, handler: {
                            (action: UIAlertAction) -> () in
                            self.tableView.isUserInteractionEnabled = true
                        }))
                        self.present(pwAttempt, animated: true)
                    }else{
                        self.indicatorBackView.isHidden = true
                        self.indicatorLabel.isHidden = true
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        let alert = UIAlertController(title: "點餐成功", message: "訂單編號\(orderInfo[0].id!),請記得付款！", preferredStyle: .actionSheet)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                            (action: UIAlertAction!) -> () in
                            self.dismiss(animated: true, completion: nil)
                        }))
                        self.feedbackGenerator.notificationOccurred(.success)
                        self.present(alert, animated: true)
                    }
                case "Error":
                    let alert = UIAlertController(title: "Unexpected Error", message: "發生了不知名的錯誤。請嘗試重新登入，或嘗試重新開啟程式，若持續發生問題，請通知開發人員！", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                case "limitExceed":
                    let alert = UIAlertController(title: "餐點已售完", message: "您的訂單中似乎有一或多項餐點已售完", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        (action: UIAlertAction!) -> () in
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
        return 4
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
                if self.payBool != nil && self.orderTime != "" {
                    self.enablePay()
                }
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
                if self.payBool != nil && self.orderTime != "" {
                    self.enablePay()
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
                    if self.payBool != nil && self.orderTime != "" {
                        self.enablePay()
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
                if self.payBool != nil && self.orderTime != "" {
                    self.enablePay()
                }
            }))
            self.present(alert, animated: true, completion: nil)
            self.tableView.deselectRow(at: indexPath, animated: true)
        } else if indexPath.section == 3{
            //orderButton
            sendOrder(orderString: orderTime, isPay: payBool!)
            
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
}
