//
//  RegisterViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2018/4/22.
//  Copyright © 2018年 Sean.Inc. All rights reserved.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController {
    
    //MARK: - Declaration
    
    @IBOutlet var confirmPwd: UITextField!
    @IBOutlet var listView: UIView!
    @IBOutlet var list: UIScrollView!
    @IBOutlet var userName: UITextField!
    @IBOutlet var userId: UITextField!
    @IBOutlet var userPwd: UITextField!
    @IBOutlet var userPhone: UITextField!
    @IBOutlet var userEmail: UITextField!
    @IBOutlet var userVeg: UISegmentedControl!
    @IBOutlet var userGender: UISegmentedControl!
    var veg = 0
    var gen = ""
    
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        list.contentSize = listView.frame.size
    }
    
    //MARK: - submitInfo
    @IBAction func submit(_ sender: Any) {
        if confirmPwd.text != userPwd.text{
            let alert = UIAlertController(title: "密碼不一致", message: "請確認密碼是否輸入正確", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
        veg = userVeg.selectedSegmentIndex
        if userGender.selectedSegmentIndex == 0{
            gen = "MALE"
        }else{
            if userGender.selectedSegmentIndex == 1{
                gen = "FEMALE"
            }else{
                gen = "OTHER"
            }
        }
        let name = userName.text!
        let id = userId.text!
        let pwd = userPwd.text!
        let phone = userPhone.text!
        let email = userEmail.text!
        let regstring = "\(dinnersys.url)?cmd=register&user_name=\(name)&phone_number=\(phone)&is_vege=\(veg)&gender=\(gen)&email=\(email)&login_id=\(id)&password=\(pwd)/"
        Alamofire.request(regstring).responseString{response in
            let string = response.result.value!
            if string.contains("repeated login id") {
                let alert = UIAlertController(title: "輸入有誤", message: "帳號已重複", preferredStyle: .alert)
                alert.addAction(self.okAction)
                self.present(alert, animated: true, completion: nil)
            }else{
                if string.contains("Invalid string."){
                    let alert = UIAlertController(title: "輸入有誤", message: "不符合格式", preferredStyle: .alert)
                    alert.addAction(self.okAction)
                    self.present(alert, animated: true, completion: nil)
                }else{
                    if string.contains("Succesfully registered user."){
                        let alert = UIAlertController(title: "成功註冊", message: "請登入系統", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                            (action: UIAlertAction!) -> () in
                            self.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
}
