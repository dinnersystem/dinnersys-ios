//
//  MoreTableViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2018/1/20.
//  Copyright © 2018年 Sean.Inc. All rights reserved.
//

import UIKit
import WebKit
import Alamofire

var counter = 0

class MoreTableViewController: UITableViewController {

    @IBOutlet var viewOrder: UITableViewCell!
    @IBAction func changepw(_ sender: Any) {
        let alert = UIAlertController(title: "更改密碼", message: "請輸入舊密碼與新密碼", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "儲存", style: .default, handler: {
            (action:UIAlertAction) -> () in
            let oldpw = alert.textFields![0] as UITextField
            let newpw = alert.textFields![1] as UITextField
            if(oldpw.text == "" || newpw.text == ""){
                let deniedAlert = UIAlertController(title: "錯誤", message: "格式錯誤", preferredStyle: .alert)
                deniedAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                    (action:UIAlertAction) -> () in
                    self.present(alert, animated: true, completion: nil)
                }))
                self.present(deniedAlert, animated: true, completion: nil)
            }
            else{
                let neWPw = newpw.text!
                if !neWPw.contains(" ") {
                let olDPw = oldpw.text!
                let neWPw = newpw.text!
                if(olDPw == user.pw){
                Alamofire.request("http://dinnersys.ddns.net/dinnersys_beta/backend/backend.php?cmd=change_password&old_pswd=\(olDPw)&new_pswd=\(neWPw)").responseData {data in}
                let okAlert = UIAlertController(title: "成功", message: "已更改密碼", preferredStyle: .alert)
                okAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(okAlert, animated: true, completion: {
                        self.dismiss(animated: true, completion: nil)
                    })
                }else{
                    let deniedAlert = UIAlertController(title: "錯誤", message: "原密碼錯誤", preferredStyle: .alert)
                    deniedAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                        (action:UIAlertAction) -> () in
                        self.present(alert, animated: true, completion: nil)
                    }))
                    self.present(deniedAlert, animated: true, completion: nil)
                }
            }
                else{
                    let deniedAlert = UIAlertController(title: "錯誤", message: "請勿輸入空格", preferredStyle: .alert)
                    deniedAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                        (action:UIAlertAction) -> () in
                        self.present(alert, animated: true, completion: nil)
                    }))
                    self.present(deniedAlert, animated: true, completion: nil)
                }
        }
        })
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addTextField{
            (textfield:UITextField!) -> Void in
            textfield.isSecureTextEntry = true
            textfield.placeholder = "舊密碼"
        }
        alert.addTextField{
            (textfield:UITextField!) -> Void in
            textfield.isSecureTextEntry = true
            textfield.placeholder = "新密碼"
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func logout(_ sender: Any) {
        Alamofire.request("http://dinnersys.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData {data in}
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
            super.viewDidLoad()
        Alamofire.request("http://dinnersys.ddns.net/dinnersys_beta/backend/backend.php?cmd=login&id=\(user.id)&password=\(user.pw)&plugin=yes").responseData{response in
            let data = response.data
            let decoder = JSONDecoder()
            let uInfo: userInfo
            uInfo = try! decoder.decode(userInfo.self, from: data!)
            if uInfo.previleges.contains("系統管理員"){
                self.viewOrder.isUserInteractionEnabled = true
                self.viewOrder.textLabel?.isEnabled = true
            }else{
                if uInfo.previleges.contains("管午餐的人"){
                    self.viewOrder.isUserInteractionEnabled = true
                    self.viewOrder.textLabel?.isEnabled = true
                }else{
                    self.viewOrder.isUserInteractionEnabled = false
                    self.viewOrder.textLabel?.isEnabled = false
                }
            }
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2{
            if counter == 10{
                counter = 0
                self.performSegue(withIdentifier: "egg", sender: self)
            }else{
                counter += 1
                self.performSegue(withIdentifier: "normal", sender: self)
            }
        }
    }
}
