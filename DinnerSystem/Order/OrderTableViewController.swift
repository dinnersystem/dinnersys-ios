//
//  OrderTableViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2018/1/8.
//  Copyright © 2018年 Sean.Inc. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

var filterData: Data!
var filterString = ""

class OrderTableViewController: UITableViewController {
    
    override func viewDidLoad() {
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRes.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        
        let menu = arrRes[indexPath.row]
        cell.textLabel?.text = menu.dishName!
        cell.detailTextLabel?.text = "\(menu.dishCost)$"
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menu = arrRes[indexPath.row]
        selOrder.name = menu.dishName!
        selOrder.cost = menu.dishCost
        selOrder.num = menu.dishId!
    }
    
}

class OrderViewController: UIViewController {
    @IBOutlet var alert: UILabel!
    @IBOutlet var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        alert.text = "你選擇的是\(selOrder.name)，共\(selOrder.cost)元。\n確定請選擇點餐日期後按點餐。（日期範圍：該週星期一到五。）"
        alert.sizeToFit()
    }
    
    @IBAction func confirm(_ sender: Any) {
        //Server-side
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.string(from: datePicker.date)
        print("user:\(user.id), date:\(date) dish_id:\(selOrder.num).")
        let urlWithOrder = dinnerSys.str + "backend/backend.php?dish_id=\(selOrder.num)&cmd=make_order&date=\(date)"
        let orderURL = URL(string: urlWithOrder)
        var request = URLRequest(url: orderURL!)
        request.httpMethod = "GET"
        let success_image = UIImage(named: "ap-done")
        let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            if error != nil{
                print("error:\(String(describing: error))")
                let alert = UIAlertController(title: "Error", message: "Unexpected Error.\n Please Restart The App.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            let responseString = String(data: data!, encoding: String.Encoding.utf8)
            if (responseString?.contains("wrong dish id"))!{
                let alert = UIAlertController(title: "錯誤", message: "Please reopen the app and login again.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else{
                if (responseString?.contains("Invalid date"))!{
                    let alert = UIAlertController(title: "錯誤", message: "請選擇正確日期", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    let alert = UIAlertController(title: "點餐成功", message: "", preferredStyle: .actionSheet)
                    let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                        (action: UIAlertAction!) -> () in
                        self.navigationController?.popViewController(animated: true)
                    })
                    alert.addImage(image: success_image!)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
            }
            print("response:\(String(describing: responseString))")
        }
        task.resume()
    }
    
    
}
