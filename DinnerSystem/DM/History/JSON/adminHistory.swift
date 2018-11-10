//
//	adminHistory.swift
//
//	Create by Sean Pai on 1/11/2018
//	Copyright © 2018 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

var adminHistArr:[adminHistory] = []

struct adminHistory : Codable {

	let dish : adminHistoryDish?
	let id : String?
	let money : adminHistoryMoney?
	let orderMaker : adminHistoryOrderMaker?
	var recvDate : String?
	let user : adminHistoryOrderMaker?


	enum CodingKeys: String, CodingKey {
		case dish
		case id = "id"
		case money
		case orderMaker
		case recvDate = "recv_date"
		case user
	}
    init(dish : adminHistoryDish? = nil,
         id : String? = nil,
         money : adminHistoryMoney? = nil,
         orderMaker : adminHistoryOrderMaker? = nil,
         recvDate : String? = nil,
         user : adminHistoryOrderMaker? = nil
        ){
        self.dish = dish
        self.id = id
        self.money = money
        self.orderMaker = orderMaker
        self.recvDate = recvDate
        self.user = user
    }



}
