//
//	Login.swift
//
//	Create by Sean Pai on 29/12/2018
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
	let validOper : [String]?
    let dataCollected: String?
	let vege : LoginVege?


	enum CodingKeys: String, CodingKey {
		case classField
		case id = "id"
		case name = "name"
		case prevSum = "prev_sum"
		case seatNo = "seat_no"
        case dataCollected = "data_collected"
		case validOper = "valid_oper"
		case vege
	}
    init(classField : LoginClas? = nil,
         id : String? = nil,
         name : String? = nil,
         prevSum : String? = nil,
         seatNo : String? = nil,
         dataCollected: String? = nil,
         validOper : [String]? = nil,
         vege : LoginVege? = nil
        ){
        self.classField = classField
        self.id = id
        self.name = name
        self.prevSum = prevSum
        self.seatNo = seatNo
        self.dataCollected = dataCollected
        self.validOper = validOper
        self.vege = vege
    }


}
