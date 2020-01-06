//
//	Menu.swift
//
//	Create by Sean Pai on 26/1/2019
//	Copyright © 2019 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

var mainMenuArr:[Menu] = []
var originMenuArr:[Menu] = []
var randomMenuArr:[Menu] = []
var splitMainMenuArr: [String:[Menu]] = [:]
var selectedMenuArr: [Menu] = []

struct Menu : Codable {
    
    let bestSeller : String?
	let dailyProduce : String?
	let department : Department?
	let dishCost : String?
	let dishId : String?
	let dishName : String?
	let isIdle : String?
	var remaining : String?
	let vege : Vege?


	enum CodingKeys: String, CodingKey {
        case bestSeller = "best_seller"
		case dailyProduce = "daily_produce"
		case department
		case dishCost = "dish_cost"
		case dishId = "dish_id"
		case dishName = "dish_name"
		case isIdle = "is_idle"
		case remaining = "remaining"
		case vege
	}
    init(bestSeller : String? = nil,
        dailyProduce : String? = nil,
        department : Department? = nil,
        dishCost : String? = nil,
        dishId : String? = nil,
        dishName : String? = nil,
        isIdle : String? = nil,
        remaining : String? = nil,
        vege : Vege? = nil
        ){
        self.bestSeller = bestSeller
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
