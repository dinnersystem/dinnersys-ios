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
import FirebaseCrashlytics

class LoginViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var remSwitch: UISwitch!
    @IBOutlet var orgButton: UIButton!
    
    //MARK: - Declarations
    var uDefault: UserDefaults!
    var activityIndicator = UIActivityIndicatorView()
    var indicatorBackView = UIView()
    var selOrgName = ""
    var selOrgId = ""
    
    //MARK: - VDA
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        self.activityIndicator.startAnimating()
        self.indicatorBackView.isHidden = false
        
        let orgParam: Parameters = ["cmd":"show_organization"]
        AF.request(dsRequestURL, method: .post, parameters: orgParam).responseData{response in
            
            self.indicatorBackView.isHidden = true
            self.activityIndicator.stopAnimating()
            
            if response.error != nil{
                Crashlytics.crashlytics().record(error: response.error!)
                self.present(createAlert("連線失敗", "請注意連線狀態，多次失敗請聯絡開發人員\nError Code: \(response.error!)"),animated: false)
                return
            }
            do{
                orgInfo = try decoder.decode([Organization].self, from: response.data!)
                if(orgInfo.count > 0){
                    self.selOrgId = orgInfo[0].id!
                    self.selOrgName = orgInfo[0].name!
                }
                self.orgButton.setTitle(self.selOrgName, for: .normal)
            } catch let error{
                Crashlytics.crashlytics().record(error: error)
                self.present(createAlert("取得內容失敗", "請注意連線狀態，多次失敗請聯絡開發人員\nError Code: \(error)"),animated: false)
                return
            }
        }
    }
    
    //MARK: - VDL
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        
        //indicator
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.startAnimating()
        indicatorBackView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        indicatorBackView.center = self.view.center
        indicatorBackView.isHidden = false
        indicatorBackView.layer.cornerRadius = 20
        indicatorBackView.alpha = 0.5
        indicatorBackView.backgroundColor = UIColor.lightGray
        self.view.addSubview(indicatorBackView)
        self.view.addSubview(activityIndicator)
        
        //sry light mode here
        if #available(iOS 13.0, *){
            overrideUserInterfaceStyle = .unspecified
        }
        
        //set org name
        orgButton.setTitle(selOrgName, for: .normal)
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
        let loginParam: Parameters = ["cmd": "login", "id": usr, "password": pwd, "device_id": "Hello_From_iOS", "org_id": selOrgId]
        
        //internet reachablity
        let reach = try! Reachability()
        if reach.connection == .unavailable{
            let alert = createAlert("未連線到網路", "請檢查您當前的網路狀態！")
            self.present(alert, animated: true, completion: nil)
            return
        }
//        UIApplication.shared.beginIgnoringInteractionEvents()
        self.activityIndicator.startAnimating()
        self.indicatorBackView.isHidden = false
        
        //actual login
        AF.request(dsRequestURL, method: .post, parameters: loginParam).responseData{ response in
            
            self.indicatorBackView.isHidden = true
            self.activityIndicator.stopAnimating()
            if response.error != nil{
                Crashlytics.crashlytics().record(error: response.error!)
                self.present(createAlert("登入失敗", "請注意連線狀態，多次失敗請聯絡開發人員\nError Code: \(response.error!)"),animated: false)
                return
            }
            
            //respondable fallback
            let responseString = String(data: response.data!, encoding: .utf8)!
            if (responseString.contains("無法登入。")) || (responseString.contains("No")) || (responseString.contains("Invalid") || (responseString == "") || (responseString == "Wrong") || (responseString == "punish") || (responseString == "Punish")){
                let alert = UIAlertController(title: "無法登入", message: "請確認帳號密碼是否錯誤，或選取的學校是否正確。\n錯誤敘述：\(responseString)", preferredStyle: .alert)
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
                    self.uDefault.set(self.selOrgId, forKey: "orgID")
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
                Crashlytics.crashlytics().record(error: error)
                let errorAlert = UIAlertController(title: "Error", message: "不知名的錯誤，請嘗試重新登入或確認帳號密碼是否正確。\n錯誤敘述：\(responseString)", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func chooseOrg(_ sender: Any) {
        let alert = UIAlertController(title: "請選擇學校", message: nil, preferredStyle: .actionSheet)
        for org in orgInfo{
            let action = UIAlertAction(title: org.name!, style: .default, handler: {_ in
                self.selOrgName = org.name!
                self.selOrgId = org.id!
                self.orgButton.setTitle(self.selOrgName, for: .normal)
            })
            alert.addAction(action)
        }
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

