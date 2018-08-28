
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
     
    var orderButton = UIButton.init(type: UIButton.ButtonType.roundedRect)
    
    private func addButton(){
        orderButton.backgroundColor = .white
        orderButton.setTitle("共\(totalCost)元。按下完成點餐", for: UIControl.State.normal)
        orderButton.setTitleColor(.blue, for: UIControl.State.normal)
        orderButton.isEnabled = false
        tableView.addSubview(orderButton)
        
        //position
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
        
        orderButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        orderButton.addTarget(self, action: #selector(self.order(_:)), for: UIControl.Event.touchUpInside)
        
    }
    
    @objc func order(_ sender: UIButton){
        ord.name = ""
        ord.url = ""
        let sr = tableView.indexPathsForSelectedRows
        ord.url = dinnersys.url + "?cmd=get_custom_dish_id"
        var i = selected - 1
        while i>=0 {
            let info = menu4Arr[sr![i][1]]
            ord.url += "&id[]=[\(sr![i][1])]"
            if i>0 {
                ord.name += "\(info.dishName!)+"
            }else{
                ord.name += "\(info.dishName!)"
            }
            i -= 1
        }
        print(ord.url)
        menuInfo.cost = String(totalCost)
        menuInfo.name = ord.name
        Alamofire.request(ord.url).responseString{response in
            menuInfo.id = response.value!
            print(menuInfo.id)
        }
        self.performSegue(withIdentifier: "store4Segue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton()
        Alamofire.request("\(dinnersys.url)?cmd=show_menu&factory_id=4").responseData{response in
            let data = response.data!
            let decoder = JSONDecoder()
            menu4Arr = try! decoder.decode([menu].self, from: data)
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
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
        return menu4Arr.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "store4Cell", for: indexPath)
        let info = menu4Arr[indexPath.row]
        cell.textLabel?.text = info.dishName!
        cell.detailTextLabel?.text = info.dishCost! + "$"
        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let sr = tableView.indexPathsForSelectedRows {
            if sr.count > limit {
                let alertController = UIAlertController(title: "Oops", message:
                    "已達單次訂餐上限", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                
                return nil
            }
        }
        
        
        return indexPath
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected  \(indexPath.row)")
        let info = menu4Arr[indexPath.row]
        
        totalCost += Int(info.dishCost!)!
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.isSelected {
                cell.accessoryType = .checkmark
            }
        }
        
        if let sr = tableView.indexPathsForSelectedRows {
            print("didDeselectRowAtIndexPath selected rows:\(sr)")
            selected = sr.count
        }
        if selected > 0 && selected < 6{
            orderButton.isEnabled = true
            orderButton.setTitle("共\(totalCost)元。按下完成點餐", for: UIControl.State.normal)
        }else{
            orderButton.isEnabled = false
            orderButton.setTitle("共\(totalCost)元。按下完成點餐", for: UIControl.State.normal)
        }

    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("deselected  \(indexPath.row)")
        let info = menu4Arr[indexPath.row]
        
        totalCost -= Int(info.dishCost!)!
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
        
        if let sr = tableView.indexPathsForSelectedRows {
            print("didDeselectRow selected rows:\(sr)")
            selected = sr.count
        }else{
            print("no selection")
            selected = 0
        }
        if selected > 0 && selected < 6{
            orderButton.isEnabled = true
            orderButton.setTitle("共\(totalCost)元。按下完成點餐", for: UIControl.State.normal)
        }else{
            orderButton.isEnabled = false
            orderButton.setTitle("共\(totalCost)元。按下完成點餐", for: UIControl.State.normal)
        }
    }
    
    
    

}



class GuanDonViewController: UIViewController{
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        label.text = "您選的餐點是\(menuInfo.name)，價格總共\(menuInfo.cost)元，確定請選擇日期和時間後按下訂餐（取餐日期限制：該週週一到週五，取餐時間：）"
    }
    
    @IBAction func order(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd-HH:mm:ss"
        let date = formatter.string(from: datePicker.date)
        print(date)
        Alamofire.request("\(dinnersys.url)?cmd=make_order&dish_id=\(menuInfo.id)&time=\(date)").responseString{response in
            
        }
    }
    
    
    
    
    
}



