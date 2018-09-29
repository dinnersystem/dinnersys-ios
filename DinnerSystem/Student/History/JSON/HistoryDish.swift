//
//	HistoryDish.swift
//
//	Create by Sean Pai on 15/9/2018
//	Copyright © 2018 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct HistoryDish : Codable {

	let content : HistoryContent?
	let department : String?
	let dishCost : String?
	let dishId : String?
	let dishName : String?
	let factory : HistoryFactory?
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
		content = try HistoryContent(from: decoder)
		department = try values.decodeIfPresent(String.self, forKey: .department)
		dishCost = try values.decodeIfPresent(String.self, forKey: .dishCost)
		dishId = try values.decodeIfPresent(String.self, forKey: .dishId)
		dishName = try values.decodeIfPresent(String.self, forKey: .dishName)
		factory = try HistoryFactory(from: decoder)
		isCustom = try values.decodeIfPresent(String.self, forKey: .isCustom)
		isIdle = try values.decodeIfPresent(String.self, forKey: .isIdle)
	}


}