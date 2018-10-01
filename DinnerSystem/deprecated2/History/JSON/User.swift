//
//	User.swift
//
//	Create by Sean Pai on 25/5/2018
//	Copyright © 2018 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct User : Codable {

	let classNo : String?
	let id : String?
	let name : String?


	enum CodingKeys: String, CodingKey {
		case classNo = "class_no"
		case id = "id"
		case name = "name"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		classNo = try values.decodeIfPresent(String.self, forKey: .classNo)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
	}


}