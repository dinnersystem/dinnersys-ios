//
//	OrderPayment.swift
//
//	Create by Sean Pai on 1/11/2018
//	Copyright © 2018 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct OrderPayment : Codable {

	let ableDt : String?
	let freezeDt : String?
	let id : String?
	let name : String?
	let paid : String?
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
    init(ableDt : String? = nil,
         freezeDt : String? = nil,
         id : String? = nil,
         name : String? = nil,
         paid : String? = nil,
         paidDt : String? = nil,
         reversable : String? = nil
        ){
        self.ableDt = ableDt
        self.freezeDt = freezeDt
        self.id = id
        self.name = name
        self.paid = paid
        self.paidDt = paidDt
        self.reversable = reversable
    }


}
