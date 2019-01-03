//
//	HistoryMoney.swift
//
//	Create by Sean Pai on 4/1/2019
//	Copyright © 2019 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct HistoryMoney : Codable {

	let charge : String?
	let id : String?
	let payment : [HistoryPayment]?


	enum CodingKeys: String, CodingKey {
		case charge = "charge"
		case id = "id"
		case payment = "payment"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		charge = try values.decodeIfPresent(String.self, forKey: .charge)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		payment = try values.decodeIfPresent([HistoryPayment].self, forKey: .payment)
	}


}