//
//  TaiwanTableViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2018/4/24.
//  Copyright © 2018年 Sean.Inc. All rights reserved.
//

import UIKit
import Alamofire

class TaiwanTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Alamofire.request("\(dinnersys.url)?cmd=show_menu&factory_id=1").responseData{response in
            print(response.data! as NSData)
            let data = response.data!
            let decoder = JSONDecoder()
            menu1Arr = try! decoder.decode([menu].self, from: data)
            self.tableView.reloadData()
        }
        
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
        return menu1Arr.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "store1Cell", for: indexPath)
        let info = menu1Arr[indexPath.row]
        cell.textLabel?.text = info.dishName!
        cell.detailTextLabel?.text = info.dishCost! + "$"

        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = menu1Arr[indexPath.row]
        menuInfo.id = info.dishId!
        menuInfo.cost = info.dishCost!
        menuInfo.name = info.dishName!
        self.performSegue(withIdentifier: "store1Segue", sender: nil)
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}








class TaiwanViewController: UIViewController{
    
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        label.text = "您選的餐點是\(menuInfo.name)，價格總共\(menuInfo.cost)元，確定請選擇日期和時間後按下訂餐（取餐日期限制：該週週一到週五，取餐時間：）"
    }
        
    @IBAction func order(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd-HH:mm:ss"
        let date = formatter.string(from: datePicker.date)
        Alamofire.request("\(dinnersys.url)?cmd=make_order&dish_id=\(menuInfo.id)&time=\(date)").responseString{response in
            
        }
    }
    
    
    
}

