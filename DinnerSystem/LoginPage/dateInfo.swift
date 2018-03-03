//
//	dateInfo.swift
//
//	Create by Sean Pai on 28/2/2018
//	Copyright © 2018 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

var dInfo: [dateInfo] = []

struct dateInfo : Codable {

	let friday : String?
	let monday : String?
	let thursday : String?
	let tuesday : String?
	let wednesday : String?


	enum CodingKeys: String, CodingKey {
		case friday = "Friday"
		case monday = "Monday"
		case thursday = "Thursday"
		case tuesday = "Tuesday"
		case wednesday = "Wednesday"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		monday = try values.decodeIfPresent(String.self, forKey: .monday)
		tuesday = try values.decodeIfPresent(String.self, forKey: .tuesday)
		wednesday = try values.decodeIfPresent(String.self, forKey: .wednesday)
        thursday = try values.decodeIfPresent(String.self, forKey: .thursday)
        friday = try values.decodeIfPresent(String.self, forKey: .friday)
	}


}
