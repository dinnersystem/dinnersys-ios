//
//	Dish.swift
//
//	Create by Sean Pai on 25/5/2018
//	Copyright © 2018 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Dish : Codable {

	let dishCost : String?
	let dishId : String?
	let dishName : String?
	let factory : Factory?
	let isCustom : String?
	let isIdle : String?


	enum CodingKeys: String, CodingKey {
		case dishCost = "dish_cost"
		case dishId = "dish_id"
		case dishName = "dish_name"
		case factory
		case isCustom = "is_custom"
		case isIdle = "is_idle"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		dishCost = try values.decodeIfPresent(String.self, forKey: .dishCost)
		dishId = try values.decodeIfPresent(String.self, forKey: .dishId)
		dishName = try values.decodeIfPresent(String.self, forKey: .dishName)
		factory = try Factory(from: decoder)
		isCustom = try values.decodeIfPresent(String.self, forKey: .isCustom)
		isIdle = try values.decodeIfPresent(String.self, forKey: .isIdle)
	}


}