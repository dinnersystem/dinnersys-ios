//
//	Order.swift
//
//	Create by Sean Pai on 15/9/2018
//	Copyright © 2018 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

var orderInfo:[Order] = []

struct Order : Codable {

	let dish : OrderDish?
	let id : String?
	let orderMaker : OrderMaker?
	let payment : [OrderPayment]?
	let recvDate : String?
	let user : OrderMaker?


	enum CodingKeys: String, CodingKey {
		case dish
		case id = "id"
		case orderMaker
		case payment = "payment"
		case recvDate = "recv_date"
		case user
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		dish = try OrderDish(from: decoder)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		orderMaker = try OrderMaker(from: decoder)
		payment = try values.decodeIfPresent([OrderPayment].self, forKey: .payment)
		recvDate = try values.decodeIfPresent(String.self, forKey: .recvDate)
		user = try OrderMaker(from: decoder)
	}


}
