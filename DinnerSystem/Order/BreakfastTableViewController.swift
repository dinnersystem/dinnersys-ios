//
//  BreakfastTableViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2018/4/24.
//  Copyright © 2018年 Sean.Inc. All rights reserved.
//

import UIKit
import Alamofire

class BreakfastTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "合作社" + "（餘額: \(balance)）"
        self.tableView.reloadData()
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
        // #warning Incomplete implementation, return the number of rows
        return cafetMenuArr.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "store2Cell", for: indexPath)
        //let backgroundColor = UIColor(red:0.38, green:0.38, blue:0.38, alpha:1.0)
        //let foregroundColor = UIColor(red:0.92, green:0.49, blue:0.63, alpha:1.0)
        let backgroundColor = UIColor.white
        let foregroundColor = UIColor(red:1.00, green:0.27, blue:0.27, alpha:1.0)
        let info = cafetMenuArr[indexPath.row]
        cell.textLabel?.text = info.dishName!
        cell.detailTextLabel?.text = info.dishCost! + "$"
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
        let info = cafetMenuArr[indexPath.row]
        SelectedFood.id = info.dishId!
        SelectedFood.cost = info.dishCost!
        SelectedFood.name = info.dishName!
        self.performSegue(withIdentifier: "cafeteriaSegue", sender: nil)
    }
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}



    
    





