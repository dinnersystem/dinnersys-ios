//
//	OrderMaker.swift
//
//	Create by Sean Pai on 4/1/2019
//	Copyright © 2019 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct OrderMaker : Codable {

	let classField : OrderClas?
	let id : String?
	let name : String?
	let prevSum : String?
	let seatNo : String?
	let vege : OrderVege?


	enum CodingKeys: String, CodingKey {
		case classField
		case id = "id"
		case name = "name"
		case prevSum = "prev_sum"
		case seatNo = "seat_no"
		case vege
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		classField = try OrderClas(from: decoder)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		prevSum = try values.decodeIfPresent(String.self, forKey: .prevSum)
		seatNo = try values.decodeIfPresent(String.self, forKey: .seatNo)
		vege = try OrderVege(from: decoder)
	}


}