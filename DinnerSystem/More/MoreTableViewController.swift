//
//  MoreTableViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2018/9/16.
//  Copyright © 2018年 Sean.Inc. All rights reserved.
//

import UIKit
import Alamofire

class MoreTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func Logout(_ sender: Any) {
        Alamofire.request("http://dinnersys.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    

}
