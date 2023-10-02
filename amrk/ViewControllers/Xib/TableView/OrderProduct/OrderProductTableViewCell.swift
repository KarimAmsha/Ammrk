//
//  OrderProductTableViewCell.swift
//  amrk
//
//  Created by yousef on 14/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit

class OrderProductTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var lblCount: UILabel!
    
    @IBOutlet weak var lblAdditions: UILabel!
    
    @IBOutlet weak var lblRemoves: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
