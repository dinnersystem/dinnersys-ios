//
//  FactoryTableViewCell.swift
//  DinnerSystem
//
//  Created by Sean on 2019/12/28.
//  Copyright © 2019 DinnerSystem Team. All rights reserved.
//

import UIKit

class FactoryTableViewCell: UITableViewCell {
    
    @IBOutlet var factoryName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
