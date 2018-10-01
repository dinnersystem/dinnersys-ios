//
//	adminHistory.swift
//
//	Create by Sean Pai on 23/9/2018
//	Copyright © 2018 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

var adminHistArr: [adminHistory] = []

struct adminHistory : Codable {

	let dish : adminDish?
	let id : String?
	let orderMaker : adminOrderMaker?
	let payment : [adminPayment]?
	var recvDate : String?
	let user : adminOrderMaker?


	enum CodingKeys: String, CodingKey {
		case dish
		case id = "id"
		case orderMaker
		case payment = "payment"
		case recvDate = "recv_date"
		case user
	}
    init(dish: adminDish? = nil,
         id: String? = nil,
         orderMaker: adminOrderMaker? = nil,
         payment: [adminPayment]? = nil,
         recvDate: String? = nil,
         user: adminOrderMaker? = nil) {
        self.dish = dish
        self.id = id
        self.orderMaker = orderMaker
        self.payment = payment
        self.recvDate = recvDate
        self.user = user
    }


}
