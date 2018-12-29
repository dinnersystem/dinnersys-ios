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
    return "https://dstmp.ddns.net/dinnersys_beta/backend/backend.php?cmd=\(cmd)"
}

struct selectedFood {
    static var name: String = ""
    static var id: String = ""
    static var cost: String = ""
}

/*
struct loginInfo{
    static var usr = ""
    static var pwd = ""
}
*/

func logout(){
    Alamofire.request("http://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData{ response in}
}
struct ord{
    static var url = ""
    static var name = ""
}

var usr = ""
var pwd = ""
var fcmToken = ""

let seatNumArr = Array(1...50)
