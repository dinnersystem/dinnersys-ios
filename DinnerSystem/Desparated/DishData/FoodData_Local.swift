//
//  FoodData.swift
//  DinnerSystem
//
//  Created by Sean on 2018/1/7.
//  Copyright © 2018年 Sean.Inc. All rights reserved.
//

import Foundation

final class FoodData {
    
    static func genFoodData() -> [Food] {
        return [
            Food(name: "烤肉乾麵", cost: "55$", num: "1"),
            Food(name: "素炒飯", cost: "60$", num: "2"),
            Food(name: "張君雅泡乾麵+滷蛋", cost: "40$", num: "3"),
            Food(name: "邦寧", cost: "60$", num: "60")
        ]
    }
}
