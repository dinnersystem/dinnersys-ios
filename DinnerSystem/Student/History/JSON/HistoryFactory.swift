//
//	HistoryFactory.swift
//
//	Create by Sean Pai on 1/11/2018
//	Copyright © 2018 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct HistoryFactory : Codable {

	let disabled : String?
	let id : String?
	let lowerBound : String?
	let name : String?
	let prepareTime : String?
	let upperBound : String?


	enum CodingKeys: String, CodingKey {
		case disabled = "disabled"
		case id = "id"
		case lowerBound = "lower_bound"
		case name = "name"
		case prepareTime = "prepare_time"
		case upperBound = "upper_bound"
	}
    init(disabled : String? = nil,
         id : String? = nil,
         lowerBound : String? = nil,
         name : String? = nil,
         prepareTime : String? = nil,
         upperBound : String? = nil
        ){
        self.disabled = disabled
        self.id = id
        self.lowerBound = lowerBound
        self.name = name
        self.prepareTime = prepareTime
        self.upperBound = upperBound
    }



}
