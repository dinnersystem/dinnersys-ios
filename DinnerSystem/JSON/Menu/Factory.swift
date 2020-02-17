//
//    Factory.swift
//
//    Create by Sean Pai on 17/3/2019
//    Copyright © 2019 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Factory : Codable {
    
    let allowCustom : String?
    let dailyProduce : String?
    let id : String?
    let lowerBound : String?
    let minimum : String?
    let name : String?
    let paymentTime : String?
    let prepareTime : String?
    let remaining : String?
    let upperBound : String?
    
    
    enum CodingKeys: String, CodingKey {
        case allowCustom = "allow_custom"
        case dailyProduce = "daily_produce"
        case id = "id"
        case lowerBound = "lower_bound"
        case minimum = "minimum"
        case name = "name"
        case paymentTime = "payment_time"
        case prepareTime = "prepare_time"
        case remaining = "remaining"
        case upperBound = "upper_bound"
    }
    init(allowCustom : String? = nil,
         dailyProduce : String? = nil,
         id : String? = nil,
         lowerBound : String? = nil,
         minimum : String? = nil,
         name : String? = nil,
         paymentTime : String? = nil,
         prepareTime : String? = nil,
         remaining : String? = nil,
         upperBound : String? = nil
        ){
        self.allowCustom = allowCustom
        self.dailyProduce = dailyProduce
        self.id = id
        self.lowerBound = lowerBound
        self.minimum = minimum
        self.name = name
        self.paymentTime = paymentTime
        self.prepareTime = prepareTime
        self.remaining = remaining
        self.upperBound = upperBound
    }
    
    
}
