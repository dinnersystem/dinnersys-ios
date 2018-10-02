//
//  adminHistoryCell.swift
//  DinnerSystemBeta
//
//  Created by Sean on 2018/9/23.
//  Copyright © 2018年 Sean.Inc. All rights reserved.
//

import UIKit

class adminHistoryCell: UITableViewCell {
    
    @IBOutlet var mainText: UILabel!
    @IBOutlet var detailText: UILabel!
    @IBOutlet var paidText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
