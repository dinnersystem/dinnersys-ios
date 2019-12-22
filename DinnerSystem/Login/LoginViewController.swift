//
//  LoginViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2018/4/22.
//  Copyright © 2018年 Sean.Inc. All rights reserved.
//

import UIKit
import Alamofire
import Reachability
import FirebaseMessaging
import Crashlytics
import FirebaseInstanceID

class LoginViewController: UIViewController {
    //MARK: - Declaration
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var remLogin: UIButton!
    @IBOutlet var remPW: UISwitch!
    var uDefault: UserDefaults!
    var activityIndicator = UIActivityIndicatorView()
    var indicatorBackView = UIView()
    struct loginData: Encodable {
        var id: String
        var password: String
        var time: String
    }
    
    //MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.startAnimating()
        indicatorBackView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        indicatorBackView.center = self.view.center
        indicatorBackView.isHidden = false
        indicatorBackView.layer.cornerRadius = 20
        indicatorBackView.alpha = 0.5
        indicatorBackView.backgroundColor = UIColor.black
        self.view.addSubview(indicatorBackView)
        self.view.addSubview(activityIndicator)
        uDefault = UserDefaults.standard
        if let name = uDefault.string(forKey: "studentName"){
            self.remLogin.isEnabled = true
            self.remLogin.setTitle("以\(name)登入", for: UIControl.State.normal)
        }
        fcmToken = Messaging.messaging().fcmToken ?? ""
        //        InstanceID.instanceID().instanceID { (result, error) in
        //            if error != nil{
        //                print("instanceID fail")
        //                return
        //            }
        //            fcmToken = result!.token
        //        }
        //        if fcmToken == ""{
        //            print("getToken failed")
        //        }else{
        //            print("token:"+fcmToken)
        //        }
        
        /*
         Alamofire.request("\(dinnersysURL)frontend/u_move_u_dead/version.txt").responseString{ response in
         if response.error != nil {
         self.indicatorBackView.isHidden = true
         self.activityIndicator.stopAnimating()
         UIApplication.shared.endIgnoringInteractionEvents()
         Crashlytics.sharedInstance().recordError(response.error!)
         let errorAlert = UIAlertController(title: "Bad Internet.", message: "Please check your internet connection and retry.\n\(response.error!)", preferredStyle: .alert)
         errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
         self.present(errorAlert, animated: true, completion: nil)
         }else{
         let decoder = JSONDecoder()
         print(String(data: response.data!, encoding: .utf8)!)
         do{
         currentVersion = try decoder.decode(appVersion.self, from: response.data!)
         if !(currentVersion.ios!.contains(versionNumber)){
         let alert = UIAlertController(title: "偵測到更新版本", message: "請至App Store更新最新版本的點餐系統!", preferredStyle: .alert)
         let action = UIAlertAction(title: "OK(跳轉至AppStore)", style: .default, handler: {
         (action: UIAlertAction!) -> () in
         UIApplication.shared.openURL(itmsURL)
         })
         alert.addAction(action)
         self.present(alert, animated: true, completion: nil)
         }
         }catch let error{
         print(error)
         let alert = UIAlertController(title: "Oops", message: "發生了不知名的錯誤，請聯繫開發人員", preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
         Crashlytics.sharedInstance().recordError(error)
         self.present(alert,animated: true, completion: nil)
         
         }
         
         self.indicatorBackView.isHidden = true
         self.activityIndicator.stopAnimating()
         UIApplication.shared.endIgnoringInteractionEvents()
         }
         }
         */
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIApplication.shared.beginIgnoringInteractionEvents()
//        self.activityIndicator.startAnimating()
//        self.indicatorBackView.isHidden = false
        
//                Messaging.messaging().subscribe(toTopic: "seanpai.gsatnotify"){ error in
//                    if error != nil{
//                        self.present(createAlert("哎呀呀", "我出了一點問題，快截圖傳給開發人員！\n\(error!)"), animated: true, completion: nil)
//                    }else{
//                        self.present(createAlert("安安", "每日通知已開啟喔"), animated: true, completion: nil)
//                    }
//                }
        
        do{
            let versionURL = URL(string: "\(dinnersysURL)/frontend/u_move_u_dead/version.txt")!
            let versionResponse = try Data(contentsOf: versionURL)
            print(String(data: versionResponse, encoding: .utf8)!)
            currentVersion = try decoder.decode(AppVersion.self, from: versionResponse)
            if !(currentVersion.ios!.contains(versionNumber)){
                self.indicatorBackView.isHidden = true
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                let alert = UIAlertController(title: "偵測到更新版本", message: "請至App Store更新最新版本的點餐系統!", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK(跳轉至AppStore)", style: .default, handler: {
                    (action: UIAlertAction!) -> () in
                    UIApplication.shared.open(itmsURL, options: [:], completionHandler: nil)
                })
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }else{
                self.indicatorBackView.isHidden = true
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        }catch let error{
            print(error)
            self.indicatorBackView.isHidden = true
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            let alert = UIAlertController(title: "Oops", message: "發生了不知名的錯誤，請聯繫開發人員!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            Crashlytics.sharedInstance().recordError(error)
            self.present(alert,animated: true, completion: nil)
        }
    }
    // MARK: - quitKeyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        username.resignFirstResponder()
        password.resignFirstResponder()
    }
    
    
    //MARK: - login
    @IBAction func remLogin(_ sender: Any) {
        uDefault = UserDefaults.standard
        usr = uDefault.string(forKey: "userName")!
        pwd = uDefault.string(forKey: "passWord")!
        let timeStamp = String(Int(Date().timeIntervalSince1970))
        let reach = try! Reachability()
        let loginParam: Parameters = ["cmd": "login", "id": usr, "password": pwd, "time": timeStamp, "device_id": "HELLO_FROM_IOS"]
        //MARK: - hash
        //let _ = "{\"id\":\"\(usr)\",\"password\":\"\(pwd)\",\"time\":\"\(timeStamp)\"}".sha512()  //hash
        if(reach.connection == .unavailable){                      //no Internet
            let alert = UIAlertController(title: "無網路連接", message: "請注意網路連接是否正常", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }else{
            UIApplication.shared.beginIgnoringInteractionEvents()
            self.activityIndicator.startAnimating()
            self.indicatorBackView.isHidden = false
            Alamofire.request(dsRequestURL, method: .post, parameters: loginParam).responseData{response in
                if response.error != nil {
                    self.indicatorBackView.isHidden = true
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    Crashlytics.sharedInstance().recordError(response.error!)
                    let errorAlert = UIAlertController(title: "Bad Internet.", message: "Please check your internet connection and retry.", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(errorAlert, animated: true, completion: nil)
                }else{
                    let string = String(data: response.data!, encoding: .utf8)!
                    Crashlytics.sharedInstance().setObjectValue(string, forKey: "httpResponse")
                    if (string.contains("無法登入。")) || (string.contains("No")) || (string.contains("Invalid") || (string == "") || (string == "Wrong") || (string == "punish") || (string == "Punish") || (usr.count == 5)){
                        let alert = UIAlertController(title: "無法登入", message: "請確認帳號密碼是否錯誤。", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        Crashlytics.sharedInstance().setUserIdentifier(usr)
                        //userInfo = try! decoder.decode(Login.self, from: response.data!)
                        do{
                            userInfo = try decoder.decode(Login.self, from: response.data!)
                            userInfo.name = userInfo.name?.trimmingCharacters(in: .whitespaces)
                            let userString = userInfo.name!.trimmingCharacters(in: .whitespacesAndNewlines)
                            let alert = UIAlertController(title: "登入成功", message: "歡迎使用點餐系統，\(userString)", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                                (action: UIAlertAction!) -> () in
                                self.performSegue(withIdentifier: "loginSuccess", sender: nil)
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }catch let error{
                            print(error)
                            Crashlytics.sharedInstance().recordError(error)
                            let errorAlert = UIAlertController(title: "Error", message: "不知名的錯誤，請嘗試重新登入或確認帳號密碼是否正確。", preferredStyle: .alert)
                            errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(errorAlert, animated: true, completion: nil)
                        }
                        
                        
                        
                    }
                    self.indicatorBackView.isHidden = true
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
            }
        }
    }
    @IBAction func login(_ sender: Any) {
        usr = self.username.text!
        pwd = self.password.text!
        let timeStamp = String(Int(Date().timeIntervalSince1970))
        print(timeStamp)
        let reach = try! Reachability()
        let loginParam: Parameters = ["cmd": "login", "id": usr, "password": pwd, "time": timeStamp, "device_id": "HELLO_FROM_IOS"]
        //MARK: - hash
        //let _ = "{\"id\":\"\(usr)\",\"password\":\"\(pwd)\",\"time\":\"\(timeStamp)\"}".sha512() //hash
        print(hash)
        if(reach.connection == .unavailable){                      //no Internet
            let alert = UIAlertController(title: "無網路連接", message: "請注意網路連接是否正常", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }else{
            UIApplication.shared.beginIgnoringInteractionEvents()
            self.activityIndicator.startAnimating()
            self.indicatorBackView.isHidden = false
            Alamofire.request(dsRequestURL, method: .post, parameters: loginParam).responseData{response in
                if response.error != nil {
                    Crashlytics.sharedInstance().recordError(response.error!)
                    self.indicatorBackView.isHidden = true
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    let errorAlert = UIAlertController(title: "Bad Internet.", message: "Please check your internet connection and retry.\n\(response.error!)", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(errorAlert, animated: true, completion: nil)
                }else{
                    Crashlytics.sharedInstance().setObjectValue(String(data: response.data!, encoding: .utf8), forKey: "httpResponse")
                    let string = String(data: response.data!, encoding: .utf8)!
                    print(string)
                    if (string.contains("無法登入。")) || (string.contains("No")) || (string.contains("Invalid") || (string == "") || (string == "Wrong") || (usr.count == 5)){
                        let alert = UIAlertController(title: "無法登入", message: "請確認帳號密碼是否錯誤。", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        usr = self.username.text!
                        pwd = self.password.text!
                        self.username.text = ""
                        self.password.text = ""
                        Crashlytics.sharedInstance().setUserIdentifier(usr)
                        do{
                            userInfo = try decoder.decode(Login.self, from: response.data!)
                            userInfo.name = userInfo.name?.trimmingCharacters(in: .whitespaces)
                            //remember user
                            if (self.remPW.isOn){
                                self.uDefault.set(usr, forKey: "userName")
                                self.uDefault.set(pwd, forKey: "passWord")
                                self.uDefault.set(userInfo.name!, forKey: "studentName")
                                self.remLogin.isEnabled = true
                                self.remLogin.setTitle("以\(userInfo.name!)登入", for: UIControl.State.normal)
                            }
                            
                            let nameString = userInfo.name!.trimmingCharacters(in: .whitespacesAndNewlines)
                            let alert = UIAlertController(title: "登入成功", message: "歡迎使用點餐系統，\(nameString)", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                                (action: UIAlertAction!) -> () in
                                self.performSegue(withIdentifier: "loginSuccess", sender: nil)
                            }))
                            self.present(alert, animated: true, completion: nil)
                            
                        }catch let error{
                            print(error)
                            Crashlytics.sharedInstance().recordError(error)
                            let errorAlert = UIAlertController(title: "Error", message: "不知名的錯誤，請嘗試重新登入或確認帳號密碼是否正確。", preferredStyle: .alert)
                            errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(errorAlert, animated: true, completion: nil)
                        }
                        
                    }
                }
                self.indicatorBackView.isHidden = true
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
            }
            
            
        }
        
    }
    
    
    
    
}
