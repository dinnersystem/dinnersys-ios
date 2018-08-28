//
//  MenuTableViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2018/1/7.
//  Copyright © 2018年 Sean.Inc. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    //properties
    var foods = FoodData.genFoodData()
    
}

extension MenuTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath)
        
        let food = foods[indexPath.row]
        cell.textLabel?.text = food.name
        cell.detailTextLabel?.text = food.cost
        return cell
    }
}






































