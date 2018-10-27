//
//  adminHistoryTableViewController.swift
//  DinnerSystemBeta
//
//  Created by Sean on 2018/9/23.
//  Copyright © 2018年 Sean.Inc. All rights reserved.
//

import UIKit
import Alamofire
import TrueTime

//&esti_start=\(currentDate)-00:00:00&esti_end=\(currentDate)-23:59:59

class adminHistoryTableViewController: UITableViewController {
    
    // MARK: - Declaration
    @IBOutlet var totalLabel: UILabel!
    @IBOutlet var send: UIButton!
    let decoder = JSONDecoder()
    var unpaidTotal = 0
    var adminPaidArr:[adminHistory] = []
    var adminUnpaidArr:[adminHistory] = []
    var paidTotal = 0
    
    var activityIndicator = UIActivityIndicatorView()
    var indicatorBackView = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //date init
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let currentDate = formatter.string(from: date)
        //activityIndicator init
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
        //load start
        UIApplication.shared.beginIgnoringInteractionEvents()
        self.activityIndicator.startAnimating()
        self.indicatorBackView.isHidden = false
        //mainRecieveData
        Alamofire.request("\(dsURL("select_class"))&esti_start=\(currentDate)-00:00:00&esti_end=\(currentDate)-23:59:59").responseData{response in
            if response.error != nil {              //responseErr
                let errorAlert = UIAlertController(title: "Error", message: "不知名的錯誤，請注意網路連線狀態或聯絡管理員。", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                    (action: UIAlertAction!) -> () in
                    Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                    self.dismiss(animated: true, completion: nil)
                }))
                if self.unpaidTotal == 0{           //set total as 0
                    self.send.isEnabled = false
                }
                self.totalLabel.text = "尚未上傳的訂單總額：\(self.unpaidTotal)，已上傳總額：\(self.paidTotal)"
                self.present(errorAlert, animated: true, completion: nil)
            }
            let responseStr = String(data: response.data!, encoding: .utf8)     //parseString
            if responseStr == ""{                       //blank string
                let alert = UIAlertController(title: "請重新登入", message: "您已經登出", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                    (action: UIAlertAction!) -> () in
                    Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }else if responseStr == "[]"{               //blank Array
                let alert = UIAlertController(title: "無點餐紀錄", message: "請嘗試重新整理或進行點餐！", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                if self.unpaidTotal == 0{               //set total as 0
                    self.send.isEnabled = false
                }
                self.totalLabel.text = "尚未上傳的訂單總額：\(self.unpaidTotal)，已上傳總額：\(self.paidTotal)"
                self.present(alert, animated: true, completion: nil)
            }else{                                      //parse JSON
                //adminHistArr = try! self.decoder.decode([adminHistory].self, from: response.data!)
                do{
                    adminHistArr = try self.decoder.decode([adminHistory].self, from: response.data!)
                }catch let error{
                    print(error)
                    let alert = UIAlertController(title: "請重新登入", message: "發生了不知名的錯誤，若重複發生此錯誤請務必通知開發人員！", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        (action: UIAlertAction!) -> () in
                        Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                //reset variables
                self.unpaidTotal = 0
                self.paidTotal = 0
                for item in adminHistArr{               //ask if paid, list paid and unpaid
                    if item.payment![1].paid! == "true"{               //payment[0]=markAsPaid,[1]=uploaded
                        self.adminPaidArr.append(item)
                        self.paidTotal += Int(item.dish!.dishCost!)!
                    }else{
                        self.adminUnpaidArr.append(item)
                        self.unpaidTotal += Int(item.dish!.dishCost!)!
                    }
                }
                if self.unpaidTotal == 0{               //check if unsent
                    self.send.isEnabled = false
                }else{
                    self.send.isEnabled = true
                }
                //set label
                self.totalLabel.text = "尚未上傳的訂單總額：\(self.unpaidTotal)，已上傳總額：\(self.paidTotal)"
                self.totalLabel.sizeToFit()
                self.tableView.reloadData()
            }
            //load finish
            self.indicatorBackView.isHidden = true
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
        
    }
    // MARK: - ReloadData
    @IBAction func refresh(_ sender: Any) {                 //pullToRefresh
        
        //startResresh
        UIApplication.shared.beginIgnoringInteractionEvents()
        self.activityIndicator.startAnimating()
        self.indicatorBackView.isHidden = false
        
        //load date
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let currentDate = formatter.string(from: date)
        //mainRequst
        Alamofire.request("\(dsURL("select_class"))&esti_start=\(currentDate)-00:00:00&esti_end=\(currentDate)-23:59:59").responseData{response in
            if response.error != nil {                  //internetRequstError
                let errorAlert = UIAlertController(title: "Error", message: "不知名的錯誤，請注意網路連線狀態或聯絡管理員。", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                    (action: UIAlertAction!) -> () in
                    Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                    self.dismiss(animated: true, completion: nil)
                }))
                if self.unpaidTotal == 0{               //set total as 0
                    self.send.isEnabled = false
                }
                self.totalLabel.text = "尚未上傳的訂單總額：\(self.unpaidTotal)，已上傳總額：\(self.paidTotal)"
                self.present(errorAlert, animated: true, completion: nil)
            }
            let responseStr = String(data: response.data!, encoding: .utf8)             //parse string
            if responseStr == ""{               //blank string  
                let alert = UIAlertController(title: "請重新登入", message: "您已經登出", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                    (action: UIAlertAction!) -> () in
                    Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }else if responseStr == "[]"{       //blank array
                let alert = UIAlertController(title: "無點餐紀錄", message: "請嘗試重新整理或進行點餐！", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.unpaidTotal = 0
                if self.unpaidTotal == 0{       //reset total
                    self.send.isEnabled = false
                }
                self.totalLabel.text = "尚未上傳的訂單總額：\(self.unpaidTotal)，已上傳總額：\(self.paidTotal)"
                self.present(alert, animated: true, completion: nil)
            }else{                              //parse JSON
                //adminHistArr = try! self.decoder.decode([adminHistory].self, from: response.data!)
                do{
                    adminHistArr = try self.decoder.decode([adminHistory].self, from: response.data!)
                }catch let error{
                    print(error)
                    let alert = UIAlertController(title: "請重新登入", message: "發生了不知名的錯誤，若重複發生此錯誤請務必通知開發人員！", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        (action: UIAlertAction!) -> () in
                        Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                self.unpaidTotal = 0
                self.paidTotal = 0
                for item in adminHistArr{
                    if item.payment![1].paid! == "true"{           //ask paid
                        self.adminPaidArr.append(item)
                        self.paidTotal += Int(item.dish!.dishCost!)!
                    }else{
                        self.adminUnpaidArr.append(item)
                        self.unpaidTotal += Int(item.dish!.dishCost!)!
                    }
                }
                if self.unpaidTotal == 0{                           //check total
                    self.send.isEnabled = false
                }else{
                    self.send.isEnabled = true
                }
                //set text
                self.totalLabel.text = "尚未上傳的訂單總額：\(self.unpaidTotal)，已上傳總額：\(self.paidTotal)"
                self.totalLabel.sizeToFit()
                self.tableView.reloadData()
            }
        }
        self.refreshControl?.endRefreshing()
    }
    
    @IBAction func refreshButton(_ sender: Any) {           //reloadButton
        //date
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let currentDate = formatter.string(from: date)
        //beginIndicator
        UIApplication.shared.beginIgnoringInteractionEvents()
        self.activityIndicator.startAnimating()
        self.indicatorBackView.isHidden = false
        //MainReq
        Alamofire.request("\(dsURL("select_class"))&esti_start=\(currentDate)-00:00:00&esti_end=\(currentDate)-23:59:59").responseData{response in
            if response.error != nil {                  //internetErr
                let errorAlert = UIAlertController(title: "Error", message: "不知名的錯誤，請注意網路連線狀態或聯絡管理員。", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                    (action: UIAlertAction!) -> () in
                    Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(errorAlert, animated: true, completion: nil)
            }
            let responseStr = String(data: response.data!, encoding: .utf8)             //parseString
            if responseStr == ""{               //emptyStr
                let alert = UIAlertController(title: "請重新登入", message: "您已經登出", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                    (action: UIAlertAction!) -> () in
                    Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }else if responseStr == "[]"{       //emptyArr
                let alert = UIAlertController(title: "無點餐紀錄", message: "請嘗試重新整理或進行點餐！", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.unpaidTotal = 0
                if self.unpaidTotal == 0{
                    self.send.isEnabled = false
                }
                self.totalLabel.text = "尚未上傳的訂單總額：\(self.unpaidTotal)，已上傳總額：\(self.paidTotal)"
                self.present(alert, animated: true, completion: nil)
            }else{                              //parseJSON
                //adminHistArr = try! self.decoder.decode([adminHistory].self, from: response.data!)
                do{
                    adminHistArr = try self.decoder.decode([adminHistory].self, from: response.data!)
                }catch let error{
                    print(error)
                    let alert = UIAlertController(title: "請重新登入", message: "發生了不知名的錯誤，若重複發生此錯誤請務必通知開發人員！", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        (action: UIAlertAction!) -> () in
                        Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                self.unpaidTotal = 0
                self.paidTotal = 0
                for item in adminHistArr{                   //ask if paid
                    if item.payment![1].paid! == "true"{
                        self.adminPaidArr.append(item)
                        self.paidTotal += Int(item.dish!.dishCost!)!
                    }else{
                        self.adminUnpaidArr.append(item)
                        self.unpaidTotal += Int(item.dish!.dishCost!)!
                    }
                }
                if self.unpaidTotal == 0{                   //check total
                    self.send.isEnabled = false
                }else{
                    self.send.isEnabled = true
                }
                //set label
                self.totalLabel.text = "尚未上傳的訂單總額：\(self.unpaidTotal)，已上傳總額：\(self.paidTotal)"
                self.totalLabel.sizeToFit()
                self.tableView.reloadData()
            }
            //stop refresh
            self.indicatorBackView.isHidden = true
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    // MARK: - UploadContent
    @IBAction func sendButton(_ sender: Any) {
        for selectInfo in adminUnpaidArr{               //each in unpaid
            Alamofire.request("\(dsURL("payment_dm"))&target=true&order_id=\(selectInfo.id!)").responseData{ response in
                if response.error != nil {              //internetError
                    let errorAlert = UIAlertController(title: "Error", message: "不知名的錯誤，請注意網路連線狀態或聯絡管理員。", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        (action: UIAlertAction!) -> () in
                        Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                        self.dismiss(animated: true, completion: nil)
                    }))
                    if self.unpaidTotal == 0{           //set as 0
                        self.send.isEnabled = false
                    }
                    self.totalLabel.text = "尚未上傳的訂單總額：\(self.unpaidTotal)，已上傳總額：\(self.paidTotal)"
                    self.present(errorAlert, animated: true, completion: nil)
                }
                let responseStr = String(data: response.data!, encoding: .utf8)!            //parse String
                if responseStr == ""{               //emptyString
                    let alert = UIAlertController(title: "請重新登入", message: "您已經登出", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        (action: UIAlertAction!) -> () in
                        Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }else if responseStr.contains("denied"){                                    //permission not allowed
                    let errorAlert = UIAlertController(title: "Error", message: "請嘗試重新登入", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        (action: UIAlertAction!) -> () in
                        Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(errorAlert, animated: true, completion: nil)
                }else{                      //success
                    let successAlert = UIAlertController(title: "上傳成功", message: "請確認付款狀態！", preferredStyle: .alert)
                    successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(successAlert, animated: true)
                }
            }
        }
        //get date
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let currentDate = formatter.string(from: date)
        //startRefresh
        UIApplication.shared.beginIgnoringInteractionEvents()
        self.activityIndicator.startAnimating()
        self.indicatorBackView.isHidden = false
        //mainReq
        Alamofire.request("\(dsURL("select_class"))&esti_start=\(currentDate)-00:00:00&esti_end=\(currentDate)-23:59:59").responseData{response in
            if response.error != nil {          //internetErr
                let errorAlert = UIAlertController(title: "Error", message: "不知名的錯誤，請注意網路連線狀態或聯絡管理員。", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                    (action: UIAlertAction!) -> () in
                    Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                    self.dismiss(animated: true, completion: nil)
                }))
                if self.unpaidTotal == 0{       //set as 0
                    self.send.isEnabled = false
                }
                //set label
                self.totalLabel.text = "尚未上傳的訂單總額：\(self.unpaidTotal)，已上傳總額：\(self.paidTotal)"
                self.present(errorAlert, animated: true, completion: nil)
            }                                                               
            let responseStr = String(data: response.data!, encoding: .utf8)                 //parseString
            if responseStr == ""{           //emptyStr
                let alert = UIAlertController(title: "請重新登入", message: "您已經登出", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                    (action: UIAlertAction!) -> () in
                    Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }else if responseStr == "{}"{            //emptyArr
                let alert = UIAlertController(title: "無點餐紀錄", message: "請嘗試重新整理或進行點餐！", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                if self.unpaidTotal == 0{
                    self.send.isEnabled = false
                }
                self.totalLabel.text = "尚未上傳的訂單總額：\(self.unpaidTotal)，已上傳總額：\(self.paidTotal)"
                self.present(alert, animated: true, completion: nil)
            }else{                                  //parseJSON
                //adminHistArr = try! self.decoder.decode([adminHistory].self, from: response.data!)
                do{
                    adminHistArr = try self.decoder.decode([adminHistory].self, from: response.data!)
                }catch let error{
                    print(error)
                    let alert = UIAlertController(title: "請重新登入", message: "發生了不知名的錯誤，若重複發生此錯誤請務必通知開發人員！", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        (action: UIAlertAction!) -> () in
                        Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                self.unpaidTotal = 0
                self.paidTotal = 0
                for item in adminHistArr{           //ask paid
                    if item.payment![1].paid! == "true"{
                        self.adminPaidArr.append(item)
                        self.paidTotal += Int(item.dish!.dishCost!)!
                    }else{
                        self.adminUnpaidArr.append(item)
                        self.unpaidTotal += Int(item.dish!.dishCost!)!
                    }
                }
                if self.unpaidTotal == 0{           //ask total
                    self.send.isEnabled = false
                }else{
                    self.send.isEnabled = true
                }
                //set label
                self.totalLabel.text = "尚未上傳的訂單總額：\(self.unpaidTotal)，已上傳總額：\(self.paidTotal)"
                self.totalLabel.sizeToFit()
                self.tableView.reloadData()
            }
            //stop refresh
            self.indicatorBackView.isHidden = true
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adminHistArr.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "adminHistoryCell", for: indexPath) as! adminHistoryCell
        let histInfo = adminHistArr[indexPath.row]
        let lastSeat = String((histInfo.user?.seatNo!.suffix(2))!)
        cell.mainText?.text! = (histInfo.user?.name!)! + "(" + lastSeat + ")"
        cell.detailText?.text! = ((histInfo.dish?.dishName!)!) + "(" + (histInfo.dish?.dishCost!)! + "$)"
        cell.paidText?.text! = "\((histInfo.payment![0].paid! == "true" ? "已付款" : "未付款"))，\((histInfo.payment![1].paid! == "true" ? "已上傳" : "未上傳"))"
        return cell
    }
    // MARK: - Selected Cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectInfo = adminHistArr[indexPath.row]                //declare
        let range = selectInfo.recvDate!.range(of: " ")             //declare range when space
        selectInfo.recvDate!.removeSubrange((range?.lowerBound)!..<selectInfo.recvDate!.endIndex)               //remove date after space(00:00:00)
        let alert = UIAlertController(title: "", message: "訂餐編號：\(selectInfo.id!)\n訂餐日期：\(selectInfo.recvDate!)\n餐點金額：\(selectInfo.dish!.dishCost!)$\n付款狀態：\(selectInfo.payment![0].paid! == "true" ? "已付款" : "未付款")\n", preferredStyle: .actionSheet)      //mainMenu
        let cancelAct = UIAlertAction(title: "返回", style: .cancel, handler: nil)        //back
        let paymentAct = UIAlertAction(title: "標記為已付款", style: .default, handler: {                 //Mark as paid
            (action: UIAlertAction!) -> () in
            self.tableView.isUserInteractionEnabled = false                 //prevent from bugging
            Alamofire.request("\(dsURL("payment_usr"))&target=true&order_id=\(selectInfo.id!)").responseData{ response in
                if response.error != nil {              //internetErr
                    let errorAlert = UIAlertController(title: "Error", message: "不知名的錯誤，請注意網路連線狀態或聯絡管理員。", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        (action: UIAlertAction!) -> () in
                        Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(errorAlert, animated: true, completion: nil)
                }
                let responseStr = String(data: response.data!, encoding: .utf8)!            //parseStr
                if responseStr == ""{               //empty str
                    let alert = UIAlertController(title: "請重新登入", message: "您已經登出", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        (action: UIAlertAction!) -> () in
                        Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }else if responseStr.contains("denied"){                //no permission to act
                    let errorAlert = UIAlertController(title: "Error", message: "請嘗試重新登入", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        (action: UIAlertAction!) -> () in
                        Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(errorAlert, animated: true, completion: nil)
                }else{              //payment success, return menu, update
                    //date init
                    let date = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy/MM/dd"
                    let currentDate = formatter.string(from: date)
                    //begin Indicator
                    UIApplication.shared.beginIgnoringInteractionEvents()
                    self.activityIndicator.startAnimating()
                    self.indicatorBackView.isHidden = false
                    //mainReq
                    Alamofire.request("\(dsURL("select_class"))&esti_start=\(currentDate)-00:00:00&esti_end=\(currentDate)-23:59:59").responseData{response in
                        if response.error != nil {  //interErr
                            let errorAlert = UIAlertController(title: "Error", message: "不知名的錯誤，請注意網路連線狀態或聯絡管理員。", preferredStyle: .alert)
                            errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                                (action: UIAlertAction!) -> () in
                                Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                                self.dismiss(animated: true, completion: nil)
                            }))
                            self.present(errorAlert, animated: true, completion: nil)
                        }
                        let responseStr = String(data: response.data!, encoding: .utf8)         //parseStr
                        if responseStr == ""{           //emptyStr
                            let alert = UIAlertController(title: "請重新登入", message: "您已經登出", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                                (action: UIAlertAction!) -> () in
                                Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                                self.dismiss(animated: true, completion: nil)
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }else if responseStr == "{}"{       //emptyArr
                            let alert = UIAlertController(title: "無點餐紀錄", message: "請嘗試重新整理或進行點餐！", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }else{          //parseJSON
                            //adminHistArr = try! self.decoder.decode([adminHistory].self, from: response.data!)
                            do{
                                adminHistArr = try self.decoder.decode([adminHistory].self, from: response.data!)
                            }catch let error{
                                print(error)
                                let alert = UIAlertController(title: "請重新登入", message: "發生了不知名的錯誤，若重複發生此錯誤請務必通知開發人員！", preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                                    (action: UIAlertAction!) -> () in
                                    Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                                    self.dismiss(animated: true, completion: nil)
                                }))
                                self.present(alert, animated: true, completion: nil)
                            }
                            self.unpaidTotal = 0
                            self.paidTotal = 0
                            for item in adminHistArr{               //ask if paid
                                if item.payment![1].paid! == "true"{
                                    self.adminPaidArr.append(item)
                                    self.paidTotal += Int(item.dish!.dishCost!)!
                                }else{
                                    self.adminUnpaidArr.append(item)
                                    self.unpaidTotal += Int(item.dish!.dishCost!)!
                                }
                            }
                            if self.unpaidTotal == 0{           //check total
                                self.send.isEnabled = false
                            }else{
                                self.send.isEnabled = true
                            }
                            //set Label
                            self.totalLabel.text = "尚未上傳的訂單總額：\(self.unpaidTotal)，已上傳總額：\(self.paidTotal)"
                            self.totalLabel.sizeToFit()
                            self.tableView.reloadData()
                        }
                        //stop Indicator
                        self.indicatorBackView.isHidden = true
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                    }
                }
            }
            //stopRequest
            self.tableView.isUserInteractionEnabled = true
        })
        let unpaymentAct = UIAlertAction(title: "標記為未付款", style: .destructive, handler: {                   //unpaidAct
            (action: UIAlertAction!) -> () in
            self.tableView.isUserInteractionEnabled = false
            //mainreq
            Alamofire.request("\(dsURL("payment_usr"))&target=false&order_id=\(selectInfo.id!)").responseData{ response in
                if response.error != nil {//interneterr
                    let errorAlert = UIAlertController(title: "Error", message: "不知名的錯誤，請注意網路連線狀態或聯絡管理員。", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        (action: UIAlertAction!) -> () in
                        Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(errorAlert, animated: true, completion: nil)
                }
                let responseStr = String(data: response.data!, encoding: .utf8)!//parseStr
                if responseStr == ""{       //emptyStr
                    let alert = UIAlertController(title: "請重新登入", message: "您已經登出", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        (action: UIAlertAction!) -> () in
                        Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }else if responseStr.contains("denied"){                //no permission to act
                    let errorAlert = UIAlertController(title: "Error", message: "請嘗試重新登入", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        (action: UIAlertAction!) -> () in
                        Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(errorAlert, animated: true, completion: nil)
                }else{              //success, reload
                    //date  init
                    let date = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy/MM/dd"
                    let currentDate = formatter.string(from: date)
                    //startRefresh
                    UIApplication.shared.beginIgnoringInteractionEvents()
                    self.activityIndicator.startAnimating()
                    self.indicatorBackView.isHidden = false
                    //mainReq
                    Alamofire.request("\(dsURL("select_class"))&esti_start=\(currentDate)-00:00:00&esti_end=\(currentDate)-23:59:59").responseData{response in
                        if response.error != nil {                      //interErr
                            let errorAlert = UIAlertController(title: "Error", message: "不知名的錯誤，請注意網路連線狀態或聯絡管理員。", preferredStyle: .alert)
                            errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                                (action: UIAlertAction!) -> () in
                                Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                                self.dismiss(animated: true, completion: nil)
                            }))
                            self.present(errorAlert, animated: true, completion: nil)
                        }
                        let responseStr = String(data: response.data!, encoding: .utf8)             //parseStr
                        if responseStr == ""{               //emptyStr
                            let alert = UIAlertController(title: "請重新登入", message: "您已經登出", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                                (action: UIAlertAction!) -> () in
                                Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                                self.dismiss(animated: true, completion: nil)
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }else if responseStr == "{}"{           //emptyArr
                            let alert = UIAlertController(title: "無點餐紀錄", message: "請嘗試重新整理或進行點餐！", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }else{           //parseJson
                            //adminHistArr = try! self.decoder.decode([adminHistory].self, from: response.data!)
                            do{
                                adminHistArr = try self.decoder.decode([adminHistory].self, from: response.data!)
                            }catch let error{
                                print(error)
                                let alert = UIAlertController(title: "請重新登入", message: "發生了不知名的錯誤，若重複發生此錯誤請務必通知開發人員！", preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                                    (action: UIAlertAction!) -> () in
                                    Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                                    self.dismiss(animated: true, completion: nil)
                                }))
                                self.present(alert, animated: true, completion: nil)
                            }
                            self.unpaidTotal = 0
                            self.paidTotal = 0
                            for item in adminHistArr{           //ask paid
                                if item.payment![1].paid! == "true"{
                                    self.adminPaidArr.append(item)
                                    self.paidTotal += Int(item.dish!.dishCost!)!
                                }else{
                                    self.adminUnpaidArr.append(item)
                                    self.unpaidTotal += Int(item.dish!.dishCost!)!
                                }
                            }
                            //check total
                            if self.unpaidTotal == 0{
                                self.send.isEnabled = false
                            }else{
                                self.send.isEnabled = true
                            }
                            //set Label
                            self.totalLabel.text = "尚未上傳的訂單總額：\(self.unpaidTotal)，已上傳總額：\(self.paidTotal)"
                            self.totalLabel.sizeToFit()
                            self.tableView.reloadData()
                        }
                        //stop refresh
                        self.indicatorBackView.isHidden = true
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        
                    }
                }
            }
            //stop refresh
            self.tableView.isUserInteractionEnabled = true
        } )
        let delOrderAct = UIAlertAction(title: "刪除訂單", style: .destructive, handler: {              //Delete Order
            (action: UIAlertAction!) -> () in
            self.tableView.isUserInteractionEnabled = false
            //mainReq
            Alamofire.request("\(dsURL("delete_dm"))&order_id=\(selectInfo.id!)").responseData{ response in   
                if response.error != nil {          //internetErr
                    let errorAlert = UIAlertController(title: "Error", message: "不知名的錯誤，請注意網路連線狀態或聯絡管理員。", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        (action: UIAlertAction!) -> () in
                        Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(errorAlert, animated: true, completion: nil)
                }
                let responseStr = String(data: response.data!, encoding: .utf8)!                //parseStr
                if responseStr == ""{           //blankStr
                    let alert = UIAlertController(title: "請重新登入", message: "您已經登出", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        (action: UIAlertAction!) -> () in
                        Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }else if responseStr.contains("denied"){            //noPermission  to act
                    let errorAlert = UIAlertController(title: "Error", message: "請嘗試重新登入", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        (action: UIAlertAction!) -> () in
                        Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(errorAlert, animated: true, completion: nil)
                }else if responseStr.contains("Invalid"){           //invalid req
                    let errorAlert = UIAlertController(title: "發生錯誤", message: "請稍後再試", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        (action: UIAlertAction!) -> () in
                        Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(errorAlert, animated: true, completion: nil)
                }else{                  //success, reload
                    //date init
                    let date = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy/MM/dd"
                    let currentDate = formatter.string(from: date)
                    //start indicator
                    UIApplication.shared.beginIgnoringInteractionEvents()
                    self.activityIndicator.startAnimating()
                    self.indicatorBackView.isHidden = false
                    //mainreq
                    Alamofire.request("\(dsURL("select_class"))&esti_start=\(currentDate)-00:00:00&esti_end=\(currentDate)-23:59:59").responseData{response in
                        if response.error != nil {          //interErr
                            let errorAlert = UIAlertController(title: "Error", message: "不知名的錯誤，請注意網路連線狀態或聯絡管理員。", preferredStyle: .alert)
                            errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                                (action: UIAlertAction!) -> () in
                                Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                                self.dismiss(animated: true, completion: nil)
                            }))
                            self.present(errorAlert, animated: true, completion: nil)
                        }
                        let responseStr = String(data: response.data!, encoding: .utf8)         //parseStr
                        if responseStr == ""{                   //emptyStr
                            let alert = UIAlertController(title: "請重新登入", message: "您已經登出", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                                (action: UIAlertAction!) -> () in
                                Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                                self.dismiss(animated: true, completion: nil)
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }else if responseStr == "{}"{           //emptyArr
                            let alert = UIAlertController(title: "無點餐紀錄", message: "請嘗試重新整理或進行點餐！", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }else{              //parseJson
                            //adminHistArr = try! self.decoder.decode([adminHistory].self, from: response.data!)
                            do{
                                adminHistArr = try self.decoder.decode([adminHistory].self, from: response.data!)
                            }catch let error{
                                print(error)
                                let alert = UIAlertController(title: "請重新登入", message: "發生了不知名的錯誤，若重複發生此錯誤請務必通知開發人員！", preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                                    (action: UIAlertAction!) -> () in
                                    Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                                    self.dismiss(animated: true, completion: nil)
                                }))
                                self.present(alert, animated: true, completion: nil)
                            }
                            self.unpaidTotal = 0
                            self.paidTotal = 0
                            for item in adminHistArr{           //ask paid
                                if item.payment![1].paid! == "true"{
                                    self.adminPaidArr.append(item)
                                    self.paidTotal += Int(item.dish!.dishCost!)!
                                }else{
                                    self.adminUnpaidArr.append(item)
                                    self.unpaidTotal += Int(item.dish!.dishCost!)!
                                }
                            }
                            if self.unpaidTotal == 0{           //check total
                                self.send.isEnabled = false
                            }else{
                                self.send.isEnabled = true
                            }
                            //set label
                            self.totalLabel.text = "尚未上傳的訂單總額：\(self.unpaidTotal)，已上傳總額：\(self.paidTotal)"
                            self.totalLabel.sizeToFit()
                            self.tableView.reloadData()
                        }
                        //stop indicator
                        self.indicatorBackView.isHidden = true
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        
                    }
                }
            }
            self.tableView.isUserInteractionEnabled = true
        })
        let paidAction = UIAlertAction(title: "已上傳訂單，無法標記為未付款或刪除訂單。", style: .default, handler: nil)            //paidAct
        //paidAct init
        paidAction.isEnabled = false
        paidAction.setValue(UIColor.gray, forKey: "titleTextColor")
        
        
        
        alert.addAction(cancelAct)
        if(selectInfo.payment![1].paid! == "true"){         //ask if upload
            alert.addAction(paidAction)          //you cannot do anything
        }else if selectInfo.payment![0].paid! == "true"{    //ask if marked as paid
            alert.addAction(unpaymentAct)       //mark as unpaid
        }else{                                              //unpaid and unmarked
            alert.addAction(paymentAct)         //mark as paid
        }
        if selectInfo.payment![1].paid! != "true"{          //ask if unuploaded
            alert.addAction(delOrderAct)        //delete order
        }
        self.present(alert, animated: true)     //present mainMenu
        self.tableView.deselectRow(at: indexPath, animated: true)           //deselect Row
    }
    
}
