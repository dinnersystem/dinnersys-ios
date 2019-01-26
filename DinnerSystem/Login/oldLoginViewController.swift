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

class LoginViewController: UIViewController {
    //MARK: - Declaration
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var remLogin: UIButton!
    @IBOutlet var remPW: UISwitch!
    var uDefault: UserDefaults!
    
    
    //MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        uDefault = UserDefaults.standard
        if let name = uDefault.string(forKey: "studentName"){
            self.remLogin.isEnabled = true
            self.remLogin.setTitle("以\(name)登入", for: UIControl.State.normal)
        }
        fcmToken = Messaging.messaging().fcmToken ?? ""
        if fcmToken == ""{
            print("getToken failed")
        }else{
            print("token:"+fcmToken)
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
        let reach = Reachability()!
        if(reach.connection == .none){                      //no Internet
            let alert = UIAlertController(title: "無網路連接", message: "請注意網路連接是否正常", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }else{
        Alamofire.request("\(dsURL("login"))&id=\(usr)&password=\(pwd)").responseData{response in
            if response.error != nil {
                let errorAlert = UIAlertController(title: "Error", message: "不知名的錯誤，請注意網路連線狀態或聯絡管理員。", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
            }
            let string = String(data: response.data!, encoding: .utf8)!
            if (string.contains("無法登入。")) || (string.contains("No")) || (string.contains("Invalid")){
                let alert = UIAlertController(title: "無法登入", message: "請確認帳號密碼是否錯誤。", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                
                userInfo = try! decoder.decode(Login.self, from: response.data!)
                userInfo.name = userInfo.name?.trimmingCharacters(in: .whitespaces)
                let alert = UIAlertController(title: "登入成功", message: "歡迎使用點餐系統，\(userInfo.name!)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                    (action: UIAlertAction!) -> () in
                    self.performSegue(withIdentifier: "stuLoginSuccess", sender: nil)
                }))
                self.present(alert, animated: true, completion: nil)
                
            }
            
            }
        }
    }
    @IBAction func login(_ sender: Any) {
        usr = self.username.text!
        pwd = self.password.text!
        
        let reach = Reachability()!
        if(reach.connection == .none){                      //no Internet
            let alert = UIAlertController(title: "無網路連接", message: "請注意網路連接是否正常", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }else{
        Alamofire.request("\(dsURL("login"))&id=\(usr)&password=\(pwd)").responseData{response in
            if response.error != nil {
                let errorAlert = UIAlertController(title: "Error", message: "不知名的錯誤，請注意網路連線狀態或聯絡開發者。", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
            }else{
                let string = String(data: response.data!, encoding: .utf8)!
                if (string.contains("無法登入。")) || (string.contains("No")) || (string.contains("Invalid")){
                    let alert = UIAlertController(title: "無法登入", message: "請確認帳號密碼是否錯誤。", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else{
                        usr = self.username.text!
                        pwd = self.password.text!
                        self.username.text = ""
                        self.password.text = ""
                        userInfo = try! decoder.decode(Login.self, from: response.data!)
                        userInfo.name = userInfo.name?.trimmingCharacters(in: .whitespaces)
                        //remember user
                        if (self.remPW.isOn){
                            self.uDefault.set(usr, forKey: "userName")
                            self.uDefault.set(pwd, forKey: "passWord")
                            self.uDefault.set(userInfo.name!, forKey: "studentName")
                            self.remLogin.isEnabled = true
                            self.remLogin.setTitle("以\(userInfo.name!)登入", for: UIControl.State.normal)
                        }
                    if userInfo.validOper?[6].selectClass != nil{
                        let alert = UIAlertController(title: "無法登入", message: "抱歉，目前點餐系統沒有開放午餐股長管理功能，請使用網路版進行管理。", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                            (action: UIAlertAction!) -> () in
                            Alamofire.request(dsURL("logout")).responseData{response in}
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        let alert = UIAlertController(title: "登入成功", message: "歡迎使用點餐系統，\(userInfo.name!)", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                            (action: UIAlertAction!) -> () in
                            self.performSegue(withIdentifier: "stuLoginSuccess", sender: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                    }
                }
            }
        
        
        }
        
    }
    
    
    
    
}
