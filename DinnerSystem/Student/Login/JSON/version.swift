//
//  version.swift
//  DinnerSystem
//
//  Created by Sean on 2018/12/30.
//  Copyright © 2018 Sean.Inc. All rights reserved.
//

import Foundation

let verClass = version()

class version: Codable{
    var ios: Int?
    
    init(ios: Int? = nil){
        self.ios = ios
    }
}
