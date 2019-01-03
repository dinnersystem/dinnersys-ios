//
//	Menu.swift
//
//	Create by Sean Pai on 4/1/2019
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
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		department = try MenuDepartment(from: decoder)
		dishCost = try values.decodeIfPresent(String.self, forKey: .dishCost)
		dishId = try values.decodeIfPresent(String.self, forKey: .dishId)
		dishName = try values.decodeIfPresent(String.self, forKey: .dishName)
		factory = try MenuFactory(from: decoder)
		isIdle = try values.decodeIfPresent(String.self, forKey: .isIdle)
		vege = try MenuVege(from: decoder)
	}


}
