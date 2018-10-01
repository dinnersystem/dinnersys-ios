//
//	History.swift
//
//	Create by Sean Pai on 15/9/2018
//	Copyright © 2018 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

var historyArr:[History] = []

struct History : Codable {

	let dish : HistoryDish?
	let id : String?
	let orderMaker : HistoryOrderMaker?
	let payment : [HistoryPayment]?
	var recvDate : String? = ""
	let user : HistoryOrderMaker?


	enum CodingKeys: String, CodingKey {
		case dish = "dish"
		case id = "id"
		case orderMaker
		case payment = "payment"
		case recvDate = "recv_date"
		case user = "user"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		dish = try values.decodeIfPresent(HistoryDish.self, forKey: .dish)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		orderMaker = try values.decodeIfPresent(HistoryOrderMaker.self, forKey: .dish)
		payment = try values.decodeIfPresent([HistoryPayment].self, forKey: .payment)
		recvDate = try values.decodeIfPresent(String.self, forKey: .recvDate)
		user = try values.decodeIfPresent(HistoryOrderMaker.self, forKey: .dish)
	}


}
