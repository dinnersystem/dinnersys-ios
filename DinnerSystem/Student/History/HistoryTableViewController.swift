//
//  HistoryTableViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2018/9/15.
//  Copyright © 2018年 Sean.Inc. All rights reserved.
//

import UIKit
import Alamofire

class HistoryTableViewController: UITableViewController {
    let date = Date()
    let formatter = DateFormatter()
    var today = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateFormat = "yyyy/MM/dd"
        today = formatter.string(from: date)
        Alamofire.request(dsURL("select_self")+"&esti_start=" + today + "-00:00:00&esti_end=" + today + "-23:59:59").responseData{response in
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
                historyArr = try! decoder.decode([History].self, from: response.data!)
                historyArr.reverse()
                self.tableView.reloadData()
            }
        }
    }

    @IBAction func reloadButton(_ sender: Any) {
        formatter.dateFormat = "yyyy/MM/dd"
        today = formatter.string(from: date)
        Alamofire.request(dsURL("select_self")+"&esti_start=" + today + "-00:00:00&esti_end=" + today + "-23:59:59").responseData{response in
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
                historyArr = try! decoder.decode([History].self, from: response.data!)
                historyArr.reverse()
                self.tableView.reloadData()
            }
        }
    }
    @IBAction func reloadData(_ sender: Any) {
        formatter.dateFormat = "yyyy/MM/dd"
        today = formatter.string(from: date)
        Alamofire.request(dsURL("select_self")+"&esti_start=" + today + "-00:00:00&esti_end=" + today + "-23:59:59").responseData{response in
            let responseStr = String(data: response.data!, encoding: .utf8)
            if response.error != nil {
                let errorAlert = UIAlertController(title: "Error", message: "不知名的錯誤，請注意網路連線狀態或聯絡管理員。", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
            }
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
                historyArr = try! decoder.decode([History].self, from: response.data!)
                historyArr.reverse()
                self.tableView.reloadData()
            }
        }
        self.refreshControl?.endRefreshing()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return historyArr.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCells", for: indexPath)
        var info = historyArr[indexPath.row]
        let range = info.recvDate!.range(of: " ")
        info.recvDate!.removeSubrange((range?.lowerBound)!..<info.recvDate!.endIndex)
        cell.textLabel?.text! = (info.dish?.dishName!)!
        cell.detailTextLabel?.text! = "\((info.dish?.dishCost!)!), \(info.payment![0].paid! == "true" ? "已付款" : "未付款")"
        return cell
    }
 

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
 

    
    // Override to support editing the table view.
    /*override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let info = historyArr[indexPath.row]
        if editingStyle == .delete {
            Alamofire.request("\(dsURL("delete_self"))&order_id=\(info.id!)").responseData{response in
                if response.error != nil {
                    let errorAlert = UIAlertController(title: "Error", message: "不知名的錯誤，請注意網路連線狀態或聯絡管理員。", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(errorAlert, animated: true, completion: nil)
                }
            }
            
            Alamofire.request(dsURL("select_self")).responseData{response in
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
                    historyArr = []
                    let alert = UIAlertController(title: "無點餐紀錄", message: "請嘗試重新整理或進行點餐！", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    self.tableView.reloadData()
                }else{
                    historyArr = try! decoder.decode([History].self, from: response.data!)
                    historyArr.reverse()
                    self.tableView.reloadData()
                }
            }
        }
    }
    */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var info = historyArr[indexPath.row]
        let range = info.recvDate!.range(of: " ")
        info.recvDate!.removeSubrange((range?.lowerBound)!..<info.recvDate!.endIndex)
        let paid:Bool = info.payment![0].paid! == "true" ? true : false
        let alert = UIAlertController(title: "訂餐編號：\(info.id!)\n訂餐日期：\(info.recvDate!)\n餐點金額：\(info.dish!.dishCost!)\n付款狀態：\(paid ? "已付款" : "未付款")\n",
                                      message: "",
                                      preferredStyle: .actionSheet)
        let paidAction = UIAlertAction(title: "已付款者請先退款再行取消", style: .default, handler: nil)
        paidAction.isEnabled = false
        paidAction.setValue(UIColor.gray, forKey: "titleTextColor")
        let unpaidAction = UIAlertAction(title: "取消訂單", style: .destructive, handler: {(action: UIAlertAction!) -> () in
            Alamofire.request("\(dsURL("delete_self"))&order_id=\(info.id!)").responseData{response in
                if response.error != nil {
                    let errorAlert = UIAlertController(title: "Error", message: "不知名的錯誤，請注意網路連線狀態或聯絡管理員。", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(errorAlert, animated: true, completion: nil)
                }
            }
            
            Alamofire.request(dsURL("select_self")).responseData{response in
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
                    historyArr = []
                    let alert = UIAlertController(title: "無點餐紀錄", message: "請嘗試重新整理或進行點餐！", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    self.tableView.reloadData()
                }else{
                    historyArr = try! decoder.decode([History].self, from: response.data!)
                    historyArr.reverse()
                    self.tableView.reloadData()
                }
            }
        })
        let cancelAction = UIAlertAction(title: "返回", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        if paid {
            alert.addAction(paidAction)
        }else{
            alert.addAction(unpaidAction)
        }
        self.present(alert, animated: true)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    

}
