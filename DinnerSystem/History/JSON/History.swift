//
//	History.swift
//
//	Create by Sean Pai on 6/1/2019
//	Copyright © 2019 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

var historyArr:[History] = []

struct History : Codable {

	let dish : [HistoryDish]?
	let id : String?
	let money : HistoryMoney?
	let orderMaker : HistoryOrderMaker?
	var recvDate : String?
	let user : HistoryOrderMaker?


	enum CodingKeys: String, CodingKey {
		case dish = "dish"
		case id = "id"
		case money
		case orderMaker
		case recvDate = "recv_date"
		case user
	}
    init(dish : [HistoryDish]? = nil,
         id : String? = nil,
         money : HistoryMoney? = nil,
         orderMaker : HistoryOrderMaker? = nil,
         recvDate : String? = nil,
         user : HistoryOrderMaker? = nil
        ){
        self.dish = dish
        self.id = id
        self.money = money
        self.orderMaker = orderMaker
        self.recvDate = recvDate
        self.user = user
    }


}
