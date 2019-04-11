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

class BarcodeViewController: UIViewController {

    @IBOutlet var infoText: UILabel!
    @IBOutlet var barcodeImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        var image = RSUnifiedCodeGenerator.shared.generateCode(POSInfo.card!, machineReadableCodeObjectType: AVMetadataObject.ObjectType.code39.rawValue)!
        let reImageSize = CGSize(width: image.size.width, height: image.size.height/2)
        image = image.resizedImage(newSize: reImageSize)
        barcodeImage.image = image
        infoText.text = """
        姓名：\(POSInfo.name!)
        餘額：\(POSInfo.money!)（非即時）
        卡號：\(POSInfo.card!)
        """
        // Do any additional setup after loading the view.
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
