//
//	Order.swift
//
//	Create by Sean Pai on 4/1/2019
//	Copyright © 2019 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
var orderInfo:[Order] = []

struct Order : Codable {

	let dish : [String]?
	let id : String?
	let money : OrderMoney?
	let orderMaker : OrderMaker?
	let recvDate : String?
	let user : OrderMaker?


	enum CodingKeys: String, CodingKey {
		case dish = "dish"
		case id = "id"
		case money
		case orderMaker
		case recvDate = "recv_date"
		case user
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		dish = try values.decodeIfPresent([String].self, forKey: .dish)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		money = try OrderMoney(from: decoder)
		orderMaker = try OrderMaker(from: decoder)
		recvDate = try values.decodeIfPresent(String.self, forKey: .recvDate)
		user = try OrderMaker(from: decoder)
	}


}
