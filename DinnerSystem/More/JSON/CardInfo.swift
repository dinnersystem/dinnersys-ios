//
//	CardInfo.swift
//
//	Create by Sean Pai on 11/4/2019
//	Copyright © 2019 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct CardInfo : Codable {

	let card : String?
	let money : String?
	let name : String?


	enum CodingKeys: String, CodingKey {
		case card = "card"
		case money = "money"
		case name = "name"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		card = try values.decodeIfPresent(String.self, forKey: .card)
		money = try values.decodeIfPresent(String.self, forKey: .money)
		name = try values.decodeIfPresent(String.self, forKey: .name)
	}


}