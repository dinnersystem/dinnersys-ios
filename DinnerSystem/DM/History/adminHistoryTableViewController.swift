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
    
    let decoder = JSONDecoder()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let currentDate = formatter.string(from: date)
        Alamofire.request("\(dsURL("select_class"))&esti_start=\(currentDate)-00:00:00&esti_end=\(currentDate)-23:59:59").responseData{response in
            if response.error != nil {
                let errorAlert = UIAlertController(title: "Error", message: "不知名的錯誤，請注意網路連線狀態或聯絡管理員。", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
            }
            let responseStr = String(data: response.data!, encoding: .utf8)
            if responseStr == ""{
                let alert = UIAlertController(title: "請重新登入", message: "您已經登出", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                    (action: UIAlertAction!) -> () in
                    Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }else if responseStr == "[]"{
                let alert = UIAlertController(title: "無點餐紀錄", message: "請嘗試重新整理或進行點餐！", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                adminHistArr = try! self.decoder.decode([adminHistory].self, from: response.data!)
                self.tableView.reloadData()
            }
        }
        
    }
    @IBAction func refresh(_ sender: Any) {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let currentDate = formatter.string(from: date)
        Alamofire.request("\(dsURL("select_class"))&esti_start=\(currentDate)-00:00:00&esti_end=\(currentDate)-23:59:59").responseData{response in
            if response.error != nil {
                let errorAlert = UIAlertController(title: "Error", message: "不知名的錯誤，請注意網路連線狀態或聯絡管理員。", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
            }
            let responseStr = String(data: response.data!, encoding: .utf8)
            if responseStr == ""{
                let alert = UIAlertController(title: "請重新登入", message: "您已經登出", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                    (action: UIAlertAction!) -> () in
                    Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }else if responseStr == "[]"{
                let alert = UIAlertController(title: "無點餐紀錄", message: "請嘗試重新整理或進行點餐！", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                adminHistArr = try! self.decoder.decode([adminHistory].self, from: response.data!)
                self.tableView.reloadData()
            }
        }
        self.refreshControl?.endRefreshing()
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let currentDate = formatter.string(from: date)
        Alamofire.request("\(dsURL("select_class"))&esti_start=\(currentDate)-00:00:00&esti_end=\(currentDate)-23:59:59").responseData{response in
            if response.error != nil {
                let errorAlert = UIAlertController(title: "Error", message: "不知名的錯誤，請注意網路連線狀態或聯絡管理員。", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
            }
            let responseStr = String(data: response.data!, encoding: .utf8)
            if responseStr == ""{
                let alert = UIAlertController(title: "請重新登入", message: "您已經登出", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                    (action: UIAlertAction!) -> () in
                    Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }else if responseStr == "[]"{
                let alert = UIAlertController(title: "無點餐紀錄", message: "請嘗試重新整理或進行點餐！", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                adminHistArr = try! self.decoder.decode([adminHistory].self, from: response.data!)
                self.tableView.reloadData()
            }
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
        cell.paidText?.text! = (histInfo.payment![0].paid! == "true" ? "已付款" : "未付款")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectInfo = adminHistArr[indexPath.row]
        let range = selectInfo.recvDate!.range(of: " ")
        selectInfo.recvDate!.removeSubrange((range?.lowerBound)!..<selectInfo.recvDate!.endIndex)
        let alert = UIAlertController(title: "", message: "訂餐編號：\(selectInfo.id!)\n訂餐日期：\(selectInfo.recvDate!)\n餐點金額：\(selectInfo.dish!.dishCost!)$\n付款狀態：\(selectInfo.payment![0].paid! == "true" ? "已付款" : "未付款")\n", preferredStyle: .actionSheet)
        let cancelAct = UIAlertAction(title: "返回", style: .cancel, handler: nil)
        let paymentAct = UIAlertAction(title: "標記為已付款", style: .default, handler: {
            (action: UIAlertAction!) -> () in
            self.tableView.isUserInteractionEnabled = false
            Alamofire.request("\(dsURL("payment_usr"))&target=true&order_id=\(selectInfo.id!)").responseData{ response in
                if response.error != nil {
                    let errorAlert = UIAlertController(title: "Error", message: "不知名的錯誤，請注意網路連線狀態或聯絡管理員。", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(errorAlert, animated: true, completion: nil)
                }
                let responseStr = String(data: response.data!, encoding: .utf8)!
                if responseStr == ""{
                    let alert = UIAlertController(title: "請重新登入", message: "您已經登出", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        (action: UIAlertAction!) -> () in
                        Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }else if responseStr.contains("denied"){
                    let errorAlert = UIAlertController(title: "Error", message: "請嘗試重新登入", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        (action: UIAlertAction!) -> () in
                        Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(errorAlert, animated: true, completion: nil)
                }else{
                    let date = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy/MM/dd"
                    let currentDate = formatter.string(from: date)
                    Alamofire.request("\(dsURL("select_class"))&esti_start=\(currentDate)-00:00:00&esti_end=\(currentDate)-23:59:59").responseData{response in
                        if response.error != nil {
                            let errorAlert = UIAlertController(title: "Error", message: "不知名的錯誤，請注意網路連線狀態或聯絡管理員。", preferredStyle: .alert)
                            errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(errorAlert, animated: true, completion: nil)
                        }
                        let responseStr = String(data: response.data!, encoding: .utf8)
                        if responseStr == ""{
                            let alert = UIAlertController(title: "請重新登入", message: "您已經登出", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                                (action: UIAlertAction!) -> () in
                                Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                                self.dismiss(animated: true, completion: nil)
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }else if responseStr == "{}"{
                            let alert = UIAlertController(title: "無點餐紀錄", message: "請嘗試重新整理或進行點餐！", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }else{
                            adminHistArr = try! self.decoder.decode([adminHistory].self, from: response.data!)
                            self.tableView.reloadData()
                        }
                    }
                }
            }
            self.tableView.isUserInteractionEnabled = true
        })
        let unpaymentAct = UIAlertAction(title: "標記為未付款", style: .destructive, handler: {
            (action: UIAlertAction!) -> () in
            self.tableView.isUserInteractionEnabled = false
            Alamofire.request("\(dsURL("payment_usr"))&target=false&order_id=\(selectInfo.id!)").responseData{ response in
                if response.error != nil {
                    let errorAlert = UIAlertController(title: "Error", message: "不知名的錯誤，請注意網路連線狀態或聯絡管理員。", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(errorAlert, animated: true, completion: nil)
                }
                let responseStr = String(data: response.data!, encoding: .utf8)!
                if responseStr == ""{
                    let alert = UIAlertController(title: "請重新登入", message: "您已經登出", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        (action: UIAlertAction!) -> () in
                        Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }else if responseStr.contains("denied"){
                    let errorAlert = UIAlertController(title: "Error", message: "請嘗試重新登入", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        (action: UIAlertAction!) -> () in
                        Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(errorAlert, animated: true, completion: nil)
                }else{
                    let date = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy/MM/dd"
                    let currentDate = formatter.string(from: date)
                    Alamofire.request("\(dsURL("select_class"))&esti_start=\(currentDate)-00:00:00&esti_end=\(currentDate)-23:59:59").responseData{response in
                        if response.error != nil {
                            let errorAlert = UIAlertController(title: "Error", message: "不知名的錯誤，請注意網路連線狀態或聯絡管理員。", preferredStyle: .alert)
                            errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(errorAlert, animated: true, completion: nil)
                        }
                        let responseStr = String(data: response.data!, encoding: .utf8)
                        if responseStr == ""{
                            let alert = UIAlertController(title: "請重新登入", message: "您已經登出", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                                (action: UIAlertAction!) -> () in
                                Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                                self.dismiss(animated: true, completion: nil)
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }else if responseStr == "{}"{
                            let alert = UIAlertController(title: "無點餐紀錄", message: "請嘗試重新整理或進行點餐！", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }else{
                            adminHistArr = try! self.decoder.decode([adminHistory].self, from: response.data!)
                            self.tableView.reloadData()
                        }
                    }
                }
            }
            self.tableView.isUserInteractionEnabled = true
        } )
        let delOrderAct = UIAlertAction(title: "刪除訂單", style: .destructive, handler: {
            (action: UIAlertAction!) -> () in
            self.tableView.isUserInteractionEnabled = false
            Alamofire.request("\(dsURL("delete_dm"))&order_id=\(selectInfo.id!)").responseData{ response in
                if response.error != nil {
                    let errorAlert = UIAlertController(title: "Error", message: "不知名的錯誤，請注意網路連線狀態或聯絡管理員。", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(errorAlert, animated: true, completion: nil)
                }
                let responseStr = String(data: response.data!, encoding: .utf8)!
                if responseStr == ""{
                    let alert = UIAlertController(title: "請重新登入", message: "您已經登出", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        (action: UIAlertAction!) -> () in
                        Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }else if responseStr.contains("denied"){
                    let errorAlert = UIAlertController(title: "Error", message: "請嘗試重新登入", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        (action: UIAlertAction!) -> () in
                        Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(errorAlert, animated: true, completion: nil)
                }else{
                    let date = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy/MM/dd"
                    let currentDate = formatter.string(from: date)
                    Alamofire.request("\(dsURL("select_class"))&esti_start=\(currentDate)-00:00:00&esti_end=\(currentDate)-23:59:59").responseData{response in
                        if response.error != nil {
                            let errorAlert = UIAlertController(title: "Error", message: "不知名的錯誤，請注意網路連線狀態或聯絡管理員。", preferredStyle: .alert)
                            errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(errorAlert, animated: true, completion: nil)
                        }
                        let responseStr = String(data: response.data!, encoding: .utf8)
                        if responseStr == ""{
                            let alert = UIAlertController(title: "請重新登入", message: "您已經登出", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                                (action: UIAlertAction!) -> () in
                                Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                                self.dismiss(animated: true, completion: nil)
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }else if responseStr == "{}"{
                            let alert = UIAlertController(title: "無點餐紀錄", message: "請嘗試重新整理或進行點餐！", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }else{
                            adminHistArr = try! self.decoder.decode([adminHistory].self, from: response.data!)
                            self.tableView.reloadData()
                        }
                    }
                }
            }
            self.tableView.isUserInteractionEnabled = true
        })
        alert.addAction(cancelAct)
        if(selectInfo.payment![0].paid! == "true"){
            alert.addAction(unpaymentAct)
        }else{
            alert.addAction(paymentAct)
        }
        alert.addAction(delOrderAct) 
        self.present(alert, animated: true)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
