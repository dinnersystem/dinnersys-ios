//
//	login.swift
//
//	Create by Sean Pai on 22/4/2018
//	Copyright © 2018 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

var userInfo = Login()

struct Login : Codable {

	let classNo : String?
	let id : String?
	let name : String?
	let validOper : [ValidOper]?


	enum CodingKeys: String, CodingKey {
		case classNo = "class_no"
		case id = "id"
		case name = "name"
		case validOper = "valid_oper"
	}
    init(classNo: String? = nil,
         id: String? = nil,
         name: String? = nil,
         validOper: [ValidOper]? = nil){
        self.classNo = classNo
        self.id = id
        self.name = name
        self.validOper = validOper
    }


}
