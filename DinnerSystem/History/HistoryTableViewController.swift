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

    override func viewDidLoad() {
        super.viewDidLoad()
        let decoder = JSONDecoder()
        Alamofire.request(dsURL("select_self")).responseData{response in
            let responseStr = String(data: response.data!, encoding: .utf8)
            if responseStr == ""{
                let alert = UIAlertController(title: "請重新登入", message: "您已經登出", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                    (action: UIAlertAction!) -> () in
                    Alamofire.request("http://dinnersys.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
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
        cell.detailTextLabel?.text! = "\(info.recvDate!),\(info.payment![0].paid! == "true" ? "已付款" : "未付款")"
        return cell
    }
 

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
 

    

}
