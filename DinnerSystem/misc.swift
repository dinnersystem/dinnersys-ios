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
let versionNumber = 201900004
func dsURL(_ cmd: String) -> String{
    return "https://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=\(cmd)"
}
let itmsURL = URL(string: "itms-apps://itunes.apple.com/app/id1352943874")!
let dinnersysURL = "https://dinnersystem.ddns.net/dinnersys_beta/"

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
    Alamofire.request("https://dinnersystem.ddns.net/dinnersys_beta/backend/backend.php?cmd=logout").responseData{ response in}
}

struct ord{
    static var url = ""
    static var name = ""
}
var usr = ""
var pwd = ""
var fcmToken = ""
var balance = 0
let seatNumArr = Array(1...50)
