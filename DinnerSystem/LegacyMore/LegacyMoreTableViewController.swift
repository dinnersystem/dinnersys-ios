//
//  LegacyMoreTableViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2018/9/16.
//  Copyright © 2018年 Sean.Inc. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseCrashlytics
import FirebaseMessaging
import UserNotifications


class LegacyMoreTableViewController: UITableViewController {
    @IBOutlet var dailySwitch: UISwitch!
    var uDefault: UserDefaults!
    var counter=0
    override func viewDidLoad() {
        super.viewDidLoad()
        uDefault = UserDefaults.standard
        if uDefault.bool(forKey: "dailyNotifiacation") != false{
            dailySwitch.isOn = true
        }else{
            dailySwitch.isOn = false
        }
    }
    @IBAction func Logout(_ sender: Any) {
        logout()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func switchedDaily(_ sender: Any) {
        if dailySwitch.isOn{
            var canNotify = false
            let center = UNUserNotificationCenter.current()
            center.getNotificationSettings(completionHandler: { (setting) in
                print(setting)
                if(setting.authorizationStatus == .authorized){
                    print("authed")
                    canNotify = true
                    Messaging.messaging().subscribe(toTopic: "com.dinnersystem.dailyNotification"){ error in
                        if error != nil{
                            self.present(createAlert("訂閱過程發生錯誤", "\(error!)"), animated: true, completion: nil)
                            DispatchQueue.main.async {
                                self.dailySwitch.isOn = false 
                            }
                            
                        }else{
                            self.present(createAlert("訂閱成功", "每日通知已開啟"), animated: true, completion: nil)
                            self.uDefault.set(true, forKey: "dailyNotifiacation")
                        }
                    }

                }else{
                    let alert = UIAlertController(title: "尚未開啟通知", message: "請至設定開啟通知", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "跳轉至設定", style: .default, handler: { (action) in
                        if let url = URL(string:UIApplication.openSettingsURLString) {
                            if UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        }
                    }))
                    alert.addAction(UIAlertAction(title: "取消", style: .default, handler: nil))
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                        self.dailySwitch.isOn = false
                    }
                }
                
            })
            print(canNotify)
//            if canNotify{
//                Messaging.messaging().subscribe(toTopic: "com.dinnersystem.dailyNotification"){ error in
//                    if error != nil{
//                        self.present(createAlert("訂閱過程發生錯誤", "\(error!)"), animated: true, completion: nil)
//                    }else{
//                        self.present(createAlert("訂閱成功", "每日通知已開啟"), animated: true, completion: nil)
//                        self.uDefault.set(true, forKey: "dailyNotifiacation")
//                    }
//                }
//            }else{
//                let alert = UIAlertController(title: "尚未開啟通知", message: "請至設定開啟通知", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "跳轉至設定", style: .default, handler: { (action) in
//                    if let url = URL(string:UIApplication.openSettingsURLString) {
//                        if UIApplication.shared.canOpenURL(url) {
//                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                        }
//                    }
//                }))
//                alert.addAction(UIAlertAction(title: "取消", style: .default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
//                self.dailySwitch.isOn = false
//            }
        }else{              //closed
            Messaging.messaging().unsubscribe(fromTopic: "com.dinnersystem.dailyNotification"){error in
                if error != nil{
                    self.present(createAlert("取消訂閱過程發生錯誤", "\(error!)"), animated: true, completion: nil)
                    DispatchQueue.main.async {
                        self.dailySwitch.isOn = true
                    }
                    
                }else{
                    self.present(createAlert("取消訂閱成功", "每日通知已關閉"), animated: true, completion: nil)
                    self.uDefault.set(false, forKey: "dailyNotifiacation")
                }
            }
        }
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1{
            if counter == 13{
                counter = 0
                self.performSegue(withIdentifier: "bonusSegue", sender: self)
            }else{
                counter += 1
                self.performSegue(withIdentifier: "normalSegue", sender: self)
            }
        }else if indexPath.row == 3{
            let policiyURL = URL(string: "\(dinnersysURL)/frontend/FoodPolicies.pdf")!
            UIApplication.shared.open(policiyURL, options: [:], completionHandler: nil)
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
        //        else if indexPath.row == 2{
        //            do{
        //                let cardResponse = try Data(contentsOf: URL(string: dsURL("get_pos"))!)
        //                POSInfo = try decoder.decode(CardInfo.self, from: cardResponse)
        //                self.performSegue(withIdentifier: "barcodeSegue", sender: self)
        //            }catch let error{
        //                print(error)
        //                Crashlytics.crashlytics().record(error: error)
        //                let alert = UIAlertController(title: "請重新登入", message: "查詢餘額失敗，我們已經派出最精銳的猴子去修理這個問題，若長時間出現此問題請通知開發人員！", preferredStyle: UIAlertController.Style.alert)
        //                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
        //                    (action: UIAlertAction!) -> () in
        //                    logout()
        //                    self.dismiss(animated: true, completion: nil)
        //                }))
        //                self.present(alert, animated: true, completion: nil)
        //            }
        //
        //        }
    }
}
