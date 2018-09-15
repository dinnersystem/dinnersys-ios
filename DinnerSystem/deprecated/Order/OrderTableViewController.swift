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
import UserNotifications
import AudioToolbox
import GoogleMobileAds

var filterData: Data!
var filterString = ""

class OrderTableViewController: UITableViewController {
    
    @IBAction func updateMenu(_ sender: Any) {
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
    self.refreshControl?.endRefreshing()
}
    override func viewDidLoad() {
        Alamofire.request("http://dinnersys.ddns.net/dinnersys_beta/backend/backend.php?cmd=show_menu&plugin=yes").responseData { origindata in
            if let data = origindata.result.value {
                let string = String(data: data,encoding: .utf8)
                if string == ""{
                    let alert = UIAlertController(title: "請重新登入", message: "您已經登出", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                        (action: UIAlertAction!) -> () in
                        Alamofire.request("http://dinnersys.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }else{
                print(data as NSData)
                let decoder = JSONDecoder()
                arrRes = try! decoder.decode([Food].self, from: data)
                self.tableView.reloadData()
                }
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menu = arrRes[indexPath.row]
        selOrder.name = menu.dishName!
        selOrder.cost = menu.dishCost
        selOrder.num = menu.dishId!
    }
    
}

class OrderViewController: UIViewController {
    
    @IBOutlet var bannerView: GADBannerView!
    @IBOutlet var alert: UILabel!
    @IBOutlet var datePicker: UIDatePicker!
    let notificationFeedbackGenerator = UINotificationFeedbackGenerator()

    override func viewDidLoad(){
        alert.numberOfLines = 5
        alert.text = "你選擇的是\(selOrder.name)，共\(selOrder.cost)元。\n確定請選擇點餐日期後按點餐。（日期範圍：該週星期一到五。）"
        alert.sizeToFit()
        notificationFeedbackGenerator.prepare()
        /*
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        let adRequest: GADRequest = GADRequest()
        adRequest.testDevices = [kGADSimulatorID]
        bannerView.load(adRequest)
 */
    }
    
    
    
    
    @IBAction func confirm(_ sender: Any) {
        //Server-side
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.string(from: datePicker.date)
        print("user:\(user.id), date:\(date) dish_id:\(selOrder.num).")
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        selDate.year = Int(yearFormatter.string(from: datePicker.date))!
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MM"
        selDate.month = Int(monthFormatter.string(from: datePicker.date))!
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "dd"
        selDate.day = Int(dayFormatter.string(from: datePicker.date))!
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
                    let titleFont = [NSAttributedStringKey.font: UIFont(name: "ArialHebrew-Bold", size: 17.0)!]
                    let messageAttrString = NSMutableAttributedString(string: "點餐成功", attributes: titleFont)
                    let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
                    alert.setValue(messageAttrString, forKey: "attributedMessage")
                    let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                        (action: UIAlertAction!) -> () in
                        self.navigationController?.popViewController(animated: true)
                    })
                    alert.addImage(image: success_image!)
                    alert.addAction(action)
                    let content = UNMutableNotificationContent()  //notification
                    content.title = NSString.localizedUserNotificationString(forKey: "點餐提醒", arguments: nil)
                    content.body = NSString.localizedUserNotificationString(forKey: "您今日點的餐為\(selOrder.name)。", arguments: nil)
                    var dateInfo = DateComponents()
                    dateInfo.year = selDate.year
                    dateInfo.month = selDate.month
                    dateInfo.day = selDate.day
                    dateInfo.hour = 11
                    dateInfo.minute = 0
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
                    let requst = UNNotificationRequest(identifier: "date:\(date)id:\(selOrder.num)", content: content, trigger: trigger)
                    let center = UNUserNotificationCenter.current()
                    center.add(requst) { (error : Error?) in
                        if let theerror = error{
                            print (theerror.localizedDescription)
                        }
                    }
                    let normalVibrate = SystemSoundID(kSystemSoundID_Vibrate) //feedback
                        if UIDevice.current.hasTapticEngine || UIDevice.current.hasHapticFeedback{
                            let peek = SystemSoundID(1519)
                            AudioServicesPlaySystemSound(peek)
                            usleep(150000)
                            AudioServicesPlaySystemSound(peek)
                        }else{
                            AudioServicesPlaySystemSound(normalVibrate)
                        }
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
            print("response:\(String(describing: responseString))")
        }
        task.resume()
    }
    
    
}
