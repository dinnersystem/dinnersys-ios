//
//  TaiwanTableViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2018/9/13.
//  Copyright © 2018年 Sean.Inc. All rights reserved.
//

import UIKit

class TaiwanTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let factoryName = selectedMenuArr[0].department?.factory?.name!
        self.navigationItem.title = factoryName! + "（餘額: \(balance)）"
        self.tableView.reloadData()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return selectedMenuArr.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "store1Cell", for: indexPath)
        let info = selectedMenuArr[indexPath.row]
        //let backgroundColor = UIColor(red:0.38, green:0.38, blue:0.38, alpha:1.0)
        //let foregroundColor = UIColor(red:0.92, green:0.49, blue:0.63, alpha:1.0)
        //let backgroundColor = UIColor.white
        let foregroundColor = UIColor(red:1.00, green:0.27, blue:0.27, alpha:1.0)
        cell.textLabel?.text = info.dishName!
        cell.detailTextLabel?.text = "\(info.dishCost!)$"
        if info.bestSeller == "true" {
            cell.detailTextLabel?.text = cell.detailTextLabel!.text! + "，人氣商品！"
            //cell.backgroundColor = backgroundColor
            cell.textLabel?.textColor = foregroundColor
            cell.detailTextLabel?.textColor = foregroundColor
            cell.detailTextLabel?.alpha = 0.8
            //cell.layer.borderWidth = 5.0
            //cell.layer.borderColor = foregroundColor.cgColor
        }else{
            //cell.layer.borderColor = UIColor.white.cgColor
            //cell.backgroundColor = UIColor.white
            if #available(iOS 13.0, *) {
                if(traitCollection.userInterfaceStyle == .light){
                    cell.textLabel?.textColor = UIColor.darkText
                    cell.detailTextLabel?.textColor = UIColor.darkText
                }else{
                    cell.textLabel?.textColor = UIColor.white
                    cell.detailTextLabel?.textColor = UIColor.white
                }
            } else {
                cell.textLabel?.textColor = UIColor.darkText
                cell.detailTextLabel?.textColor = UIColor.darkText
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = selectedMenuArr[indexPath.row]
        SelectedFood.cost = info.dishCost!
        SelectedFood.id = info.dishId!
        SelectedFood.name = info.dishName!
        ConfirmFood.fID = info.department!.factory!.id!
        self.performSegue(withIdentifier: "taiwanSegue", sender: nil)
    }
    

}
