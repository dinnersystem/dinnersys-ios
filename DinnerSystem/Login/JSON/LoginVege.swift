//
//	LoginVege.swift
//
//	Create by Sean Pai on 14/9/2018
//	Copyright © 2018 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct LoginVege : Codable {

	let name : String?
	let number : String?


	enum CodingKeys: String, CodingKey {
		case name = "name"
		case number = "number"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		number = try values.decodeIfPresent(String.self, forKey: .number)
	}


}