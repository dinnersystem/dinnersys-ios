//
//  TableViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2018/5/4.
//  Copyright © 2018年 Sean.Inc. All rights reserved.
//

import UIKit
import Alamofire

class HistoryTableViewController: UITableViewController {

    @IBAction func reloadData(_ sender: Any) {
        Alamofire.request("\(dinnersys.url)?cmd=select_self").responseData{response in
            let str = String(data: response.data!, encoding: .utf8)
            if str == ""{
                let alert = UIAlertController(title: "請重新登入", message: "您已經登出", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                    (action: UIAlertAction!) -> () in
                    Alamofire.request("http://dinnersys.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }else
            if str == "[]" {
                let alert = UIAlertController(title: "您尚未點餐", message: "請嘗試重新整理或進行點餐！", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                let data = response.data!
                let decoder = JSONDecoder()
                histArr = try! decoder.decode([History].self, from: data)
                self.tableView.reloadData()
            }
            self.tableView.reloadData()
        }
        refreshControl?.endRefreshing()
    }
    
    
    @IBAction func reloadButton(_ sender: Any) {
        Alamofire.request("\(dinnersys.url)?cmd=select_self").responseData{response in
            let str = String(data: response.data!, encoding: .utf8)
            if str == ""{
                let alert = UIAlertController(title: "請重新登入", message: "您已經登出", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                    (action: UIAlertAction!) -> () in
                    Alamofire.request("http://dinnersys.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }else
            if str == "[]" {
                let alert = UIAlertController(title: "您尚未點餐", message: "請嘗試重新整理或進行點餐！", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                let data = response.data!
                let decoder = JSONDecoder()
                histArr = try! decoder.decode([History].self, from: data)
                self.tableView.reloadData()
            }
            self.tableView.reloadData()
        }
    
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Alamofire.request("\(dinnersys.url)?cmd=select_self").responseData{response in
            let str = String(data: response.data!, encoding: .utf8)
            if str == ""{
                let alert = UIAlertController(title: "請重新登入", message: "您已經登出", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                    (action: UIAlertAction!) -> () in
                    Alamofire.request("http://dinnersys.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }else
            if str == "[]" {
                let alert = UIAlertController(title: "您尚未點餐", message: "請嘗試重新整理或進行點餐！", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                let data = response.data!
                let decoder = JSONDecoder()
                histArr = try! decoder.decode([History].self, from: data)
                self.tableView.reloadData()
            }
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return histArr.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let info = histArr[indexPath.row]
        cell.textLabel?.text = info.dish!.dishName!
        cell.detailTextLabel?.text = "\(info.recvDate!), \(info.payment![1].paid! ? "已付" : "未付")"
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = histArr[indexPath.row]
        
        let sheet = UIAlertController(title: "訂餐編號：\(info.id!)餐點名稱：\(info.dish!.dishName!)餐點金額：\(info.dish!.dishCost!)付款狀況：\(info.payment![1].paid! ? "已付" : "未付")取餐時間：\(info.recvDate!)", message: "", preferredStyle: .actionSheet)
        let delete = UIAlertAction(title: "取消訂單", style: .destructive, handler: {
            (action: UIAlertAction!) -> () in
            Alamofire.request("\(dinnersys.url)?cmd=delete_order&id=\(info.id!)").responseData{response in}
            Alamofire.request("\(dinnersys.url)?cmd=select_self").responseData{response in
                let str = String(data: response.data!, encoding: .utf8)
                if str == "[]" {
                    let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    let data = response.data!
                    let decoder = JSONDecoder()
                    histArr = try! decoder.decode([History].self, from: data)
                }
                self.tableView.reloadData()
            }
        })
        let cancel = UIAlertAction(title: "返回", style: .cancel, handler: nil)
        let compDel = UIAlertAction(title: "已付費請先退款後再行取消", style: .destructive, handler: nil)
        compDel.isEnabled = false
        compDel.setValue(UIColor.gray, forKey: "titleTextColor")
        sheet.addAction(cancel)
        if info.payment![1].paid! {
            sheet.addAction(compDel)
        }else{
            sheet.addAction(delete)
        }
        self.present(sheet, animated: true, completion: nil)
    }



}
