//
//  HistoryTableViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2018/1/29.
//  Copyright © 2018年 Sean.Inc. All rights reserved.
//

import UIKit
import Alamofire

class HistoryTableViewController: UITableViewController {
    @IBAction func reloaddata(_ sender: Any) {
        Alamofire.request("http://dinnersys.ddns.net/dinnersys_beta/backend/backend.php?cmd=show_order&type=self&plugin=yes").responseData { origindata in
        if let data = origindata.result.value {
            let string = String(data: data,encoding: .utf8)
            if string == "{}"{
                let alert = UIAlertController(title: "Error", message: "您是否尚未點餐？若有請重新整理(列表向下拉)！", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                print(data as NSData)
                let decoder = JSONDecoder()
                history = try! decoder.decode([History].self, from: data)
                self.tableView.reloadData()
            }
        }
        else{
            print("i got nothing:\(String(describing: origindata.result.error))")
        }
        }
        refreshControl?.endRefreshing()
    }
    
    @IBAction func refresh(_ sender: Any) {
        Alamofire.request("http://dinnersys.ddns.net/dinnersys_beta/backend/backend.php?cmd=show_order&type=self&plugin=yes").responseData { origindata in
            if let data = origindata.result.value {
                let string = String(data: data,encoding: .utf8)
                if string == "{}"{
                    let alert = UIAlertController(title: "Error", message: "您是否尚未點餐？若有請重新整理(列表向下拉)！", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    print(data as NSData)
                    let decoder = JSONDecoder()
                    history = try! decoder.decode([History].self, from: data)
                    self.tableView.reloadData()
                }
            }
            else{
                print("i got nothing:\(String(describing: origindata.result.error))")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Alamofire.request("http://dinnersys.ddns.net/dinnersys_beta/backend/backend.php?cmd=show_order&date_filter=today&type=self&plugin=yes").responseData { origindata in
            if let data = origindata.result.value {
                let string = String(data: data,encoding: .utf8)
                if string == "{}"{
                    let alert = UIAlertController(title: "Error", message: "您是否尚未點餐？若有請重新整理(列表向下拉)！", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    print(data as NSData)
                    let decoder = JSONDecoder()
                    history = try! decoder.decode([History].self, from: data)
                    self.tableView.reloadData()
                }
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return history.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath)
        let info = history[indexPath.row]
        cell.textLabel?.text = info.dishName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let formatter = DateFormatter()
            let date = Date()
            formatter.dateFormat = "yyyy-MM-dd"
            let currentDate = formatter.string(from: date)
            let info = history[indexPath.row]
            Alamofire.request("http://dinnersys.ddns.net/dinnersys_beta/backend/backend.php?cmd=delete_order&recv_date=\(currentDate)&order_date=2018-02-12&dish_id=\(info.dishId)").responseString {response in
                
            }
        }
    }
  
}
