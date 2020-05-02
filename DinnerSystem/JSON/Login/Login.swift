//
//	Login.swift
//
//	Create by Sean Pai on 2/5/2020
//	Copyright © 2020 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

var userInfo = Login()

struct Login : Codable {

    let card : String?
	let classField : LoginClas?
	let dailyLimit : String?
	let id : String?
	let money : String?
	var name : String?
	let organization : LoginOrganization?
	let prevSum : String?
	let seatNo : String?
	let validOper : [String]?
	let vege : LoginVege?


	enum CodingKeys: String, CodingKey {
		case card = "card"
		case classField
		case dailyLimit = "daily_limit"
		case id = "id"
		case money = "money"
		case name = "name"
		case organization
		case prevSum = "prev_sum"
		case seatNo = "seat_no"
		case validOper = "valid_oper"
		case vege
	}
    init(card : String? = nil,
         classField : LoginClas? = nil,
         dailyLimit : String? = nil,
         id : String? = nil,
         money : String? = nil,
         name : String? = nil,
         organization : LoginOrganization? = nil,
         prevSum : String? = nil,
         seatNo : String? = nil,
         validOper : [String]? = nil,
         vege : LoginVege? = nil
    ){
        self.card = card
        self.classField = classField
        self.dailyLimit = dailyLimit
        self.id = id
        self.money = money
        self.name = name
        self.organization = organization
        self.prevSum = prevSum
        self.seatNo = seatNo
        self.validOper = validOper
        self.vege = vege
    }


}
