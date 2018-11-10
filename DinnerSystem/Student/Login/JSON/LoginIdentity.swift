//
//	LoginIdentity.swift
//
//	Create by Sean Pai on 1/11/2018
//	Copyright © 2018 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct LoginIdentity : Codable {

	let 0 : String?
	let 1 : String?


	enum CodingKeys: String, CodingKey {
		case 0 = "0"
		case 1 = "1"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		0 = try values.decodeIfPresent(String.self, forKey: .0)
		1 = try values.decodeIfPresent(String.self, forKey: .1)
	}


}