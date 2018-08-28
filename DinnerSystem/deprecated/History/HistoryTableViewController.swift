//
//  HistoryTableViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2018/1/29.
//  Copyright © 2018年 Sean.Inc. All rights reserved.
//

import UIKit
import Alamofire
import UserNotifications

class HistoryTableViewController: UITableViewController {
    @IBAction func reloaddata(_ sender: Any) {
        Alamofire.request("http://dinnersys.ddns.net/dinnersys_beta/backend/backend.php?cmd=show_order&type=self&plugin=yes").responseData { origindata in
        if let data = origindata.result.value {
            let string = String(data: data,encoding: .utf8)
            if string == ""{
                let alert = UIAlertController(title: "請重新登入", message: "您已經登出", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                    (action: UIAlertAction!) -> () in
                    Alamofire.request("http://dinnersys.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }else if string == "{}"{
                let alert = UIAlertController(title: "無點餐紀錄", message: "您是否尚未點餐？若有請重新整理(列表向下拉)！", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                print(data as NSData)
                let decoder = JSONDecoder()
                history = try! decoder.decode([History].self, from: data)
                self.tableView.reloadData()
            }
            
        }
        else{
            print("i got nothing:\(String(describing: origindata.result.error))")
        }
        }
        refreshControl?.endRefreshing()
    }
    
    @IBAction func refresh(_ sender: Any) {
        Alamofire.request("http://dinnersys.ddns.net/dinnersys_beta/backend/backend.php?cmd=show_order&type=self&plugin=yes").responseData { origindata in
            if let data = origindata.result.value {
                let string = String(data: data,encoding: .utf8)
                if string == ""{
                    let alert = UIAlertController(title: "請重新登入", message: "您已經登出", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                        (action: UIAlertAction!) -> () in
                        Alamofire.request("http://dinnersys.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }else
                if string == "{}"{
                    let alert = UIAlertController(title: "無點餐紀錄", message: "您是否尚未點餐？若有請重新整理(列表向下拉)！", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    print(data as NSData)
                    let decoder = JSONDecoder()
                    history = try! decoder.decode([History].self, from: data)
                    self.tableView.reloadData()
                }
            }
            else{
                print("i got nothing:\(String(describing: origindata.result.error))")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Alamofire.request("http://dinnersys.ddns.net/dinnersys_beta/backend/backend.php?cmd=show_order&date_filter=today&type=self&plugin=yes").responseData { origindata in
            if let data = origindata.result.value {
                let string = String(data: data,encoding: .utf8)
                if string == ""{
                    let alert = UIAlertController(title: "請重新登入", message: "您已經登出", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                        (action: UIAlertAction!) -> () in
                        Alamofire.request("http://dinnersys.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }else
                if string == "{}"{
                    let alert = UIAlertController(title: "無點餐紀錄", message: "您是否尚未點餐？若有請重新整理(列表向下拉)！", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    print(data as NSData)
                    let decoder = JSONDecoder()
                    history = try! decoder.decode([History].self, from: data)
                    self.tableView.reloadData()
                }
            }
            else{
                print("i got nothing:\(String(describing: origindata.result.error))")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return history.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath)
        let info = history[indexPath.row]
        cell.textLabel?.text = info.dishName
        cell.detailTextLabel?.text = info.recvDate
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath ) {
        let info = history[indexPath.row]
        let delAlert = UIAlertController(title: "訂單資訊", message: "訂單名稱：\(info.dishName)\n點餐日期：\(info.orderDate)\n取餐日期：\(info.recvDate)\n餐點金額：\(info.dishCharge)\n付款狀態：\(info.paidStatus)", preferredStyle: .actionSheet)
        let unpaidAction = UIAlertAction(title: "取消訂單", style: .destructive, handler: {
            (action: UIAlertAction!) -> () in
            Alamofire.request("http://dinnersys.ddns.net/dinnersys_beta/backend/backend.php?cmd=delete_order&recv_date=\(info.recvDate)&order_date=\(info.orderDate)&dish_id=\(info.dishId)").responseData { origindata in
            Alamofire.request("http://dinnersys.ddns.net/dinnersys_beta/backend/backend.php?cmd=show_order&date_filter=today&type=self&plugin=yes").responseData { origindata in
                if let data = origindata.result.value {
                    let string = String(data: data,encoding: .utf8)
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["date:\(info.recvDate)id:\(info.dishId)"])
                    if string == "{}"{
                        history = []
                        let alert = UIAlertController(title: "無點餐紀錄", message: "您是否尚未點餐？若有請重新整理(列表向下拉)！", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        self.tableView.reloadData()
                    }else{
                        print(data as NSData)
                        let decoder = JSONDecoder()
                        history = try! decoder.decode([History].self, from: data)
                        self.tableView.reloadData()
                    }
                }
                else{
                    print("i got nothing:\(String(describing: origindata.result.error))")
                }
            }
            }})
        let cancelAction = UIAlertAction(title: "返回", style: .cancel, handler: nil)
        let paidAction = UIAlertAction(title: "已付款之訂單請先申請退款", style: .destructive, handler: nil)
        paidAction.setValue(UIColor.gray, forKey: "titleTextColor")
        paidAction.isEnabled = false
        if info.paidStatus == "您尚未付款"{
            delAlert.addAction(unpaidAction)
        }else{
            delAlert.addAction(paidAction)
        }
        delAlert.addAction(cancelAction)
        self.present(delAlert, animated: true, completion: {
            self.tableView.deselectRow(at: indexPath, animated: true)
        })
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

   
}
