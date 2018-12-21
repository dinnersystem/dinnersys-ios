//
//  GuanDonTableViewCell.swift
//  DinnerSystem
//
//  Created by Sean on 2018/12/21.
//  Copyright © 2018 Sean.Inc. All rights reserved.
//

import UIKit

class GuanDonTableViewCell: UITableViewCell {

    @IBOutlet var titleText: UILabel!
    @IBOutlet var subtitleText: UILabel!
    @IBOutlet var stepper: UIStepper!
    @IBOutlet var qtyText: UILabel!
    
    @IBAction func addval(_ sender: Any) {
        qtyText.text = "\(stepper.value)份"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
