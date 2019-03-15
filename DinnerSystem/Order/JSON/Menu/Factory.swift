//
//	MenuFactory.swift
//
//	Create by Sean Pai on 26/1/2019
//	Copyright © 2019 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Factory : Codable {

	let allowCustom : String?
	let disabled : String?
	let id : String?
	let lowerBound : String?
	let name : String?
	let prepareTime : String?
	let upperBound : String?
    let soldOut: String?


	enum CodingKeys: String, CodingKey {
		case allowCustom = "allow_custom"
		case disabled = "disabled"
		case id = "id"
		case lowerBound = "lower_bound"
		case name = "name"
		case prepareTime = "prepare_time"
		case upperBound = "upper_bound"
        case soldOut = "sold_out"
	}
    init(allowCustom : String? = nil,
         disabled : String? = nil,
         id : String? = nil,
         lowerBound : String? = nil,
         name : String? = nil,
         prepareTime : String? = nil,
         upperBound : String? = nil,
         soldOut: String? = nil
        ){
        self.allowCustom = allowCustom
        self.disabled = disabled
        self.id = id
        self.lowerBound = lowerBound
        self.name = name
        self.prepareTime = prepareTime
        self.upperBound = upperBound
        self.soldOut = soldOut
    }


}
