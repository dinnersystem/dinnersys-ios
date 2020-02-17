//
//	HistoryMoney.swift
//
//	Create by Sean Pai on 6/1/2019
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
    init(charge : String? = nil,
         id : String? = nil,
         payment : [HistoryPayment]? = nil
        ){
        self.charge = charge
        self.id = id
        self.payment = payment
    }


}
