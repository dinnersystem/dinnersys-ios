//
//	Organization.swift
//
//	Create by Sean Pai on 1/5/2020
//	Copyright © 2020 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Organization : Codable {

	let id : String?
	let name : String?


	enum CodingKeys: String, CodingKey {
		case id = "id"
		case name = "name"
	}
    init(id : String? = nil,
         name : String? = nil
    ){
        self.id = id
        self.name = name
    }

}
