//
//	Menu.swift
//
//	Create by Sean Pai on 1/11/2018
//	Copyright © 2018 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

var mainMenuArr:[Menu] = []
var taiwanMenuArr:[Menu] = []
var aiJiaMenuArr:[Menu] = []
var cafetMenuArr:[Menu] = []


struct Menu : Codable {

	let department : MenuDepartment?
	let dishCost : String?
	let dishId : String?
	let dishName : String?
	let factory : MenuFactory?
	let isIdle : String?
	let vege : MenuVege?


	enum CodingKeys: String, CodingKey {
		case department
		case dishCost = "dish_cost"
		case dishId = "dish_id"
		case dishName = "dish_name"
		case factory
		case isIdle = "is_idle"
		case vege
	}
    init(department : MenuDepartment? = nil,
         dishCost : String? = nil,
         dishId : String? = nil,
         dishName : String? = nil,
         factory : MenuFactory? = nil,
         isIdle : String? = nil,
         vege : MenuVege? = nil
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
