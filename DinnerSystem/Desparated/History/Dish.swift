//
//	Dish.swift
//
//	Create by Sean Pai on 12/2/2018
//	Copyright © 2018 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Dish : Codable {

	let dishCost : String?
	let dishId : String?
	let dishName : String?


	enum CodingKeys: String, CodingKey {
		case dishCost = "dish_cost"
		case dishId = "dish_id"
		case dishName = "dish_name"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		dishCost = try values.decodeIfPresent(String.self, forKey: .dishCost)
		dishId = try values.decodeIfPresent(String.self, forKey: .dishId)
		dishName = try values.decodeIfPresent(String.self, forKey: .dishName)
	}


}