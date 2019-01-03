//
//	OrderPayment.swift
//
//	Create by Sean Pai on 4/1/2019
//	Copyright © 2019 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct OrderPayment : Codable {

	let ableDt : String?
	let freezeDt : String?
	let id : String?
	let name : String?
	let paid : Bool?
	let paidDt : String?
	let reversable : String?


	enum CodingKeys: String, CodingKey {
		case ableDt = "able_dt"
		case freezeDt = "freeze_dt"
		case id = "id"
		case name = "name"
		case paid = "paid"
		case paidDt = "paid_dt"
		case reversable = "reversable"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		ableDt = try values.decodeIfPresent(String.self, forKey: .ableDt)
		freezeDt = try values.decodeIfPresent(String.self, forKey: .freezeDt)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		paid = try values.decodeIfPresent(Bool.self, forKey: .paid)
		paidDt = try values.decodeIfPresent(String.self, forKey: .paidDt)
		reversable = try values.decodeIfPresent(String.self, forKey: .reversable)
	}


}