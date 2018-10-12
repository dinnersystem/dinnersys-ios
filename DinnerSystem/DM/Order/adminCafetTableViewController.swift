//
//  adminCafetTableViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2018/10/4.
//  Copyright © 2018 Sean.Inc. All rights reserved.
//

import UIKit

class adminCafetTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "adminStore3Cell", for: indexPath)
        
        let info = cafetMenuArr[indexPath.row]
        cell.textLabel?.text = info.dishName!
        cell.detailTextLabel?.text = info.dishCost! + "$"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = cafetMenuArr[indexPath.row]
        selectedFood.id = info.dishId!
        selectedFood.cost = info.dishCost!
        selectedFood.name = info.dishName!
        self.performSegue(withIdentifier: "dmCafetSegue", sender: nil)
    }

}
