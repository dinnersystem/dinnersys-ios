//
//	HistoryClas.swift
//
//	Create by Sean Pai on 1/11/2018
//	Copyright © 2018 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct HistoryClas : Codable {

	let classNo : String?
	let grade : String?
	let id : String?
	let year : String?


	enum CodingKeys: String, CodingKey {
		case classNo = "class_no"
		case grade = "grade"
		case id = "id"
		case year = "year"
	}
    init(classNo : String? = nil,
         grade : String? = nil,
         id : String? = nil,
         year : String? = nil
        ){
        self.classNo = classNo
        self.grade = grade
        self.id = id
        self.year = year
    }



}
