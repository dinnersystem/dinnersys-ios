//
//	HistoryClas.swift
//
//	Create by Sean Pai on 4/1/2019
//	Copyright © 2019 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct HistoryClas : Codable {

	let classNo : String?
	let grade : String?
	let id : String?
	let year : String?


	enum CodingKeys: String, CodingKey {
		case classNo = "class_no"
		case grade = "grade"
		case id = "id"
		case year = "year"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		classNo = try values.decodeIfPresent(String.self, forKey: .classNo)
		grade = try values.decodeIfPresent(String.self, forKey: .grade)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		year = try values.decodeIfPresent(String.self, forKey: .year)
	}


}