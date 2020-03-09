//
//  AboutTableViewController.swift
//  DinnerSystem
//
//  Created by Sean on 2019/6/8.
//  Copyright © 2019 Sean.Inc. All rights reserved.
//

import UIKit

class AboutTableViewController: UITableViewController {
    
    var count = 0
    
    struct About{
        let title: String?
        let detail: String?
    }
    
    var dinnersystem: [About] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let appBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        dinnersystem.append(About(title: "程式名稱", detail: "板橋高中午餐系統"))
        dinnersystem.append(About(title: "程式版本", detail: "\(appVersion!) (\(appBuild!))"))
        dinnersystem.append(About(title: "主要開發者(iOS&Android App)", detail: "白翔云"))
        dinnersystem.append(About(title: "主要開發者(網頁, 後端, 資料庫)", detail: "吳邦寧"))
        dinnersystem.append(About(title: "後續維護", detail: "板橋高中資訊社"))
        dinnersystem.append(About(title: "如有任何問題，歡迎來信[dinnersys@gmail.com]!", detail: ""))
        dinnersystem.append(About(title: "第三方資料庫之版權聲明請至系統設定查看", detail: ""))
        dinnersystem.append(About(title: "開發者致謝", detail: ""))
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dinnersystem.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "aboutCell", for: indexPath)

        let info = dinnersystem[indexPath.row]
        cell.textLabel?.text = info.title
        cell.detailTextLabel?.text = info.detail
        cell.textLabel?.sizeToFit()
        if info.title!.contains("第三方資料庫"){
            cell.textLabel?.font = cell.textLabel?.font.withSize(16.0)
        }else if info.title!.contains("dinnersystem@gmail.com"){
            cell.textLabel?.font = cell.textLabel?.font.withSize(14.0)
        }else if info.title!.contains("開發者致謝"){
            cell.accessoryType = .disclosureIndicator
            cell.isUserInteractionEnabled = true
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = dinnersystem[indexPath.row]
            if info.title!.contains("開發者致謝"){
                self.performSegue(withIdentifier: "thanksSegue", sender: self) 
        }
    }
}
