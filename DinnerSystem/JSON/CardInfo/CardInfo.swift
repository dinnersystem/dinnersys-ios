//
//	CardInfo.swift
//
//	Create by Sean Pai on 11/4/2019
//	Copyright © 2019 New Taipei Municipal Banqiao Senior High School. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

var POSInfo = CardInfo()

struct CardInfo : Codable {

	let card : String?
	let money : String?
	let name : String?


	enum CodingKeys: String, CodingKey {
		case card = "card"
		case money = "money"
		case name = "name"
	}
    init(card : String? = nil,
         money : String? = nil,
         name : String? = nil
        ){
        self.card = card
        self.money = money
        self.name = name
    }


}
