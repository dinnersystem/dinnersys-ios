//
//  misc.swift
//  DinnerSystem
//
//  Created by Sean on 2018/9/13.
//  Copyright © 2018年 Sean.Inc. All rights reserved.
//

import Foundation
import Alamofire

let decoder = JSONDecoder()

func dsURL(_ cmd: String) -> String{
    return "http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=\(cmd)"
}

struct selectedFood {
    static var name: String = ""
    static var id: String = ""
    static var cost: String = ""
}

func logout(){
    Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData{ response in}
}


var usr = ""
var pwd = ""
var fcmToken = ""

let seatNumArr = Array(1...50)
