//
//  MainOrderTableViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2018/9/13.
//  Copyright © 2018年 Sean.Inc. All rights reserved.
//

import UIKit
import Alamofire
import TrueTime
import Crashlytics
import FirebaseMessaging

class MainOrderTableViewController: UITableViewController {
    //var uDefault: UserDefaults!
    var activityIndicator = UIActivityIndicatorView()
    var indicatorBackView = UIView()
    var factoryName: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        //uDefault = UserDefaults.standard
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        indicatorBackView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        indicatorBackView.center = self.view.center
        indicatorBackView.isHidden = true
        indicatorBackView.layer.cornerRadius = 20
        indicatorBackView.alpha = 0.5
        indicatorBackView.backgroundColor = UIColor.lightGray
        self.view.addSubview(indicatorBackView)
        self.view.addSubview(activityIndicator)
        
//        if usr == "06610233"{                                   //daily order notification
//            if !uDefault.bool(forKey: "isSubbed"){
//                Messaging.messaging().subscribe(toTopic: "com.dinnersystem.dailyNotification"){ error in
//                    if error != nil{
//                        self.present(createAlert("哎呀呀", "我出了一點問題，快截圖傳給開發人員！\n\(error!)"), animated: true, completion: nil)
//                    }else{
//                        self.present(createAlert("安安", "每日通知已開啟喔"), animated: true, completion: nil)
//                        self.uDefault.set(true, forKey: "isSubbed")}
//                }
//            }
//        }
        
        fetchData()
        
    }
    
    @IBAction func reload(_ sender: Any) {
        fetchData()
    }
    
    
    @IBAction func backButton(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }
    
    func fetchData(){
        UIApplication.shared.beginIgnoringInteractionEvents()
        self.activityIndicator.startAnimating()
        self.indicatorBackView.isHidden = false
        var foodCount = 0
        let param = cmdParam(cmd: "show_dish")
        AF.request(dsRequestURL, method: .post, parameters: param).responseData{ response in
            if response.error != nil {
                let errorAlert = UIAlertController(title: "Bad Internet.", message: "Please check your internet connection and retry.", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                    (action: UIAlertAction!) -> () in
                    logout()
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(errorAlert, animated: true, completion: nil)
            }else{
                
                let responseStr = String(data: response.data!, encoding: .utf8)
                if responseStr == ""{
                    let alert = UIAlertController(title: "請重新登入", message: "您已經登出", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        (action: UIAlertAction!) -> () in
                        logout()
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    mainMenuArr = []
                    originMenuArr = []
                    randomMenuArr = []
                    splitMainMenuArr = [:]
                    self.factoryName = []
                    //singleGDMenuarr = []
                    //mainMenuArr = try! decoder.decode([Menu].self, from: response.data!)
                    do{
                        mainMenuArr = try decoder.decode([Menu].self, from: response.data!)
                        originMenuArr = mainMenuArr
                        for food in mainMenuArr{
                            if food.isIdle! == "1"{
                                mainMenuArr.remove(at: foodCount)
                            }else{
                                if Int(food.remaining!)! == Int32.max{
                                    mainMenuArr[foodCount].remaining = "1000"
                                }
                                foodCount += 1
                            }
                            if !self.factoryName.contains((food.department?.factory?.name!)!) && food.isIdle! == "0"{
                                self.factoryName.append((food.department?.factory?.name!)!)
                                splitMainMenuArr.updateValue([], forKey: (food.department?.factory?.name!)!)
                            }
                        }
                        for food in mainMenuArr{
                            splitMainMenuArr[(food.department?.factory?.name!)!]?.append(food)
                            if food.department?.factory?.allowCustom! == "false"{
                                randomMenuArr.append(food)
                            }
                        }
                        self.factoryName.append("Random")
                        self.tableView.reloadData()
                    }catch let error{
                        Crashlytics.sharedInstance().recordError(error)
                        let alert = UIAlertController(title: "請重新登入", message: "發生了不知名的錯誤，若重複發生此錯誤請務必通知開發人員！", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                            (action: UIAlertAction!) -> () in
                            logout()
                            self.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                }
                
            }
            do{
                let balanceRepsonse = try Data(contentsOf: URL(string: dsURL("get_pos"))!)
                do{
                    POSInfo = try decoder.decode(CardInfo.self, from: balanceRepsonse)
                    balance = Int(POSInfo.money!)!
                }catch let error{
                    Crashlytics.sharedInstance().recordError(error)
                    print(String(data: balanceRepsonse, encoding: .utf8)!)
                    let alert = UIAlertController(title: "請重新登入", message: "查詢餘額失敗，我們已經派出最精銳的猴子去修理這個問題，若長時間出現此問題請通知開發人員！", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        (action: UIAlertAction!) -> () in
                        logout()
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }catch let error{
                Crashlytics.sharedInstance().recordError(error)
                print(error)
                let errorAlert = UIAlertController(title: "Bad Internet.", message: "Please check your internet connection and retry.", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                    (action: UIAlertAction!) -> () in
                    logout()
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(errorAlert, animated: true, completion: nil)
            }
            self.indicatorBackView.isHidden = true
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.factoryName.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "factoryCell", for: indexPath) as! FactoryTableViewCell
        let info = factoryName[indexPath.row]
        
        if info == "Random"{
            cell.factoryName.text = "想不到要吃什麼？"
        }else{
            cell.factoryName.text = info
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = factoryName[indexPath.row]
        if info == "Random"{
            self.performSegue(withIdentifier: "randomSegue", sender: nil)
        }else if splitMainMenuArr[info]![0].department?.factory?.allowCustom! == "false"{       //not allow
            selectedMenuArr = splitMainMenuArr[info]!
            self.performSegue(withIdentifier: "normalSegue", sender: nil)
        }else{
            selectedMenuArr = splitMainMenuArr[info]!
            self.performSegue(withIdentifier: "customSegue", sender: nil)
        }
    }
}


