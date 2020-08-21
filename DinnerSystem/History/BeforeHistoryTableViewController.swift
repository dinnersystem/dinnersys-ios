//
//  BeforeHistoryTableViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2019/8/15.
//  Copyright © 2019 DinnerSystem Team. All rights reserved.
//

import UIKit

class BeforeHistoryTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }
    
    @IBAction func backToMain(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return oldHistoryArr.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OldHistoryCell", for: indexPath)
        var info = oldHistoryTableList[indexPath.row]
        let range = info.recvDate!.range(of: " ")
        info.recvDate!.removeSubrange((range?.lowerBound)!..<info.recvDate!.endIndex)
        cell.textLabel?.text! = oldHistoryArr[indexPath.row].dish!.count > 1 ? "自訂套餐(\(oldHistoryArr[indexPath.row].dish!.count)樣)" : (info.dishName!)
        cell.detailTextLabel?.text! = "\(info.recvDate!), \(info.money!.charge!)$, \(info.money!.payment![0].paid! == "true" ? "已付款" : "未付款")"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var info = oldHistoryTableList[indexPath.row]
        info.recvDate = String(info.recvDate!.dropLast(3))
        let paid:Bool = info.money!.payment![0].paid! == "true"
        let alert = UIAlertController(title: "訂餐編號：\(info.id!)\n餐點內容：\(info.dishName!)\n取餐日期：\(info.recvDate!)\n餐點金額：\(info.money!.charge!)$\n付款狀態：\(paid ? "已付款" : "未付款")\n", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "返回", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
