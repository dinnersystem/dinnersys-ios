//
//  AiJiaTableViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2018/9/14.
//  Copyright © 2018年 Sean.Inc. All rights reserved.
//

import UIKit

class AiJiaTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "愛佳便當" + "（餘額: \(balance)）"
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return aiJiaMenuArr.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "store3Cell", for: indexPath)
        let info = aiJiaMenuArr[indexPath.row]
        cell.textLabel?.text = info.dishName!
        cell.detailTextLabel?.text = "\(info.dishCost!)$"
        let backgroundColor = UIColor(red:0.38, green:0.38, blue:0.38, alpha:1.0)
        let foregroundColor = UIColor(red:0.92, green:0.49, blue:0.63, alpha:1.0)
        if info.bestSeller == "true" {
            cell.detailTextLabel?.text = cell.detailTextLabel!.text! + "，人氣商品！"
            cell.backgroundColor = backgroundColor
            cell.textLabel?.textColor = foregroundColor
            cell.detailTextLabel?.textColor = foregroundColor
            cell.detailTextLabel?.alpha = 0.8
        }else{
            cell.backgroundColor = UIColor.white
            cell.textLabel?.textColor = UIColor.darkText
            cell.detailTextLabel?.textColor = UIColor.darkText
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = aiJiaMenuArr[indexPath.row]
        selectedFood.cost = info.dishCost!
        selectedFood.id = info.dishId!
        selectedFood.name = info.dishName!
        self.performSegue(withIdentifier: "aiJiaSegue", sender: nil)
    }
    
}
