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
    var barcodeImage: UIImage!
    
    override func viewWillAppear(_ animated: Bool) {
        do{
            let cardResponse = try Data(contentsOf: URL(string: dsURL("get_pos"))!)
            POSInfo = try decoder.decode(CardInfo.self, from: cardResponse)
            barcodeImage = getBarcode(POSData: POSInfo)
            barcodeView.image = barcodeImage
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
    

    

}
