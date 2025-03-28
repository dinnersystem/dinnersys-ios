//
//	HistoryOrderMaker.swift
//
//	Create by Sean Pai on 6/1/2019
//	Copyright © 2019 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct HistoryOrderMaker : Codable {

	let classField : HistoryClas?
	let id : String?
	let name : String?
	let prevSum : String?
	let seatNo : String?
	let vege : Vege?


	enum CodingKeys: String, CodingKey {
		case classField
		case id = "id"
		case name = "name"
		case prevSum = "prev_sum"
		case seatNo = "seat_no"
		case vege
	}
    init(classField : HistoryClas? = nil,
         id : String? = nil,
         name : String? = nil,
         prevSum : String? = nil,
         seatNo : String? = nil,
         vege : Vege? = nil
        ){
        self.classField = classField
        self.id = id
        self.name = name
        self.prevSum = prevSum
        self.seatNo = seatNo
        self.vege = vege
    }


}
