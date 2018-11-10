//
//	OrderDish.swift
//
//	Create by Sean Pai on 1/11/2018
//	Copyright © 2018 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct OrderDish : Codable {

	let department : OrderDepartment?
	let dishCost : String?
	let dishId : String?
	let dishName : String?
	let factory : OrderFactory?
	let isIdle : String?
	let vege : OrderVege?


	enum CodingKeys: String, CodingKey {
		case department
		case dishCost = "dish_cost"
		case dishId = "dish_id"
		case dishName = "dish_name"
		case factory
		case isIdle = "is_idle"
		case vege
	}
    init(department : OrderDepartment? = nil,
         dishCost : String? = nil,
         dishId : String? = nil,
         dishName : String? = nil,
         factory : OrderFactory? = nil,
         isIdle : String? = nil,
         vege : OrderVege? = nil
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
