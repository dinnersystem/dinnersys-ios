//
//  BonusViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2019/1/22.
//  Copyright © 2019 Sean.Inc. All rights reserved.
//

import UIKit
import Alamofire

class BonusViewController: UIViewController {

    @IBOutlet var image: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        Alamofire.request("\(dinnersysURL)/frontend/images/dinnersys0.png").responseData{response in
            if response.error != nil{
                let alert = UIAlertController(title: "請注意網路狀態", message: "讀取資料錯誤", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                    (action: UIAlertAction!) -> () in
                    logout()
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }else{
                let dinnersys0 = UIImage(data: response.data!)
                self.image.image = dinnersys0!
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
