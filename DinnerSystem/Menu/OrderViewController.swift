///
//  OrderVoewController.swift
//  DinnerSystem
//
//  Created by Sean on 2018/11/18.
//  Copyright © 2018 Sean.Inc. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import TrueTime

class orderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let feedbackGenerator = UINotificationFeedbackGenerator()
    
    @IBOutlet var nameView: UITableView!
    @IBOutlet var qtyView: UITableView!
    @IBOutlet var costView: UITableView!
    var foodArray: [SelectedFoodArray] = []
    override func viewDidLoad() {
        if #available(iOS 13.0, *) {
            if(traitCollection.userInterfaceStyle == .dark){
                self.view.backgroundColor = UIColor.black
            }else{
                self.view.backgroundColor = UIColor.white
            }
        } else {
            self.view.backgroundColor = UIColor.white
        }
        feedbackGenerator.prepare()
        foodArray.removeAll()
        foodArray.append(SelectedFoodArray(name: SelectedFood.name, qty: "x1", cost: SelectedFood.cost))
        foodArray.append(SelectedFoodArray(name: "小計", qty: "x1", cost: SelectedFood.cost))
    }
    
    //MARK: - tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if tableView == nameView{
            cell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath)
        }else if tableView == qtyView{
            cell = tableView.dequeueReusableCell(withIdentifier: "qtyCell", for: indexPath)
        }else if tableView == costView{
            cell = tableView.dequeueReusableCell(withIdentifier: "costCell", for: indexPath)
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath)
        }
        let info = foodArray[indexPath.row]
        if tableView == nameView{
            cell.textLabel?.text = info.name
            cell.textLabel?.adjustsFontSizeToFitWidth = true
            return cell
        }else if tableView == qtyView{
            cell.textLabel?.text = info.qty
            
            return cell
        }else if tableView == costView{
            cell.textLabel?.text = info.cost
            return cell
        }else{
            cell.textLabel?.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch tableView {
        case nameView: return "名稱"
        case qtyView: return "數量"
        case costView: return "單價"
        default: return nil
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(self.costView == scrollView){
            self.nameView.contentOffset = scrollView.contentOffset
            self.qtyView.contentOffset = scrollView.contentOffset
        }else if(self.nameView == scrollView){
            self.costView.contentOffset = scrollView.contentOffset
            self.qtyView.contentOffset = scrollView.contentOffset
        }else if(self.qtyView == scrollView){
            self.costView.contentOffset = scrollView.contentOffset
            self.nameView.contentOffset = scrollView.contentOffset
        }
    }
    
    //MARK: - orderButton
    @IBAction func order(_ sender: Any)  {
        dishIDs.removeAll()
        dishIDs.append(SelectedFood.id)
        orderParameter = ["cmd": "make_self_order","dish_id":dishIDs]
        ConfirmFood.name = SelectedFood.name
        ConfirmFood.cost = SelectedFood.cost
        self.performSegue(withIdentifier: "confirmSegue", sender: self)
    }
}
