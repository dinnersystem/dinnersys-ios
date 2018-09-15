//
//	Login.swift
//
//	Create by Sean Pai on 14/9/2018
//	Copyright © 2018 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

var userInfo = Login()

struct Login : Codable {

	let classNo : String?
	let id : String?
	var name : String? = ""
	let seatNo : String?
	let validOper : [LoginValidOper]?
	let vege : LoginVege?


	enum CodingKeys: String, CodingKey {
		case classNo = "class_no"
		case id = "id"
		case name = "name"
		case seatNo = "seat_no"
		case validOper = "valid_oper"
		case vege
	}
    init(classNo: String? = nil,
         id: String? = nil,
         name: String? = nil,
         validOper: [LoginValidOper]? = nil,
         seatNo : String? = nil,
         vege : LoginVege? = nil){
        self.classNo = classNo
        self.id = id
        self.name = name
        self.validOper = validOper
        self.seatNo = seatNo
        self.vege = vege
    }


}
