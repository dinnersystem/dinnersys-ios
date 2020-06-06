//
//  Barcode.swift
//  DinnerSystem
//
//  Created by Sean on 2020/2/17.
//  Copyright © 2020 DinnerSystem Team. All rights reserved.
//

import Foundation
import Alamofire
import RSBarcodes_Swift
import AVFoundation


func getBarcode(POSData: CardInfo) -> UIImage{
    let barcodeCode = POSData.card!.uppercased()
    let image = RSUnifiedCodeGenerator.shared.generateCode(barcodeCode, machineReadableCodeObjectType: AVMetadataObject.ObjectType.code39.rawValue)!
    let reImageSize = CGSize(width: image.size.width, height: image.size.height)
    return image.resizedImage(newSize: reImageSize)
}


