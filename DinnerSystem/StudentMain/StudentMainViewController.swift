//
//  StudentMainViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2020/2/17.
//  Copyright © 2020 DinnerSystem Team. All rights reserved.
//

import UIKit
import Crashlytics

class StudentMainViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var barcodeView: UIImageView!
    @IBOutlet var cardDetailLabel: UILabel!
    
    //MARK: - Declarations
    
    
    override func viewWillAppear(_ animated: Bool) {
        do{
            let cardResponse = try Data(contentsOf: URL(string: dsURL("get_pos"))!)     //get POS info
            POSInfo = try decoder.decode(CardInfo.self, from: cardResponse)
            barcodeView.image = getBarcode(POSData: POSInfo) //get barcode image
            cardDetailLabel.text = "卡號：\(POSInfo.card!)\n餘額：\(POSInfo.money!)元（非即時）"
            titleLabel.text = "歡迎使用午餐系統，\n\(POSInfo.name!.trimmingCharacters(in: .whitespacesAndNewlines))."
        }catch let error{
            print(error)
            Crashlytics.sharedInstance().recordError(error)
            let alert = UIAlertController(title: "請重新登入", message: "查詢餘額失敗，我們已經派出最精銳的猴子去修理這個問題，若長時間出現此問題請通知開發人員！", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                (action: UIAlertAction!) -> () in
                logout()
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //sry light here
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func moreButton(_ sender: AnyObject){
        self.performSegue(withIdentifier: "moreSegue", sender: nil)
    }
    
    @IBAction func menuButton(_ sender: Any) {
        self.performSegue(withIdentifier: "menuSegue", sender: nil)
    }
    
    @IBAction func orderButton(_ sender: Any) {
        self.performSegue(withIdentifier: "historySegue", sender: nil)
    }
    
    @IBAction func cart_button(_ sender: Any) {
    }
    
}
