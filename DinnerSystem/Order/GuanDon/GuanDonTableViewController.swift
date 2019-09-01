
//
//  GuanDonTableViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2018/4/24.
//  Copyright © 2018年 Sean.Inc. All rights reserved.
//

import UIKit
import Alamofire

class GuanDonTableViewController: UITableViewController{
    
    var limit = 5
    var selected = 0
    var totalCost = 0
    var lowestCost = 45
    var orderDict:[String:Int] = [:]
    var stepperDict:[Int:Int] = [:]
    var noodleID:[String] = []
    var noodleIndex: [Int] = []
    var noodleSelected = false
    @IBOutlet var orderButton: UIButton!
    
    
    private func addButton(){
        orderButton.setTitle("共\(totalCost)元。按下完成點餐(低消\(lowestCost)元)", for: UIControl.State.normal)
        //orderButton.setTitleColor(.blue, for: UIControl.State.normal)
        orderButton.isEnabled = false
        //tableView.addSubview(orderButton)
        
        //position
        /*
         orderButton.translatesAutoresizingMaskIntoConstraints = false
         if #available(iOS 11.0, *) {
         orderButton.leftAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.leftAnchor).isActive = true
         orderButton.rightAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.rightAnchor).isActive = true
         orderButton.bottomAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.bottomAnchor).isActive = true
         orderButton.widthAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.widthAnchor).isActive = true
         } else {
         orderButton.leftAnchor.constraint(equalTo: tableView.leftAnchor).isActive = true
         orderButton.rightAnchor.constraint(equalTo: tableView.rightAnchor).isActive = true
         orderButton.bottomAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
         orderButton.widthAnchor.constraint(equalTo: tableView.widthAnchor).isActive = true
         }
         */
        
        //orderButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        orderButton.addTarget(self, action: #selector(self.order(_:)), for: UIControl.Event.touchUpInside)
        
    }
    
    @objc func order(_ sender: UIButton){
        Ord.name = ""
        Ord.url = ""
        //let sr = tableView.indexPathsForSelectedRows
        Ord.url = dsURL("make_self_order")
        foodArr.removeAll()
        
        for item in orderDict{
            var i=0
            while i<item.value{
                Ord.url += "&dish_id[]=\(item.key)"
                i+=1
            }
        }
        for item in orderDict{
            if(item.value > 0){
                let food = guanDonMenuArr.filter{ $0.dishId == item.key }[0]
                //                ord.name += "\(originMenuArr[Int(item.key)!-1].dishName!)*\(item.value)+"
                //foodArr.append(selectedFoodArray(name: originMenuArr[Int(item.key)!].dishName!, qty: "x\(item.value)", cost: originMenuArr[Int(item.key)!].dishCost!))
                foodArr.append(SelectedFoodArray(name: food.dishName!, qty: "x\(item.value)", cost: food.dishCost!))
            }
            
        }
        Ord.name = String(Ord.name.dropLast())
        print(Ord.url)
        SelectedFood.cost = String(totalCost)
        SelectedFood.name = Ord.name
        foodArr.append(SelectedFoodArray(name: "小計", qty: "x\(selected)", cost: String(totalCost)))
        /*
         Alamofire.request(ord.url).responseString{response in
         selectedFood.id = response.value!
         print(selectedFood.id)
         }
         */
        self.performSegue(withIdentifier: "store4Segue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lowestCost = Int(guanDonMenuArr[0].department!.factory!.minimum!)!
        addButton()
        for i in 0..<guanDonMenuArr.count{
            let info = guanDonMenuArr[i]
            orderDict.updateValue(0, forKey: info.dishId!)
            if(info.department!.name! == "麵類"){
                noodleID.append(info.dishId!)
            }
        }
        self.navigationItem.title = "關東煮（餘額: \(balance)）"
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return guanDonMenuArr.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "store4Cell", for: indexPath) as! GuanDonTableViewCell
        let info = guanDonMenuArr[indexPath.row]
        cell.titleText.text = info.dishName!
        cell.subtitleText.text = "\(info.dishCost!)$，剩\(info.remaining!)個"
        cell.stepper.value = Double(orderDict[info.dishId!]!)
        cell.qtyText.text = "\(Int(cell.stepper.value))份"
        cell.stepper.maximumValue = (Double(Int(info.remaining!)!)) > 5 ? 5.0 : (Double(Int(info.remaining!)!) > 0 ? Double(Int(info.remaining!)!) : 0 )
        cell.stepper.tag = Int(info.dishId!)!
        stepperDict[Int(info.dishId!)!] = indexPath.row
        cell.stepper.addTarget(self, action: #selector(stepperChanged(sender: )), for: .valueChanged)
        //let backgroundColor = UIColor(red:0.38, green:0.38, blue:0.38, alpha:1.0)
        //let foregroundColor = UIColor(red:0.92, green:0.49, blue:0.63, alpha:1.0)
        //let backgroundColor = UIColor.white
        let foregroundColor = UIColor(red:1.00, green:0.27, blue:0.27, alpha:1.0)
        if info.bestSeller == "true" {
            cell.subtitleText.text = cell.subtitleText.text! + "，人氣商品！"
            //cell.backgroundColor = backgroundColor
            cell.titleText.textColor = foregroundColor
            cell.subtitleText.textColor = foregroundColor
            cell.qtyText.textColor = foregroundColor
            cell.stepper.tintColor = foregroundColor
            cell.detailTextLabel?.alpha = 0.8
        }else{
            //cell.backgroundColor = UIColor.white
            if #available(iOS 13.0, *) {
                if(traitCollection.userInterfaceStyle == .light){
                    cell.titleText.textColor = UIColor.darkText
                    cell.subtitleText.textColor = UIColor.darkText
                    cell.qtyText.textColor = UIColor.darkText
                }else{
                    cell.titleText.textColor = UIColor.white
                    cell.subtitleText.textColor = UIColor.white
                    cell.qtyText.textColor = UIColor.white
                }
            } else {
                cell.titleText.textColor = UIColor.darkText
                cell.subtitleText.textColor = UIColor.darkText
                cell.qtyText.textColor = UIColor.darkText
                cell.stepper.tintColor = UIColor.blue
            }
        }
        if info.department!.name! == "麵類"{
            noodleIndex.append(indexPath.row)
            cell.stepper.maximumValue = 1
        }
        return cell
    }
    
    @objc func stepperChanged(sender: UIStepper){
        print(sender.tag)
        let ingInfo = guanDonMenuArr.filter{ $0.dishId == String(sender.tag) }[0]
        let cell = self.tableView.cellForRow(at: IndexPath(row: stepperDict[sender.tag]!, section: 0)) as! GuanDonTableViewCell
        orderDict.updateValue(Int(sender.value), forKey: ingInfo.dishId!)
        selected = 0
        totalCost = 0
        for item in orderDict{
            let dish = guanDonMenuArr.filter{ $0.dishId == item.key }
            selected += item.value
            totalCost += (item.value * Int(dish[0].dishCost!)!)
        }
        noodleSelected = false
        var noodleCount = 0
        for index in noodleID{
            let noodleCell = self.tableView.cellForRow(at: IndexPath(row: stepperDict[Int(index)!]!, section: 0)) as! GuanDonTableViewCell
            if noodleCell.stepper.value != 0{
                noodleCount += 1
                noodleSelected = noodleCount > 1
            }
        }
        
        print(selected)
        if selected>20 || noodleSelected{
            let alertController = UIAlertController(title: "Oops", message:
                "已達單次訂餐上限", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                (action: UIAlertAction!) -> () in
                sender.value -= 1
                self.orderDict.updateValue(Int(sender.value), forKey: ingInfo.dishId!)
                cell.qtyText.text = String(Int(sender.value)) + "份"
                self.selected = 0
                self.totalCost = 0
                for item in self.orderDict{
                    let dish = guanDonMenuArr.filter{ $0.dishId == item.key }
                    self.selected += item.value
                    self.totalCost += (item.value * Int(dish[0].dishCost!)!)
                }
                if self.selected > 0 && self.totalCost >= self.lowestCost{
                    self.orderButton.isEnabled = true
                    self.orderButton.setTitle("共\(self.totalCost)元。按下完成點餐(低消\(self.lowestCost)元)", for: UIControl.State.normal)
                }else{
                    self.orderButton.isEnabled = false
                    self.orderButton.setTitle("共\(self.totalCost)元。按下完成點餐(低消\(self.lowestCost)元)", for: UIControl.State.normal)
                }
            }))
            self.present(alertController, animated: true, completion: nil)
        }
        print(orderDict)
        if selected > 0 && totalCost >= self.lowestCost{
            orderButton.isEnabled = true
            orderButton.setTitle("共\(totalCost)元。按下完成點餐(低消\(self.lowestCost)元)", for: UIControl.State.normal)
        }else{
            orderButton.isEnabled = false
            orderButton.setTitle("共\(totalCost)元。按下完成點餐(低消\(self.lowestCost)元)", for: UIControl.State.normal)
        }
    }
    
    
    
    
    
}



