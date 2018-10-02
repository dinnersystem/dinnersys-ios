//
//	Menu.swift
//
//	Create by Sean Pai on 13/9/2018
//	Copyright © 2018 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

var mainMenuArr:[Menu] = []
var taiwanMenuArr:[Menu] = []
var aiJiaMenuArr:[Menu] = []

struct Menu : Codable {

	let content : MenuContent?
	let department : String?
	let dishCost : String?
	let dishId : String?
	let dishName : String?
	let factory : MenuFactory?
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
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		content = try MenuContent(from: decoder)
		department = try values.decodeIfPresent(String.self, forKey: .department)
		dishCost = try values.decodeIfPresent(String.self, forKey: .dishCost)
		dishId = try values.decodeIfPresent(String.self, forKey: .dishId)
		dishName = try values.decodeIfPresent(String.self, forKey: .dishName)
		factory = try MenuFactory(from: decoder)
		isCustom = try values.decodeIfPresent(String.self, forKey: .isCustom)
		isIdle = try values.decodeIfPresent(String.self, forKey: .isIdle)
	}


}
