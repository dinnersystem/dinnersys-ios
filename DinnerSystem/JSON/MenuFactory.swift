//
//	MenuFactory.swift
//
//	Create by Sean Pai on 13/9/2018
//	Copyright © 2018 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct MenuFactory : Codable {

	let disabled : String?
	let id : String?
	let lowerBound : String?
	let name : String?
	let prepareTime : String?
	let upperBound : String?


	enum CodingKeys: String, CodingKey {
		case disabled = "disabled"
		case id = "id"
		case lowerBound = "lower_bound"
		case name = "name"
		case prepareTime = "prepare_time"
		case upperBound = "upper_bound"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		disabled = try values.decodeIfPresent(String.self, forKey: .disabled)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		lowerBound = try values.decodeIfPresent(String.self, forKey: .lowerBound)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		prepareTime = try values.decodeIfPresent(String.self, forKey: .prepareTime)
		upperBound = try values.decodeIfPresent(String.self, forKey: .upperBound)
	}


}