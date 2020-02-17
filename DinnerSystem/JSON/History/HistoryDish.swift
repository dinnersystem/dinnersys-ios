//
//	HistoryDish.swift
//
//	Create by Sean Pai on 6/1/2019
//	Copyright © 2019 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct HistoryDish : Codable {

	let department : Department?
	let dishCost : String?
	let dishId : String?
	let dishName : String?
	let factory : Factory?
	let isIdle : String?
	let vege : Vege?


	enum CodingKeys: String, CodingKey {
		case department
		case dishCost = "dish_cost"
		case dishId = "dish_id"
		case dishName = "dish_name"
		case factory
		case isIdle = "is_idle"
		case vege
	}
    init(department : Department? = nil,
         dishCost : String? = nil,
         dishId : String? = nil,
         dishName : String? = nil,
         factory : Factory? = nil,
         isIdle : String? = nil,
         vege : Vege? = nil
        ){
        self.department = department
        self.dishCost = dishCost
        self.dishId = dishId
        self.dishName = dishName
        self.factory = factory
        self.isIdle = isIdle
        self.vege = vege
    }


}
