//
//  LoginViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2020/2/15.
//  Copyright © 2020 DinnerSystem Team. All rights reserved.
//

import UIKit
import Reachability
import Alamofire
import Crashlytics

class LoginViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var remSwitch: UISwitch!
    
    //MARK: - Declarations
    var uDefault: UserDefaults!
    
    //MARK: - VDL
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        
        //sry light mode here
        if #available(iOS 13.0, *){
            overrideUserInterfaceStyle = .light
        }
    }
    
    // MARK: - quitKeyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        username.resignFirstResponder()
        password.resignFirstResponder()
    }
    
    
    @IBAction func login(_ sender: Any) {
        //userdefault
        uDefault = UserDefaults.standard
        
        //get account&pw
        usr = username.text!
        pwd = password.text!
        
        //POST Param
        let loginParam: Parameters = ["cmd": "login", "id": usr, "password": pwd, "device_id": "Hello_From_iOS"]
        
        //internet reachablity
        let reach = try! Reachability()
        if reach.connection == .unavailable{
            let alert = createAlert("未連線到網路", "請檢查您當前的網路狀態！")
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        //actual login
        AF.request(dsRequestURL, method: .post, parameters: loginParam).responseData{ response in
            if response.error != nil{
                Crashlytics.sharedInstance().recordError(response.error!)
                self.present(createAlert("登入失敗", "請注意連線狀態，多次失敗請聯絡開發人員\nError Code: \(response.error!)"),animated: false)
                return
            }
            
            //respondable fallback
            let responseString = String(data: response.data!, encoding: .utf8)!
            if (responseString.contains("無法登入。")) || (responseString.contains("No")) || (responseString.contains("Invalid") || (responseString == "") || (responseString == "Wrong") || (responseString == "punish") || (responseString == "Punish")){
                let alert = UIAlertController(title: "無法登入", message: "請確認帳號密碼是否錯誤。\n錯誤敘述：\(responseString)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            
            do{
                print(responseString)
                //JSON
                userInfo = try decoder.decode(Login.self, from: response.data!)
                userInfo.name = userInfo.name?.trimmingCharacters(in: .whitespaces)
                
                //remPW
                if self.remSwitch.isOn{
                    self.uDefault.set(usr, forKey: "userName")
                    self.uDefault.set(pwd, forKey: "passWord")
                    self.uDefault.set(userInfo.name!, forKey: "studentName")
                }
                
                //determine stu or pm
                if userInfo.validOper!.contains("select_class") && !userInfo.validOper!.contains("select_other") {
                    self.performSegue(withIdentifier: "dmSegue", sender: nil)
                }else{
                    self.performSegue(withIdentifier: "stuSegue", sender: nil)
                }
                
            }catch let error{
                print(error)
                Crashlytics.sharedInstance().recordError(error)
                let errorAlert = UIAlertController(title: "Error", message: "不知名的錯誤，請嘗試重新登入或確認帳號密碼是否正確。", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
            }
        }
    }
    
}

