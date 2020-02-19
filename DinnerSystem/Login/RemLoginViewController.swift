//
//  RemLoginViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2020/2/15.
//  Copyright © 2020 DinnerSystem Team. All rights reserved.
//

import UIKit
import Alamofire
import Crashlytics
import Reachability

class RemLoginViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet var fallbackButton: UIButton!
    @IBOutlet var remButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    
    //MARK: - Declarations
    var uDefault: UserDefaults!
    var activityIndicator = UIActivityIndicatorView()
    var indicatorBackView = UIView()
    
    func verCheck() -> Bool{
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
                return true
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
            let alert = UIAlertController(title: "Oops", message: "發生了不知名的錯誤，請聯繫開發人員!\n\(error.localizedDescription)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            Crashlytics.sharedInstance().recordError(error)
            self.present(alert,animated: true, completion: nil)
        }
        return false
    }
    
    //MARK: - VDL
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        //title layout adapt to smaller device
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        
        //hide the button first
        fallbackButton.isHidden = true
        remButton.isHidden = true
        
        //sry light mode here
        if #available(iOS 13.0, *){
            overrideUserInterfaceStyle = .light
        }
    }
    
    //MARK: - VDA
    override func viewDidAppear(_ animated: Bool) {
        let updatable = verCheck()
        if updatable{
            return
        }
        
        //determine if remPW
        uDefault = UserDefaults.standard
        if let name = uDefault.string(forKey: "studentName"){
            self.remButton.setTitle("以\(name)登入", for: .normal)
            self.remButton.isHidden = false
            self.fallbackButton.isHidden = false
        }else{
            self.performSegue(withIdentifier: "fallbackSegue", sender: self)
        }
    }
    
    @IBAction func fallbackAction(_ sender: Any) {
        //"not you?"
        self.performSegue(withIdentifier: "fallbackSegue", sender: self)
    }
    
    //MARK: - RemLogin
    @IBAction func remLogin(_ sender: Any) {
        //get account&pw
        uDefault = UserDefaults.standard
        usr = uDefault.string(forKey: "userName")!
        pwd = uDefault.string(forKey: "passWord")!
        
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
