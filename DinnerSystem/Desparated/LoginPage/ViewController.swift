//
//  ViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2018/1/6.
//  Copyright © 2018年 Sean.Inc. All rights reserved.
//

import UIKit
import LocalAuthentication
import SystemConfiguration
import Alamofire

class ViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var usr: UITextField!
    @IBOutlet weak var pwd: UITextField!
    @IBOutlet var tidButton: UIButton!
    @IBOutlet var remSwitch: UISwitch!
    var udefault: UserDefaults!
    
    
    //below is the 
    
    
    
    /*
     #This is the function of Touch ID or Face ID, currently closed. Wish to come true!#
     
    @IBAction func touchid(_ sender: Any) {
        
            //使用Touch ID 程式碼，先建立一個LAContext
            let context = LAContext()
            var error:NSError? //稍後認證有錯誤，會把錯誤存在這個屬性
            let reasonString = "Who Are You?"
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
                //如果可以支援TouchID的話，繼續執行下面的程式碼：
                context.evaluatePolicy(
                    .deviceOwnerAuthenticationWithBiometrics,
                    localizedReason: reasonString, reply: {
                        (success:Bool, error:Error?) in
                        //認證TouchID，結果可能成功可能失敗
                        if success{
                            //成功印出認證OK
                            print("認證 OK")
                            self.performSegue(withIdentifier: "success", sender: self)
                        }else{
                            //失敗依照不同情況處理如下
                            if let nsError = error as NSError?{
                                switch nsError.code{
                                case LAError.Code.systemCancel.rawValue:
                                    print("認證過程被系統取消")
                                case LAError.Code.userCancel.rawValue:
                                    print("認證過程被系統取消")
                                case LAError.Code.userFallback.rawValue:
                                    print("使用者選擇輸入密碼")
                                    //用UIAlterController讓使用者輸入密碼
                                    OperationQueue.main.addOperation{
                                        
                                    }
                                default:
                                    //認證失敗，請使用者直接輸入密碼
                                    //用UIAlterController讓使用者輸入密碼
                                    OperationQueue.main.addOperation{
                                        
                                    }
                                }
                            }
                        }
                })
            }
        }
    
*/
    @IBAction func logAsTID(_ sender: Any) {
        // i wish there's a way to let touchid in here, but it's too complex and unnecessary.
        let username = udefault.string(forKey: "username")!
        let password = udefault.string(forKey: "password")!
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) -> () in
            self.performSegue(withIdentifier: "success", sender: self)
        })
        Alamofire.request("http://dinnersys.ddns.net/dinnersys_beta/backend/backend.php?id=\(username)&password=\(password)&cmd=login").responseString{string in
            if string.result.error != nil{
                print("error:\(String(describing: string.error))")
                let alert = UIAlertController(title: "Error", message: "Unexpected Error.\n Please Restart The App.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            let response = string.result.value!
            
            if (response.contains("error login")){
                let alert = UIAlertController(title: "帳號/密碼錯誤", message: "請重新輸入", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: "登入成功", message: "Welcome", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                user.id = username
                user.pw = password
                Alamofire.request("http://dinnersys.ddns.net/dinnersys_beta/backend/backend.php?cmd=get_date").responseData{response in
                    if response.data != nil{
                        let data = response.data
                        let decoder = JSONDecoder()
                        dInfo = try! decoder.decode([dateInfo].self, from: data!)
                        print(dInfo[0])
                    }
                }
            }
        }
    }
    
    @IBAction func submit_online(_ sender: Any) {
        var username : String = ""
        var password : String = ""
        username = usr.text!
        password = pwd.text!
        view.endEditing(true)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) -> () in
            self.performSegue(withIdentifier: "success", sender: self)
        })
        let urlWithPw = dinnerSys.str + "backend/backend.php?id=\(username)&password=\(password)&cmd=login"
        let loginURL = URL(string: urlWithPw)
        var request = URLRequest(url: loginURL!)
        request.httpMethod = "GET"
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
            if (responseString?.contains("error login"))!{
                let alert = UIAlertController(title: "帳號/密碼錯誤", message: "請重新輸入", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: "登入成功", message: "Welcome", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                user.id = username
                user.pw = password
                if(self.remSwitch.isOn){
                    self.udefault.set(username, forKey: "username")
                    self.udefault.set(password, forKey: "password")
                    self.tidButton.isEnabled = true
                    self.tidButton.setTitle("以\(username)的身份登入", for: .normal)
                }
                Alamofire.request("http://dinnersys.ddns.net/dinnersys_beta/backend/backend.php?cmd=get_date").responseData{response in
                    if response.data != nil{
                        let data = response.data
                        let decoder = JSONDecoder()
                        print(data! as NSData)
                        dInfo = try! decoder.decode([dateInfo].self, from: data!)
                        print(dInfo[0])
                    }
                }
                
            }
            print("response:\(String(describing: responseString))")
        }
        task.resume()
        self.usr.text = ""
        self.pwd.text = ""
    }
 
    
    /*
    @IBAction func Submit(_ sender: Any) {
                var username : String = ""
                var password : String = ""
                username = usr.text!
                password = pwd.text!
                view.endEditing(true)
        //Server-side
                if(username == "11705" && password == "1234"){
                    performSegue(withIdentifier: "success", sender: self)
                    user.id = username
                }
                else{
                    let alert = UIAlertController(title: "帳號/密碼錯誤", message: "請重新輸入", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
    
   */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        usr.resignFirstResponder()
        pwd.resignFirstResponder() 
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        udefault = UserDefaults.standard
        if let name = udefault.string(forKey: "username"){
            tidButton.isEnabled = true
            tidButton.setTitle("以\(name)的身份登入", for: .normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


