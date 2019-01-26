//
//	HistoryVege.swift
//
//	Create by Sean Pai on 6/1/2019
//	Copyright © 2019 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct HistoryVege : Codable {
    
    let name : String?
    let number : String?
    
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case number = "number"
    }
    init(name : String? = nil,
         number : String? = nil
        ){
        self.name = name
        self.number = number
    }
    
    
}
