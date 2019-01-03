//
//	History.swift
//
//	Create by Sean Pai on 4/1/2019
//	Copyright © 2019 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

var historyArr:[History] = []

struct History : Codable {

	let dish : [String]?
	let id : String?
	let money : HistoryMoney?
	let orderMaker : HistoryOrderMaker?
	let recvDate : String?
	let user : HistoryOrderMaker?


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
		money = try HistoryMoney(from: decoder)
		orderMaker = try HistoryOrderMaker(from: decoder)
		recvDate = try values.decodeIfPresent(String.self, forKey: .recvDate)
		user = try HistoryOrderMaker(from: decoder)
	}


}
