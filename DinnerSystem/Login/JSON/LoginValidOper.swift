//
//	LoginValidOper.swift
//
//	Create by Sean Pai on 14/9/2018
//	Copyright © 2018 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct LoginValidOper : Codable {

	let changePassword : String?
	let checkRecv : String?
	let deleteSelf : String?
	let getDate : String?
	let getDatetime : String?
	let login : String?
	let logout : String?
	let makeSelfOrder : String?
	let register : String?
	let selectSelf : String?
	let showDish : String?
	let showFactory : String?
	let showMenu : String?
    let selectClass : String?


	enum CodingKeys: String, CodingKey {
		case changePassword = "change_password"
		case checkRecv = "check_recv"
		case deleteSelf = "delete_self"
		case getDate = "get_date"
		case getDatetime = "get_datetime"
		case login = "login"
		case logout = "logout"
		case makeSelfOrder = "make_self_order"
		case register = "register"
		case selectSelf = "select_self"
		case showDish = "show_dish"
		case showFactory = "show_factory"
		case showMenu = "show_menu"
        case selectClass = "select_class"
	}
    //: String? = nil,
	init(changePassword: String? = nil,
        checkRecv: String? = nil,
        deleteSelf: String? = nil,
        getDate: String? = nil,
        getDatetime: String? = nil,
        login: String? = nil,
        logout: String? = nil,
        makeSelfOrder: String? = nil,
        register: String? = nil,
        selectSelf: String? = nil,
        showDish: String? = nil,
        showFactory: String? = nil,
        showMenu: String? = nil,
        selectClass: String? = nil
        ){
		/*
        let values = try decoder.container(keyedBy: CodingKeys.self)
		changePassword = try values.decodeIfPresent(String.self, forKey: .changePassword)
		checkRecv = try values.decodeIfPresent(String.self, forKey: .checkRecv)
		deleteSelf = try values.decodeIfPresent(String.self, forKey: .deleteSelf)
		getDate = try values.decodeIfPresent(String.self, forKey: .getDate)
		getDatetime = try values.decodeIfPresent(String.self, forKey: .getDatetime)
		login = try values.decodeIfPresent(String.self, forKey: .login)
		logout = try values.decodeIfPresent(String.self, forKey: .logout)
		makeSelfOrder = try values.decodeIfPresent(String.self, forKey: .makeSelfOrder)
		register = try values.decodeIfPresent(String.self, forKey: .register)
		selectSelf = try values.decodeIfPresent(String.self, forKey: .selectSelf)
		showDish = try values.decodeIfPresent(String.self, forKey: .showDish)
		showFactory = try values.decodeIfPresent(String.self, forKey: .showFactory)
		showMenu = try values.decodeIfPresent(String.self, forKey: .showMenu)
 */
        self.changePassword = changePassword
        self.checkRecv = checkRecv
        self.deleteSelf = deleteSelf
        self.getDate = getDate
        self.getDatetime = getDatetime
        self.login = login
        self.logout = logout
        self.makeSelfOrder = makeSelfOrder
        self.register = register
        self.selectSelf = selectSelf
        self.showDish = showDish
        self.showFactory = showFactory
        self.showMenu = showMenu
        self.selectClass = selectClass
	}


}
