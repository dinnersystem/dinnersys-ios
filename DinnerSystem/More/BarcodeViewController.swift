//
//  BarcodeViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2019/4/12.
//  Copyright © 2019 Sean.Inc. All rights reserved.
//

import UIKit
import RSBarcodes_Swift
import AVFoundation
import Crashlytics

class BarcodeViewController: UIViewController {
    var brightness = CGFloat(0.5)
    @IBOutlet var infoText: UILabel!
    @IBOutlet var barcodeImage: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        do{
            let cardResponse = try Data(contentsOf: URL(string: dsURL("get_pos"))!)
            POSInfo = try decoder.decode(CardInfo.self, from: cardResponse)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        brightness = UIScreen.main.brightness
        UIScreen.main.brightness = CGFloat(1.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var image = RSUnifiedCodeGenerator.shared.generateCode(POSInfo.card!, machineReadableCodeObjectType: AVMetadataObject.ObjectType.code39.rawValue)!
        let reImageSize = CGSize(width: image.size.width, height: image.size.height*0.8)
        image = image.resizedImage(newSize: reImageSize)
        barcodeImage.image = image
        infoText.text = """
        姓名：\(POSInfo.name!)
        餘額：\(POSInfo.money!)（非即時）
        卡號：\(POSInfo.card!)
        """
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        UIScreen.main.brightness = brightness
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
