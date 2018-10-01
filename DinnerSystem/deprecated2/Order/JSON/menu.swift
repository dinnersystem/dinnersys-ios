//
//	menu.swift
//
//	Create by Sean Pai on 25/5/2018
//	Copyright © 2018 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

var menu1Arr: [menu] = []
var menu2Arr: [menu] = []
var menu3Arr: [menu] = []
var menu4Arr: [menu] = []

struct menu : Codable {

	let dishAble : String?
	let dishCost : String?
	let dishId : String?
	let dishName : String?
	let factory : Factory?
	let ingreAble : String?
	let isIdle : String?


	enum CodingKeys: String, CodingKey {
		case dishAble = "dish_able"
		case dishCost = "dish_cost"
		case dishId = "dish_id"
		case dishName = "dish_name"
		case factory
		case ingreAble = "ingre_able"
		case isIdle = "is_idle"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		dishAble = try values.decodeIfPresent(String.self, forKey: .dishAble)
		dishCost = try values.decodeIfPresent(String.self, forKey: .dishCost)
		dishId = try values.decodeIfPresent(String.self, forKey: .dishId)
		dishName = try values.decodeIfPresent(String.self, forKey: .dishName)
		factory = try Factory(from: decoder)
		ingreAble = try values.decodeIfPresent(String.self, forKey: .ingreAble)
		isIdle = try values.decodeIfPresent(String.self, forKey: .isIdle)
	}


}
