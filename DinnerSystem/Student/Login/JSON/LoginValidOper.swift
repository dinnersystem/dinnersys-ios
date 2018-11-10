//
//	LoginValidOper.swift
//
//	Create by Sean Pai on 1/11/2018
//	Copyright © 2018 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct LoginValidOper : Codable {

	let changePassword : String?
	let deleteSelf : String?
	let login : String?
	let logout : String?
	let makeSelfOrder : String?
	let selectSelf : String?
	let showDish : String?
    let selectClass : String?


	enum CodingKeys: String, CodingKey {
		case changePassword = "change_password"
		case deleteSelf = "delete_self"
		case login = "login"
		case logout = "logout"
		case makeSelfOrder = "make_self_order"
		case selectSelf = "select_self"
		case showDish = "show_dish"
        case selectClass = "select_class"
	}
    init(changePassword : String? = nil,
         deleteSelf : String? = nil,
         login : String? = nil,
         logout : String? = nil,
         makeSelfOrder : String? = nil,
         selectSelf : String? = nil,
         showDish : String? = nil,
         selectClass : String? = nil){
		self.changePassword = changePassword
        self.deleteSelf = deleteSelf
        self.login = login
        self.logout = logout
        self.makeSelfOrder = makeSelfOrder
        self.selectSelf = selectSelf
        self.showDish = showDish
        self.selectClass = selectClass
	}


}
