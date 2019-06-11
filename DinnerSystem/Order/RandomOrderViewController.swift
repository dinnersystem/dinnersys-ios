//
//  RandomOrderViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2019/6/11.
//  Copyright © 2019 Sean.Inc. All rights reserved.
//

import UIKit

class RandomOrderViewController: UIViewController {
    
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var dishNameLabel: UILabel!
    
    var totalItemCount = 0
    var totalPossibilities: Double = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        totalItemCount = randomMenuArr.count
        totalPossibilities = Double(1.0/Double(totalItemCount))
        totalPossibilities = Double(round(totalPossibilities*10000)/100)
        statusLabel.text = "今日共\(totalItemCount)種餐點，每個餐點中獎機率平均，各為\(totalPossibilities)%。"
    }
    
    @IBAction func startRandom(_ sender: Any) {
        let randomUpper = Int.random(in: 18..<27)
        var currentRandom = 0
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { timer in
            if(currentRandom > randomUpper){
                timer.invalidate()
                let randomIndex = Int.random(in: 0..<self.totalItemCount)
                let item = randomMenuArr[randomIndex]
                self.dishNameLabel.text = item.dishName!
                self.dishNameLabel.adjustsFontSizeToFitWidth = true
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                    SelectedFood.cost = item.dishCost!
                    SelectedFood.id = item.dishId!
                    SelectedFood.name = item.dishName!
                    self.performSegue(withIdentifier: "randomSegue", sender: nil)
                })
            }
            else{
                let randomIndex = Int.random(in: 0..<self.totalItemCount)
                let item = randomMenuArr[randomIndex]
                self.dishNameLabel.text = item.dishName!
                self.dishNameLabel.adjustsFontSizeToFitWidth = true
                currentRandom += 1
            }
        })
        
        
    }
    
    

}
