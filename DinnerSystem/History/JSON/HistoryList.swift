//
//  HistoryList.swift
//  DinnerSystem
//
//  Created by Sean on 2019/1/18.
//  Copyright © 2019 Sean.Inc. All rights reserved.
//

import Foundation

var historyTableList: [HistoryList] = []
var oldHistoryTableList: [HistoryList] = []

struct HistoryList: Codable{
    let id :String?
    let dishName :String?
    let dishCost :String?
    var recvDate :String?
    let money :HistoryMoney?
    
    
    
    
    init(id : String? = nil,
         dishName :String? = nil,
         dishCost :String? = nil,
         recvDate :String? = nil,
         money :HistoryMoney? = nil
        ){
        self.id = id
        self.dishName = dishName
        self.dishCost = dishCost
        self.recvDate = recvDate
        self.money = money
    }

    
}
