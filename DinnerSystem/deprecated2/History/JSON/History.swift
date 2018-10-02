//
//	History.swift
//
//	Create by Sean Pai on 25/5/2018
//	Copyright © 2018 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

var histArr: [History] = []

struct History : Codable {

	let dish : Dish?
	let id : String?
	let payment : [Payment]?
	let recvDate : String?
	let user : User?


	enum CodingKeys: String, CodingKey {
		case dish
		case id = "id"
		case payment = "payment"
		case recvDate = "recv_date"
		case user
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		dish = try Dish(from: decoder)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		payment = try values.decodeIfPresent([Payment].self, forKey: .payment)
		recvDate = try values.decodeIfPresent(String.self, forKey: .recvDate)
		user = try User(from: decoder)
	}


}
