//
//	OrderMaker.swift
//
//	Create by Sean Pai on 15/9/2018
//	Copyright © 2018 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct OrderMaker : Codable {

	let classNo : String?
	let id : String?
	let name : String?
	let seatNo : String?
	let vege : OrderVege?


	enum CodingKeys: String, CodingKey {
		case classNo = "class_no"
		case id = "id"
		case name = "name"
		case seatNo = "seat_no"
		case vege
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		classNo = try values.decodeIfPresent(String.self, forKey: .classNo)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		seatNo = try values.decodeIfPresent(String.self, forKey: .seatNo)
		vege = try OrderVege(from: decoder)
	}


}