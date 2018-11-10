//
//	adminHistoryDepartment.swift
//
//	Create by Sean Pai on 1/11/2018
//	Copyright © 2018 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct adminHistoryDepartment : Codable {

	let factory : adminHistoryFactory?
	let id : String?
	let name : String?


	enum CodingKeys: String, CodingKey {
		case factory
		case id = "id"
		case name = "name"
	}
    init(factory : adminHistoryFactory? = nil,
         id : String? = nil,
         name : String? = nil
        ){
        self.factory = factory
        self.id = id
        self.name = name
    }



}
