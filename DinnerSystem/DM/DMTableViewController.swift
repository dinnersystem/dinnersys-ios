//
//  DMTableViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2020/1/7.
//  Copyright © 2020 DinnerSystem Team. All rights reserved.
//

import UIKit
import Crashlytics
import Alamofire

class DMTableViewController: UITableViewController {
    let date = Date()
    let formatter = DateFormatter()
    var today = ""
    var activityIndicator = UIActivityIndicatorView()
    var indicatorBackView = UIView()
    var factoryNames: [Int: String] = [:]
    
    private func fetchData(){
        formatter.dateFormat = "yyyy/MM/dd"
        today = formatter.string(from: date)
        print(today)
        dmHistoryTableList = [:]
        factoryNames.removeAll()
        let histParam: Parameters = ["cmd": "select_class", "esti_start": today + "-00:00:00", "esti_end": today + "-23:59:59", "history": "true"]
        AF.request(dsRequestURL, method: .post, parameters: histParam).responseData{response in
            if response.error != nil {
                let errorAlert = UIAlertController(title: "Bad Internet.", message: "Please check your internet connection and retry.", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                    (action: UIAlertAction!) -> () in
                    logout()
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(errorAlert, animated: true, completion: nil)
            }
            let responseStr = String(data: response.data!, encoding: .utf8)
            if responseStr == ""{
                let alert = UIAlertController(title: "請重新登入", message: "您已經登出", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                    (action: UIAlertAction!) -> () in
                    logout()
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }else if responseStr == "{}"{
                let alert = UIAlertController(title: "無點餐紀錄", message: "請嘗試重新整理或進行點餐！", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                //historyArr = try! decoder.decode([History].self, from: response.data!)
                do{
                    //print(String(data: response.data!, encoding: .utf8)!)
                    historyArr = try decoder.decode([History].self, from: response.data!)
                    historyArr.reverse()
                    
                    for order in historyArr{
                        if !self.factoryNames.values.contains(order.dish![0].department!.factory!.name!){
                            dmHistoryTableList.updateValue([], forKey: order.dish![0].department!.factory!.name!)
                            self.factoryNames[self.factoryNames.count] = order.dish![0].department!.factory!.name!
                        }
                        if order.dish!.count == 1{
                            let tmp = HistoryList(id: order.id, dishName: order.dish![0].dishName, dishCost: order.dish![0].dishCost, recvDate: order.recvDate, money: order.money, user: order.user)
                            dmHistoryTableList[order.dish![0].department!.factory!.name!]!.append(tmp)
                        }else{
                            var dName = ""
                            var dCost = 0
                            for dish in order.dish!{
                                dName += "\(dish.dishName!)+"
                                dCost += Int(dish.dishCost!)!
                            }
                            dName = String(dName.dropLast(1))
                            let tmp = HistoryList(id: order.id, dishName: dName, dishCost: String(dCost), recvDate: order.recvDate, money: order.money, user: order.user)
                            dmHistoryTableList[order.dish![0].department!.factory!.name!]!.append(tmp)
                        }
                    }
                }catch let error{
                    print(error)
                    let alert = UIAlertController(title: "請重新登入", message: "發生了不知名的錯誤，若重複發生此錯誤請務必通知開發人員！", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        (action: UIAlertAction!) -> () in
                        logout()
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                self.tableView.reloadData()
            }
            self.indicatorBackView.isHidden = true
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateFormat = "yyyy/MM/dd"
        today = formatter.string(from: date)
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        indicatorBackView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        indicatorBackView.center = self.view.center
        indicatorBackView.isHidden = true
        indicatorBackView.layer.cornerRadius = 20
        indicatorBackView.alpha = 0.5
        indicatorBackView.backgroundColor = UIColor.black
        self.view.addSubview(indicatorBackView)
        self.view.addSubview(activityIndicator)
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        self.activityIndicator.startAnimating()
        self.indicatorBackView.isHidden = false
        fetchData()
        
    }

    @IBAction func reloadPressed(_ sender: Any) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        self.activityIndicator.startAnimating()
        self.indicatorBackView.isHidden = false
        fetchData()
    }
    
    @IBAction func refresh(_ sender: Any) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        self.activityIndicator.startAnimating()
        self.indicatorBackView.isHidden = false
        fetchData()
        self.refreshControl?.endRefreshing()
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return factoryNames.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dmHistoryTableList[factoryNames[section]!]!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DMHistoryCells", for: indexPath)
        var info = dmHistoryTableList[factoryNames[indexPath.section]!]![indexPath.row]
        let range = info.recvDate!.range(of: " ")
        info.recvDate!.removeSubrange((range?.lowerBound)!..<info.recvDate!.endIndex)
        let histInfo = historyArr.filter({ $0.id! == info.id! })
        cell.textLabel?.text! = histInfo[0].dish!.count > 1 ? "自訂套餐(\(histInfo[0].dish!.count)樣)" : (info.dishName!)
        cell.detailTextLabel?.text! = "\(info.user!.seatNo!)\(info.user!.name!), \(info.money!.charge!)$, \(info.money!.payment![0].paid! == "true" ? "已付款" : "未付款")"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return factoryNames[section]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var info = dmHistoryTableList[factoryNames[indexPath.section]!]![indexPath.row]
        info.recvDate = String(info.recvDate!.dropLast(3))
        let paid:Bool = info.money!.payment![0].paid! == "true"
        let alert = UIAlertController(title: "訂餐編號：\(info.id!)\n訂購人：\(info.user!.seatNo!)\(info.user!.name!)\n餐點內容：\(info.dishName!)\n取餐日期：\(info.recvDate!)\n餐點金額：\(info.money!.charge!)$\n付款狀態：\(paid ? "已付款" : "未付款")\n", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "返回", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

   
    

    

}
