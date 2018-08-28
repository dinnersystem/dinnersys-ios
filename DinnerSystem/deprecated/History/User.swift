//
//	User.swift
//
//	Create by Sean Pai on 12/2/2018
//	Copyright © 2018 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct User : Codable {

	let classField : String?
	let ipaddress : String?
	let previleges : String?
	let userId : String?
	let userName : String?


	enum CodingKeys: String, CodingKey {
		case classField = "class"
		case ipaddress = "ipaddress"
		case previleges = "previleges"
		case userId = "user_id"
		case userName = "user_name"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		classField = try values.decodeIfPresent(String.self, forKey: .classField)
		ipaddress = try values.decodeIfPresent(String.self, forKey: .ipaddress)
		previleges = try values.decodeIfPresent(String.self, forKey: .previleges)
		userId = try values.decodeIfPresent(String.self, forKey: .userId)
		userName = try values.decodeIfPresent(String.self, forKey: .userName)
	}


}