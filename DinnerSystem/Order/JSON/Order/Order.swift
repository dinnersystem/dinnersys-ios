//
//	Order.swift
//
//	Create by Sean Pai on 4/1/2019
//	Copyright © 2019 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
var orderInfo:[Order] = []

struct Order : Codable {

	let id : String?

	enum CodingKeys: String, CodingKey {
        case id = "id"
	}
    init(id : String? = nil){
        self.id = id
    }


}
