//
//  RoomOffersTableViewCell.swift
//  amrk
//
//  Created by mohawad on 9/9/21.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit
import BEMCheckBox
class RoomOffersTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var checkBx: BEMCheckBox!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
