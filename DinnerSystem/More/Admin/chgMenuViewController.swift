//
//  chgMenuViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2018/3/1.
//  Copyright © 2018年 Sean.Inc. All rights reserved.
//

import UIKit
import Alamofire

class chgMenuViewController: UIViewController {

    @IBOutlet var label: UILabel!
    @IBOutlet var textbox: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "您要更改的編號是第\(selOrder.num)號餐。"
        label.sizeToFit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func chgMenu(_ sender: Any) {
        if textbox.text == "" {
            let alert = UIAlertController(title: "錯誤", message: "請輸入名字", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            if (textbox.text?.contains(" "))!{
                let alert = UIAlertController(title: "錯誤", message: "請勿輸入空白鍵", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                let text = textbox.text!
                Alamofire.request("http://dinnersys.ddns.net/dinnersys_beta/backend/backend.php?dish_id=\(selOrder.num)&dish_name=\(text)&cmd=update_menu").responseData{response in}
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    

}
