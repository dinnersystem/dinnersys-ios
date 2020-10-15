//
//  GuanDonViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2018/12/21.
//  Copyright © 2018 Sean.Inc. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import FirebaseCrashlytics

class GuanDonViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let feedbackGenerator = UINotificationFeedbackGenerator()
    
    @IBOutlet var costView: UITableView!
    @IBOutlet var qtyView: UITableView!
    @IBOutlet var nameView: UITableView!
    
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
    }
    
    //MARK: - tableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodArr.count
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
        let info = foodArr[indexPath.row]
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
    @IBAction func sendOrder(_ sender: Any) {
        orderParameter = guanDonParam
        ConfirmFood.name = "自助餐點"
        ConfirmFood.cost = foodArr.last!.cost
        self.performSegue(withIdentifier: "confirmSegue", sender: self)
    }
}
