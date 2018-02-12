//
//  History.swift
//  DinnerSystem
//
//  Created by Sean on 2018/2/10.
//  Copyright © 2018年 Sean.Inc. All rights reserved.
//

import Foundation


var history:[History] = []

struct History : Codable {
    
    let dishCharge : String?
    let dishId : String
    let dishName : String?
    let paidStatus : String?
    let userId : String?
    let userName : String?
    
    
    enum CodingKeys: String, CodingKey {
        case dishCharge = "dish_charge"
        case dishId = "dish_id"
        case dishName = "dish_name"
        case paidStatus = "paid_status"
        case userId = "user_id"
        case userName = "user_name"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        dishCharge = try values.decodeIfPresent(String.self, forKey: .dishCharge)
        dishId = (try values.decodeIfPresent(String.self, forKey: .dishId))!
        dishName = try values.decodeIfPresent(String.self, forKey: .dishName)
        paidStatus = try values.decodeIfPresent(String.self, forKey: .paidStatus)
        userId = try values.decodeIfPresent(String.self, forKey: .userId)
        userName = try values.decodeIfPresent(String.self, forKey: .userName)
}


}
