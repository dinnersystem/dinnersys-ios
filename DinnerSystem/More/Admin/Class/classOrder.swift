//
//	classOrder.swift
//
//	Create by Sean Pai on 28/2/2018
//	Copyright © 2018 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation




struct classOrder : Codable {

	let dish : classDish?
	let dishCharge : String
	let dishId : String
	let dishName : String
	let orderDate : String
    var paidStatus : String
	let recvDate : String
	let user : classUser?
	let userId : String
	let userName : String


	enum CodingKeys: String, CodingKey {
		case dish
		case dishCharge = "dish_charge"
		case dishId = "dish_id"
		case dishName = "dish_name"
		case orderDate = "order_date"
		case paidStatus = "paid_status"
		case recvDate = "recv_date"
		case user
		case userId = "user_id"
		case userName = "user_name"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		dish = try classDish(from: decoder)
		dishCharge = try values.decodeIfPresent(String.self, forKey: .dishCharge)!
		dishId = try values.decodeIfPresent(String.self, forKey: .dishId)!
		dishName = try values.decodeIfPresent(String.self, forKey: .dishName)!
		orderDate = try values.decodeIfPresent(String.self, forKey: .orderDate)!
		paidStatus = try values.decodeIfPresent(String.self, forKey: .paidStatus)!
		recvDate = try values.decodeIfPresent(String.self, forKey: .recvDate)!
		user = try classUser(from: decoder)
		userId = try values.decodeIfPresent(String.self, forKey: .userId)!
		userName = try values.decodeIfPresent(String.self, forKey: .userName)!
	}

    
    

}
var allArr: [classOrder] = []
var monArr: [classOrder] = []
var tueArr: [classOrder] = []
var wedArr: [classOrder] = []
var thuArr: [classOrder] = []
var friArr: [classOrder] = []
