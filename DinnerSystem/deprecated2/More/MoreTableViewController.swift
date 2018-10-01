//
//  MoreTableViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2018/5/23.
//  Copyright © 2018年 Sean.Inc. All rights reserved.
//

import UIKit
import Alamofire

var counter = 0
class MoreTableViewController: UITableViewController {
    
    @IBOutlet weak var viewOrder: UITableViewCell!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (true){
            self.viewOrder.isUserInteractionEnabled = false
            self.viewOrder.textLabel?.isEnabled = false
        }else{
            self.viewOrder.isUserInteractionEnabled = true
            self.viewOrder.textLabel?.isEnabled = true
        }
        
    }


    @IBAction func logout(_ sender: Any) {
        Alamofire.request("\(dinnersys.url)?cmd=logout/").response{response in}
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2{
            if counter == 10{
                counter = 0
                self.performSegue(withIdentifier: "surprise", sender: self)
            }else{
                counter += 1
                self.performSegue(withIdentifier: "normal", sender: self)
            }
        }
    }

}
