//
//  ProviderOrderTableViewCell.swift
//  amrk
//
//  Created by yousef on 14/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit

class ProviderOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var btnsStack: UIStackView!
    @IBOutlet weak var orderStatusLbl: UILabel!
    @IBOutlet weak var lblOrderID: UILabel!
    
    @IBOutlet weak var lblOrderOwnerName: UILabel!
    
    @IBOutlet weak var lblOrderDate: UILabel!
    
    @IBOutlet weak var lblOrderType: UILabel!
    
    var object: OrderItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configuareCell() {
        if let obj = self.object {
            if let sts = obj.status {
                switch sts {
                case .double(let x):
                    if x == 0 {
                        
                        btnsStack.isHidden = false
                    } else {
                        btnsStack.isHidden = true
                    }
                case .string(let x):
                    if x == "0" {
                        btnsStack.isHidden = false
                    } else {
                        btnsStack.isHidden = true
                    }
                    
                }
            self.lblOrderID.text = "#\(obj.id ?? 0)"
            self.lblOrderOwnerName.text = obj.ownerName
            self.lblOrderDate.text = obj.time
            self.lblOrderType.text = obj.typeName
            self.orderStatusLbl.text = obj.statusName
        }
    }
    
}
}
