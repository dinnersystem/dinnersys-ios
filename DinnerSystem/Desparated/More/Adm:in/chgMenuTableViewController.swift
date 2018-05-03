//
//  chgMenuTableViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2018/2/28.
//  Copyright © 2018年 Sean.Inc. All rights reserved.
//

import UIKit
import Alamofire

class chgMenuTableViewController: UITableViewController {

    @IBAction func reload(_ sender: Any) {
        Alamofire.request("http://dinnersys.ddns.net/dinnersys_beta/backend/backend.php?cmd=show_menu&plugin=yes").responseData { origindata in
            if let data = origindata.result.value {
                print(data as NSData)
                let decoder = JSONDecoder()
                arrRes = try! decoder.decode([Food].self, from: data)
                self.tableView.reloadData()
            }
            else{
                print("i got nothing:\(String(describing: origindata.result.error))")
            }
        }
        refreshControl?.endRefreshing()
}
    override func viewDidLoad() {
        super.viewDidLoad()
        Alamofire.request("http://dinnersys.ddns.net/dinnersys_beta/backend/backend.php?cmd=show_menu&plugin=yes").responseData { origindata in
            if let data = origindata.result.value {
                print(data as NSData)
                let decoder = JSONDecoder()
                arrRes = try! decoder.decode([Food].self, from: data)
                self.tableView.reloadData()
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
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrRes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chgMenuCell", for: indexPath)
        let menu = arrRes[indexPath.row]
        cell.textLabel?.text = menu.dishName!
        cell.detailTextLabel?.text = "\(menu.dishCost)$"
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menu = arrRes[indexPath.row]
        chgSelOrder.name = menu.dishName!
        chgSelOrder.cost = menu.dishCost
        chgSelOrder.num = menu.dishId!
}


}





