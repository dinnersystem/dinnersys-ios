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
    var activityIndicator = UIActivityIndicatorView()
    var indicatorBackView = UIView()
    
    //MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            UIApplication.shared.beginIgnoringInteractionEvents()
            self.activityIndicator.startAnimating()
            self.indicatorBackView.isHidden = false
        Alamofire.request("\(dsURL("login"))&id=\(usr)&password=\(pwd)&device_id=\(fcmToken)").responseData{response in
            if response.error != nil {
                let errorAlert = UIAlertController(title: "Error", message: "不知名的錯誤，請注意網路連線狀態或聯絡管理員。", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
            }
            let string = String(data: response.data!, encoding: .utf8)!
            if (string.contains("無法登入。")) || (string.contains("No")) || (string.contains("Invalid") || (string == "")){
                let alert = UIAlertController(title: "無法登入", message: "請確認帳號密碼是否錯誤。", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                
                //userInfo = try! decoder.decode(Login.self, from: response.data!)
                do{
                    userInfo = try decoder.decode(Login.self, from: response.data!)
                }catch let error{
                    print(error)
                    let errorAlert = UIAlertController(title: "Error", message: "不知名的錯誤，請嘗試重新登入或確認帳號密碼是否正確。", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(errorAlert, animated: true, completion: nil)
                }
                userInfo.name = userInfo.name?.trimmingCharacters(in: .whitespaces)
                if userInfo.validOper?[2].selectClass != nil{
                    let alert = UIAlertController(title: "登入成功", message: "歡迎\(userInfo.classField!.classNo!)的午餐股長", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        (action: UIAlertAction!) -> () in
                        self.performSegue(withIdentifier: "dmLoginSuccess", sender: nil)
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
            self.indicatorBackView.isHidden = true
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
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
            UIApplication.shared.beginIgnoringInteractionEvents()
            self.activityIndicator.startAnimating()
            self.indicatorBackView.isHidden = false
        Alamofire.request("\(dsURL("login"))&id=\(usr)&password=\(pwd)&device_id=\(fcmToken)").responseData{response in
            if response.error != nil {
                let errorAlert = UIAlertController(title: "Error", message: "不知名的錯誤，請注意網路連線狀態或聯絡開發者。", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
            }else{
                
                let string = String(data: response.data!, encoding: .utf8)!
                if (string.contains("無法登入。")) || (string.contains("No")) || (string.contains("Invalid") || (string == "")){
                    let alert = UIAlertController(title: "無法登入", message: "請確認帳號密碼是否錯誤。", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else{
                        usr = self.username.text!
                        pwd = self.password.text!
                        self.username.text = ""
                        self.password.text = ""
                        do{
                            userInfo = try decoder.decode(Login.self, from: response.data!)
                        }catch let error{
                            print(error)
                            let errorAlert = UIAlertController(title: "Error", message: "不知名的錯誤，請嘗試重新登入或確認帳號密碼是否正確。", preferredStyle: .alert)
                            errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(errorAlert, animated: true, completion: nil)
                        }
                        userInfo.name = userInfo.name?.trimmingCharacters(in: .whitespaces)
                        //remember user
                        if (self.remPW.isOn){
                            self.uDefault.set(usr, forKey: "userName")
                            self.uDefault.set(pwd, forKey: "passWord")
                            self.uDefault.set(userInfo.name!, forKey: "studentName")
                            self.remLogin.isEnabled = true
                            self.remLogin.setTitle("以\(userInfo.name!)登入", for: UIControl.State.normal)
                        }
                    if userInfo.validOper?[2].selectClass != nil{
                        let alert = UIAlertController(title: "登入成功", message: "歡迎\(userInfo.classField!.classNo!)的午餐股長", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                            (action: UIAlertAction!) -> () in
                            self.performSegue(withIdentifier: "dmLoginSuccess", sender: nil)
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
            self.indicatorBackView.isHidden = true
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            }
        
        
        }
        
    }
    
    
    
    
}
