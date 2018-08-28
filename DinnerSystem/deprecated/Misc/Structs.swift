//
//  Structs.swift
//  DinnerSystem
//
//  Created by Sean on 2018/1/19.
//  Copyright © 2018年 Sean.Inc. All rights reserved.
//

import Foundation
import Alamofire

struct user {
    static var id = ""
    static var name = ""
    static var prev = ""
    static var pw = ""
}

struct dinnerSys {
    static var url = URL(string: "http://dinnersys.ddns.net/dinnersys_beta/")
    static var str: String = "http://dinnersys.ddns.net/dinnersys_beta/"
}

struct selDate {
    static var year = 0
    static var month = 0
    static var day = 0
    static var hour = 0
    static var min = 0
}
