//
//  MoreTableViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2018/9/16.
//  Copyright © 2018年 Sean.Inc. All rights reserved.
//

import UIKit
import Alamofire

class MoreTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func Logout(_ sender: Any) {
        logout()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func chgPass(_ sender: Any) {
        let chgAlert = UIAlertController(title: "更改密碼", message: "請輸入新密碼與舊密碼", preferredStyle: .alert)
        chgAlert.addAction(UIAlertAction(title: "確定更改", style: .default, handler: {
            (action:UIAlertAction) -> () in
            let oldpw = chgAlert.textFields![0] as UITextField
            let newpw = chgAlert.textFields![1] as UITextField
            let newpw2 = chgAlert.textFields![2] as UITextField
            let oldPassword = oldpw.text!
            let newPassword = newpw.text!
            if (oldpw.text! == "") || (newpw.text! == "") || (newpw2.text! == ""){
                let alert = UIAlertController(title: "請確定有填入所有輸入欄", message: "請再試一次", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                    (action:UIAlertAction) -> () in
                    self.present(chgAlert, animated: true, completion: nil)
                }))
                    self.present(alert, animated: true, completion: nil)
            }else if oldPassword != pwd{
                let alert = UIAlertController(title: "原密碼錯誤", message: "請再試一次", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                    (action:UIAlertAction) -> () in
                    self.present(chgAlert, animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }else if newPassword != newpw2.text!{
                let alert = UIAlertController(title: "新密碼不吻合", message: "請再試一次", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                    (action:UIAlertAction) -> () in
                    self.present(chgAlert, animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }else if newPassword.contains(" "){
                let alert = UIAlertController(title: "請勿輸入空白鍵", message: "請再試一次", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                    (action:UIAlertAction) -> () in
                    self.present(chgAlert, animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }else{
                print("\(dsURL("change_password"))&old_pswd=\(oldPassword)&new_pswd=\(newPassword)")
                Alamofire.request("\(dsURL("change_password"))&old_pswd=\(oldPassword)&new_pswd=\(newPassword)").responseData{ response in
                    if response.error != nil {
                        let errorAlert = UIAlertController(title: "Error", message: "不知名的錯誤，請注意網路連線狀態或聯絡管理員。", preferredStyle: .alert)
                        errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                            (action: UIAlertAction!) -> () in
                            logout()
                            self.dismiss(animated: true, completion: nil)
                        }))
                        self.present(errorAlert, animated: true, completion: nil)
                    }
                    let responseString = String(data: response.data!, encoding: .utf8)!
                    print(responseString)
                    if(responseString == "Invalid string."){
                        let alert = UIAlertController(title: "輸入格式錯誤", message: "請再試一次\n輸入內容僅限大小寫英數及底線!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                            (action:UIAlertAction) -> () in
                            self.present(chgAlert, animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }else if((responseString.contains("short"))){
                        let alert = UIAlertController(title: "輸入格式錯誤", message: "密碼長度需大於等於三字元!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                            (action:UIAlertAction) -> () in
                            self.present(chgAlert, animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }else if responseString == ""{
                        let alert = UIAlertController(title: "您已經登出", message: "請重新登入", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                            (action: UIAlertAction!) -> () in
                            logout()
                            self.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        let alert = UIAlertController(title: "更改成功", message: "請重新登入", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                            (action:UIAlertAction) -> () in
                            Alamofire.request("\(dsURL("logout"))").responseString{resp in}
                            self.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }))
        chgAlert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        chgAlert.addTextField{
                (textfield:UITextField!) -> Void in
                textfield.isSecureTextEntry = true
                textfield.placeholder = "舊密碼"
        }
        chgAlert.addTextField{
            (textfield:UITextField!) -> Void in
            textfield.isSecureTextEntry = true
            textfield.placeholder = "新密碼"
        }
        chgAlert.addTextField{
            (textfield:UITextField!) -> Void in
            textfield.isSecureTextEntry = true
            textfield.placeholder = "請再輸入一次新密碼"
        }
        self.present(chgAlert, animated: true)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    

}
