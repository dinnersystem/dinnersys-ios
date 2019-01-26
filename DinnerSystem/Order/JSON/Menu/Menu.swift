//
//	Menu.swift
//
//	Create by Sean Pai on 26/1/2019
//	Copyright © 2019 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

var mainMenuArr:[Menu] = []
var taiwanMenuArr:[Menu] = []
var aiJiaMenuArr:[Menu] = []
var cafetMenuArr:[Menu] = []
var guanDonMenuArr:[Menu] = []
var originMenuArr:[Menu] = []

struct Menu : Codable {
    

	let dailyProduce : String?
	let department : MenuDepartment?
	let dishCost : String?
	let dishId : String?
	let dishName : String?
	let isIdle : String?
	var remaining : String?
	let vege : MenuVege?


	enum CodingKeys: String, CodingKey {
		case dailyProduce = "daily_produce"
		case department
		case dishCost = "dish_cost"
		case dishId = "dish_id"
		case dishName = "dish_name"
		case isIdle = "is_idle"
		case remaining = "remaining"
		case vege
	}
    init(dailyProduce : String? = nil,
         department : MenuDepartment? = nil,
         dishCost : String? = nil,
         dishId : String? = nil,
         dishName : String? = nil,
         isIdle : String? = nil,
         remaining : String? = nil,
         vege : MenuVege? = nil
        ){
        self.dailyProduce = dailyProduce
        self.department = department
        self.dishCost = dishCost
        self.dishId = dishId
        self.dishName = dishName
        self.isIdle = isIdle
        self.remaining = remaining
        self.vege = vege
    }


}
