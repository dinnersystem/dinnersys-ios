//
//	Login.swift
//
//	Create by Sean Pai on 1/11/2018
//	Copyright © 2018 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

var userInfo = Login()

struct Login : Codable {

	let classField : LoginClas?
	let id : String?
	var name : String?
	let prevSum : String?
	let seatNo : String?
	let validOper : [LoginValidOper]?
	let vege : LoginVege?


	enum CodingKeys: String, CodingKey {
		case classField = "class"
		case id = "id"
		case name = "name"
		case prevSum = "prev_sum"
		case seatNo = "seat_no"
		case validOper = "valid_oper"
		case vege
	}
    init(classField: LoginClas? = nil,
         id:String? = nil,
         name:String? = nil,
         prevSum:String? = nil,
         seatNo:String? = nil,
         validOper:[LoginValidOper]? = nil,
         vege : LoginVege? = nil) {
		self.classField = classField
		self.id = id
		self.name = name
		self.prevSum = prevSum
		self.seatNo = seatNo
		self.validOper = validOper
		self.vege = vege
	}


}
