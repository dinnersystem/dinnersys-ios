//
//  wedTableViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2018/2/28.
//  Copyright © 2018年 Sean.Inc. All rights reserved.
//

import UIKit
import Alamofire

class wedTableViewController: UITableViewController {

    @IBAction func update(_ sender: Any) {
        Alamofire.request("http://dinnersys.ddns.net/dinnersys_beta/backend/backend.php?cmd=show_order&payment_filter=nothing&date_filter=week&person_filter=class&type=junk&plugin=yes").responseData{response in
            let decoder = JSONDecoder()
            allArr = []
            monArr = []
            tueArr = []
            wedArr = []
            thuArr = []
            friArr = []
            allArr = try! decoder.decode([classOrder].self, from: response.data!)
            for arr in allArr{
                if arr.recvDate == dInfo[0].monday!{
                    monArr.append(arr)
                }
                if arr.recvDate == dInfo[1].tuesday!{
                    tueArr.append(arr)
                }
                if arr.recvDate == dInfo[2].wednesday!{
                    wedArr.append(arr)
                }
                if arr.recvDate == dInfo[3].thursday!{
                    thuArr.append(arr)
                }
                if arr.recvDate == dInfo[4].friday!{
                    friArr.append(arr)
                }
            }
        }
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return wedArr.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wedCell", for: indexPath)
        let menu = wedArr[indexPath.row]
        cell.textLabel?.text = menu.dishName
        cell.detailTextLabel?.text = (menu.user?.userId)! + " " + (menu.user?.userName)! + "," + menu.paidStatus.replacingOccurrences(of: "您", with: "")
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Alamofire.request("http://dinnersys.ddns.net/dinnersys_beta/backend/backend.php?cmd=show_order&payment_filter=nothing&date_filter=week&person_filter=class&type=junk&plugin=yes").responseData{response in
            let decoder = JSONDecoder()
            print ("im here")
            allArr = []
            monArr = []
            tueArr = []
            wedArr = []
            thuArr = []
            friArr = []
            allArr = try! decoder.decode([classOrder].self, from: response.data!)
            for arr in allArr{
                if arr.recvDate == dInfo[0].monday{
                    monArr.append(arr)
                }
                if arr.recvDate == dInfo[1].tuesday{
                    tueArr.append(arr)
                }
                if arr.recvDate == dInfo[2].wednesday{
                    wedArr.append(arr)
                }
                if arr.recvDate == dInfo[3].thursday{
                    thuArr.append(arr)
                }
                if arr.recvDate == dInfo[4].friday{
                    friArr.append(arr)
                }
            }
        }
        let info = wedArr[indexPath.row]
        let statusAlert = UIAlertController(title: "訂單資訊", message: "訂單名稱：\(info.dishName)\n點餐人：\(info.user!.userId)\(info.user!.userName!)\n點餐日期：\(info.orderDate)\n取餐日期：\(info.recvDate)\n餐點金額：\(info.dishCharge)\n付款狀態：\(info.paidStatus)", preferredStyle: .actionSheet)
        let paymentAction = UIAlertAction(title: "完成付款", style: .default, handler: {
            (action: UIAlertAction!) -> () in
            Alamofire.request("http://dinnersys.ddns.net/dinnersys_beta/backend/backend.php?cmd=make_payment&dish_id=\(info.dishId)&user_id=\(info.user!.userId)&recv_date=\(info.recvDate)&order_date=\(info.orderDate)").responseData{response in}
            Alamofire.request("http://dinnersys.ddns.net/dinnersys_beta/backend/backend.php?cmd=show_order&payment_filter=nothing&date_filter=week&person_filter=class&type=junk&plugin=yes").responseData{response in
                let decoder = JSONDecoder()
                allArr = []
                monArr = []
                tueArr = []
                wedArr = []
                thuArr = []
                friArr = []
                allArr = try! decoder.decode([classOrder].self, from: response.data!)
                for arr in allArr{
                    if arr.recvDate == dInfo[0].monday{
                        monArr.append(arr)
                    }
                    if arr.recvDate == dInfo[1].tuesday{
                        tueArr.append(arr)
                    }
                    if arr.recvDate == dInfo[2].wednesday{
                        wedArr.append(arr)
                    }
                    if arr.recvDate == dInfo[3].thursday{
                        thuArr.append(arr)
                    }
                    if arr.recvDate == dInfo[4].friday{
                        friArr.append(arr)
                    }
                }
            }
            tableView.reloadData()
        })
        let cancelAction = UIAlertAction(title: "取消訂單", style: .destructive, handler: {
            (action: UIAlertAction!) -> () in
            Alamofire.request("http://dinnersys.ddns.net/dinnersys_beta/backend/backend.php?cmd=delete_order&recv_date=\(info.recvDate)&order_date=\(info.orderDate)&dish_id=\(info.dishId)").responseData { origindata in
                Alamofire.request("http://dinnersys.ddns.net/dinnersys_beta/backend/backend.php?cmd=show_order&payment_filter=nothing&date_filter=week&person_filter=class&type=junk&plugin=yes").responseData { origindata in
                    if let data = origindata.result.value {
                        let string = String(data: data,encoding: .utf8)
                        if string == "{}"{
                            wedArr = []
                            let alert = UIAlertController(title: "無點餐紀錄", message: "是否無人點餐？若有請重新整理(列表向下拉)！", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            self.tableView.reloadData()
                        }else{
                            Alamofire.request("http://dinnersys.ddns.net/dinnersys_beta/backend/backend.php?cmd=show_order&payment_filter=nothing&date_filter=week&person_filter=class&type=junk&plugin=yes").responseData{response in
                                let decoder = JSONDecoder()
                                allArr = []
                                monArr = []
                                tueArr = []
                                wedArr = []
                                thuArr = []
                                friArr = []
                                allArr = try! decoder.decode([classOrder].self, from: response.data!)
                                for arr in allArr{
                                    if arr.recvDate == dInfo[0].monday{
                                        monArr.append(arr)
                                    }
                                    if arr.recvDate == dInfo[1].tuesday{
                                        tueArr.append(arr)
                                    }
                                    if arr.recvDate == dInfo[2].wednesday{
                                        wedArr.append(arr)
                                    }
                                    if arr.recvDate == dInfo[3].thursday{
                                        thuArr.append(arr)
                                    }
                                    if arr.recvDate == dInfo[4].friday{
                                        friArr.append(arr)
                                    }
                                }
                            }
                            self.tableView.reloadData()
                        }
                    }
                    else{
                        print("i got nothing:\(String(describing: origindata.result.error))")
                    }
                }
            }})
        let dismissAction = UIAlertAction(title: "返回", style: .cancel, handler: nil)
        let paidAction = UIAlertAction(title: "取消付款", style: .destructive, handler: {
            (action: UIAlertAction!) -> () in
            Alamofire.request("http://dinnersys.ddns.net/dinnersys_beta/backend/backend.php?cmd=reverse_payment&dish_id=\(info.dishId)&user_id=\(info.user!.userId)&recv_date=\(info.recvDate)&order_date=\(info.orderDate)").responseData{response in}
        })
        
        if info.paidStatus == "您尚未付款"{
            statusAlert.addAction(paymentAction)
            statusAlert.addAction(cancelAction)
        }else{
            statusAlert.addAction(paidAction)
        }
        statusAlert.addAction(dismissAction)
        self.present(statusAlert, animated: true, completion: {
            self.tableView.deselectRow(at: indexPath, animated: true)
        })
    }

}
