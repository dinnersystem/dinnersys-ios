//
//	ValidOper.swift
//
//	Create by Sean Pai on 3/5/2018
//	Copyright © 2018 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct ValidOper : Codable {

	let changePassword : String?
	let checkRecv : String?
	let deleteOrder : String?
	let getCustomDishId : String?
	let getDate : String?
	let getDatetime : String?
	let login : String?
	let logout : String?
	let makeOrder : String?
	let paymentDm : String?
	let register : String?
	let selectSelf : String?
	let showDish : String?
	let showFactory : String?
	let showMenu : String?


	enum CodingKeys: String, CodingKey {
		case changePassword = "change_password"
		case checkRecv = "check_recv"
		case deleteOrder = "delete_order"
		case getCustomDishId = "get_custom_dish_id"
		case getDate = "get_date"
		case getDatetime = "get_datetime"
		case login = "login"
		case logout = "logout"
		case makeOrder = "make_order"
		case paymentDm = "payment_dm"
		case register = "register"
		case selectSelf = "select_self"
		case showDish = "show_dish"
		case showFactory = "show_factory"
		case showMenu = "show_menu"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		changePassword = try values.decodeIfPresent(String.self, forKey: .changePassword)
		checkRecv = try values.decodeIfPresent(String.self, forKey: .checkRecv)
		deleteOrder = try values.decodeIfPresent(String.self, forKey: .deleteOrder)
		getCustomDishId = try values.decodeIfPresent(String.self, forKey: .getCustomDishId)
		getDate = try values.decodeIfPresent(String.self, forKey: .getDate)
		getDatetime = try values.decodeIfPresent(String.self, forKey: .getDatetime)
		login = try values.decodeIfPresent(String.self, forKey: .login)
		logout = try values.decodeIfPresent(String.self, forKey: .logout)
		makeOrder = try values.decodeIfPresent(String.self, forKey: .makeOrder)
		paymentDm = try values.decodeIfPresent(String.self, forKey: .paymentDm)
		register = try values.decodeIfPresent(String.self, forKey: .register)
		selectSelf = try values.decodeIfPresent(String.self, forKey: .selectSelf)
		showDish = try values.decodeIfPresent(String.self, forKey: .showDish)
		showFactory = try values.decodeIfPresent(String.self, forKey: .showFactory)
		showMenu = try values.decodeIfPresent(String.self, forKey: .showMenu)
	}


}