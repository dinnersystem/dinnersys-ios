//
//  HistoryTableViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2018/9/15.
//  Copyright © 2018年 Sean.Inc. All rights reserved.
//

import UIKit
import Alamofire
import Crashlytics

class HistoryTableViewController: UITableViewController {
    let date = Date()
    let formatter = DateFormatter()
    var today = ""
    var activityIndicator = UIActivityIndicatorView()
    var indicatorBackView = UIView()
    
    
    //+"&esti_start=" + today + "-00:00:00&esti_end=" + today + "-23:59:59"
    private func fetchData(){
        formatter.dateFormat = "yyyy/MM/dd"
        today = formatter.string(from: date)
        print(today)
        historyTableList = []
        Alamofire.request(dsURL("get_money")).responseString{ response in
            if response.error != nil {
                let errorAlert = UIAlertController(title: "Error", message: "不知名的錯誤，請注意網路連線狀態或聯絡管理員。", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                    (action: UIAlertAction!) -> () in
                    logout()
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(errorAlert, animated: true, completion: nil)
            }else{
                print(response.result.value!)
                let string = response.result.value!.trimmingCharacters(in: .whitespacesAndNewlines)
                balance = Int(string)!
                self.navigationItem.title = "檢視今日訂單" + "（餘額: \(balance)）"
            }
        }
        Alamofire.request(dsURL("select_self")+"&esti_start=" + today + "-00:00:00&esti_end=" + today + "-23:59:59" + "&history=true").responseData{response in
            if response.error != nil {
                let errorAlert = UIAlertController(title: "Error", message: "不知名的錯誤，請注意網路連線狀態或聯絡管理員。", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                    (action: UIAlertAction!) -> () in
                    logout()
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(errorAlert, animated: true, completion: nil)
            }
            let responseStr = String(data: response.data!, encoding: .utf8)
            if responseStr == ""{
                let alert = UIAlertController(title: "請重新登入", message: "您已經登出", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                    (action: UIAlertAction!) -> () in
                    logout()
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }else if responseStr == "{}"{
                let alert = UIAlertController(title: "無點餐紀錄", message: "請嘗試重新整理或進行點餐！", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                //historyArr = try! decoder.decode([History].self, from: response.data!)
                do{
                    print(String(data: response.data!, encoding: .utf8)!)
                    historyArr = try decoder.decode([History].self, from: response.data!)
                    historyArr.reverse()
                    
                    for order in historyArr{
                        if order.dish!.count == 1{
                            let tmp = HistoryList(id: order.id, dishName: order.dish![0].dishName, dishCost: order.dish![0].dishCost, recvDate: order.recvDate, money: order.money)
                            historyTableList.append(tmp)
                        }else{
                            var dName = ""
                            var dCost = 0
                            for dish in order.dish!{
                                dName += "\(dish.dishName!)+"
                                dCost += Int(dish.dishCost!)!
                            }
                            dName = String(dName.dropLast(1))
                            let tmp = HistoryList(id: order.id, dishName: dName, dishCost: String(dCost), recvDate: order.recvDate, money: order.money)
                            historyTableList.append(tmp)
                        }
                    }
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
                self.tableView.reloadData()
            }
            self.indicatorBackView.isHidden = true
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateFormat = "yyyy/MM/dd"
        today = formatter.string(from: date)
        
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
        fetchData()
        self.navigationItem.title = "檢視今日訂單" + "（餘額: \(balance)）"
    }
    
    @IBAction func reloadButton(_ sender: Any) {
        formatter.dateFormat = "yyyy/MM/dd"
        today = formatter.string(from: date)
        UIApplication.shared.beginIgnoringInteractionEvents()
        self.activityIndicator.startAnimating()
        self.indicatorBackView.isHidden = false
        fetchData()
    }
    @IBAction func reloadData(_ sender: Any) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        self.activityIndicator.startAnimating()
        self.indicatorBackView.isHidden = false
        fetchData()
        self.refreshControl?.endRefreshing()
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return historyTableList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCells", for: indexPath)
        var info = historyTableList[indexPath.row]
        let range = info.recvDate!.range(of: " ")
        info.recvDate!.removeSubrange((range?.lowerBound)!..<info.recvDate!.endIndex)
        cell.textLabel?.text! = historyArr[indexPath.row].dish!.count > 1 ? "自訂套餐(\(historyArr[indexPath.row].dish!.count)樣)" : (info.dishName!)
        cell.detailTextLabel?.text! = "\(info.money!.charge!)$, \(info.money!.payment![0].paid! == "true" ? "已付款" : "未付款")"
        return cell
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var info = historyTableList[indexPath.row]
        info.recvDate = String(info.recvDate!.dropLast(3))
        let paid:Bool = info.money!.payment![0].paid! == "true" ? true : false
        let alert = UIAlertController(title: "訂餐編號：\(info.id!)\n餐點內容：\(info.dishName!)\n訂餐日期：\(info.recvDate!)\n餐點金額：\(info.money!.charge!)$\n付款狀態：\(paid ? "已付款" : "未付款")\n",
            message: "付款請於上午十點半前付款！",
            preferredStyle: .actionSheet)
        let paidAction = UIAlertAction(title: "已付款者請聯絡合作社取消", style: .default, handler: nil)
        paidAction.isEnabled = false
        paidAction.setValue(UIColor.gray, forKey: "titleTextColor")
        let unpaidAction = UIAlertAction(title: "取消訂單", style: .destructive, handler: {(action: UIAlertAction!) -> () in
            Alamofire.request("\(dsURL("delete_self"))&order_id=\(info.id!)").responseData{response in
                if response.error != nil {
                    let errorAlert = UIAlertController(title: "Error", message: "不知名的錯誤，請注意網路連線狀態或聯絡管理員。", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        (action: UIAlertAction!) -> () in
                        logout()
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(errorAlert, animated: true, completion: nil)
                }
                let responseStr = String(data: response.data!, encoding: .utf8)!
                if responseStr == ""{
                    let alert = UIAlertController(title: "請重新登入", message: "您已經登出", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        (action: UIAlertAction!) -> () in
                        logout()
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }else if responseStr.contains("denied"){
                    let errorAlert = UIAlertController(title: "Error", message: "請嘗試重新登入", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        (action: UIAlertAction!) -> () in
                        logout()
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(errorAlert, animated: true, completion: nil)
                }else if responseStr.contains("Invalid"){
                    let errorAlert = UIAlertController(title: "發生錯誤", message: "請稍後再試", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        (action: UIAlertAction!) -> () in
                        logout()
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(errorAlert, animated: true, completion: nil)
                }
            }
            UIApplication.shared.beginIgnoringInteractionEvents()
            self.activityIndicator.startAnimating()
            self.indicatorBackView.isHidden = false
            self.fetchData()
        })
        
        let paymentAction = UIAlertAction(title: "以學生證付款(餘額：\(balance))", style: .default, handler: {(action: UIAlertAction!) -> () in
            
            self.tableView.isUserInteractionEnabled = false                 //prevent from bugging
            var hash = ""
            var payment_pw = ""
            var timeStamp = String(Int(Date().timeIntervalSince1970))
            let pwAttempt = UIAlertController(title: "請輸入繳款密碼", message: "預設為身分證字號後四碼", preferredStyle: .alert)
            let sendAction = UIAlertAction(title: "確認", style: .default, handler: { (action: UIAlertAction!) -> () in
                
                UIApplication.shared.beginIgnoringInteractionEvents()
                self.activityIndicator.startAnimating()
                self.indicatorBackView.isHidden = false
                //time
                let date = Date()
                let calander = Calendar.current
                let lower_bound = calander.date(bySettingHour: 10, minute: 30, second: 0, of: date)
                if date < lower_bound!{
                    let alert = UIAlertController(title: "超過付款時間", message: "早上十點半後無法付款，明日請早", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        (action: UIAlertAction!) -> () in
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.tableView.isUserInteractionEnabled = true
                    self.indicatorBackView.isHidden = true
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.present(alert, animated: true)
                }else{
                    let paymentTextFields = pwAttempt.textFields![0] as UITextField
                    paymentTextFields.isSecureTextEntry = true
                    paymentTextFields.keyboardType = UIKeyboardType.numberPad
                    timeStamp = String(Int(Date().timeIntervalSince1970))
                    payment_pw = paymentTextFields.text!
                    hash = "{\"id\":\"\(info.id!)\",\"usr_id\":\"\(usr)\",\"usr_password\":\"\(pwd)\",\"pmt_password\":\"\(payment_pw)\",\"time\":\"\(timeStamp)\"}".sha512()
                    Alamofire.request("\(dsURL("payment_self"))&target=true&order_id=\(info.id!)&hash=\(hash)").responseData{ response in
                        if response.error != nil {              //internetErr
                            let errorAlert = UIAlertController(title: "Error", message: "不知名的錯誤，請注意網路連線狀態或聯絡管理員。", preferredStyle: .alert)
                            errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                                (action: UIAlertAction!) -> () in
                                logout()
                                self.dismiss(animated: true, completion: nil)
                            }))
                            self.tableView.isUserInteractionEnabled = true
                            self.indicatorBackView.isHidden = true
                            self.activityIndicator.stopAnimating()
                            UIApplication.shared.endIgnoringInteractionEvents()
                            self.present(errorAlert, animated: true, completion: nil)
                        }
                        let responseStr = String(data: response.data!, encoding: .utf8)!            //parseStr
                        if responseStr == ""{               //empty str
                            let alert = UIAlertController(title: "請重新登入", message: "您已經登出", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                                (action: UIAlertAction!) -> () in
                                logout()
                                self.dismiss(animated: true, completion: nil)
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }else if responseStr.contains("denied"){                //no permission to act
                            let errorAlert = UIAlertController(title: "Error", message: "請嘗試重新登入", preferredStyle: .alert)
                            errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                                (action: UIAlertAction!) -> () in
                                logout()
                                self.dismiss(animated: true, completion: nil)
                            }))
                            self.present(errorAlert, animated: true, completion: nil)
                        }else if responseStr.contains("wrong"){                //wrong payment password
                            let errorAlert = UIAlertController(title: "Error", message: "請確認密碼是否正確", preferredStyle: .alert)
                            errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(errorAlert, animated: true, completion: nil)
                        }else if responseStr.contains("punish"){                //too many times
                            let errorAlert = UIAlertController(title: "Error", message: "您輸入錯誤太多次，請稍候(約六十秒後)再試。", preferredStyle: .alert)
                            errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(errorAlert, animated: true, completion: nil)
                        }else if responseStr.contains("Unable"){                //too many times
                            let errorAlert = UIAlertController(title: "Error", message: "未成功付款，請聯絡開發人員", preferredStyle: .alert)
                            errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(errorAlert, animated: true, completion: nil)
                        }else{                                                  //payment success, return menu, update
                            do{
                                _ = try JSONSerialization.jsonObject(with: response.data!)
                                let oldBalance = balance
                                Alamofire.request(dsURL("get_money")).responseString{ response in
                                    if response.error != nil {
                                        let errorAlert = UIAlertController(title: "Error", message: "不知名的錯誤，請注意網路連線狀態或聯絡管理員。", preferredStyle: .alert)
                                        errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                                            (action: UIAlertAction!) -> () in
                                            logout()
                                            self.dismiss(animated: true, completion: nil)
                                        }))
                                        self.present(errorAlert, animated: true, completion: nil)
                                    }else{
                                        print(response.result.value!)
                                        let string = response.result.value!.trimmingCharacters(in: .whitespacesAndNewlines)
                                        balance = Int(string)!
                                    }
                                }
                                if (oldBalance - Int(info.money!.charge!)!) != balance{
                                    let error = NSError(domain: "dinnersystem.error.balanceNotCorresponding", code: 1313, userInfo: nil)
                                    Crashlytics.sharedInstance().recordError(error)
                                }
                                let alert = UIAlertController(title: "繳款完成", message: "請注意付款狀況，實際情況仍以頁面為主", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                self.fetchData()
                                
                                self.present(alert, animated: true, completion: nil)
                            }catch let error{
                                Crashlytics.sharedInstance().recordError(error)
                                print(String(data: response.data!, encoding: .utf8)!)
                                print(error)
                                let errorAlert = UIAlertController(title: "Error", message: "未成功付款，請聯絡開發人員", preferredStyle: .alert)
                                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                self.present(errorAlert, animated: true, completion: nil)
                            }
                        }
                        self.tableView.isUserInteractionEnabled = true
                        self.indicatorBackView.isHidden = true
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
        })
        let cancelAction = UIAlertAction(title: "返回", style: .cancel, handler: nil)
        let brokeAction = UIAlertAction(title: "餘額不足(您只剩\(balance)元)", style: .default, handler: nil)
        brokeAction.isEnabled = false
        brokeAction.setValue(UIColor.gray, forKey: "titleTextColor")
        alert.addAction(cancelAction)
        if paid {
            alert.addAction(paidAction)
        }else if balance >= Int(info.dishCost!)!{
            alert.addAction(paymentAction)
            alert.addAction(unpaidAction)
        }else{
            alert.addAction(brokeAction)
            alert.addAction(unpaidAction)
        }
        self.present(alert, animated: true)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
