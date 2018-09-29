//
//	adminDish.swift
//
//	Create by Sean Pai on 23/9/2018
//	Copyright © 2018 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct adminDish : Codable {

	let content : adminContent?
	let department : String?
	let dishCost : String?
	let dishId : String?
	let dishName : String?
	let factory : adminFactory?
	let isCustom : String?
	let isIdle : String?


	enum CodingKeys: String, CodingKey {
		case content
		case department = "department"
		case dishCost = "dish_cost"
		case dishId = "dish_id"
		case dishName = "dish_name"
		case factory
		case isCustom = "is_custom"
		case isIdle = "is_idle"
	}
    init(content:adminContent? = nil,
         department:String? = nil,
         dishCost:String? = nil,
         dishId:String? = nil,
         dishName:String? = nil,
         factory:adminFactory? = nil,
         isCustom:String? = nil,
         isIdle:String? = nil) {
        self.content = content
        self.department = department
        self.dishCost = dishCost
        self.dishId = dishId
        self.dishName = dishName
        self.factory = factory
        self.isCustom = isCustom
        self.isIdle = isIdle
    }


}
