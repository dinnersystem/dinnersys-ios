//
//	Order.swift
//
//	Create by Sean Pai on 4/1/2019
//	Copyright © 2019 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
var orderInfo:[Order] = []

struct Order : Codable {

	let dish : [String]?
	let id : String?
	let money : OrderMoney?
	let orderMaker : OrderMaker?
	let recvDate : String?
	let user : OrderMaker?


	enum CodingKeys: String, CodingKey {
		case dish = "dish"
		case id = "id"
		case money
		case orderMaker
		case recvDate = "recv_date"
		case user
	}
    init(dish : [String]? = nil,
         id : String? = nil,
         money : OrderMoney? = nil,
         orderMaker : OrderMaker? = nil,
         recvDate : String? = nil,
         user : OrderMaker? = nil
        ){
        self.dish = dish
        self.id = id
        self.money = money
        self.orderMaker = orderMaker
        self.recvDate = recvDate
        self.user = user
    }


}
