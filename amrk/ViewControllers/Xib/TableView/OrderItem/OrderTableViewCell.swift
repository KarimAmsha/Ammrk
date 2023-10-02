//
//  OrderTableViewCell.swift
//  rukn2
//
//  Created by yousef on 21/06/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var imgItem: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblSubTitle: UILabel!
    
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var notPainLbl: UILabel!
    
    @IBOutlet weak var lblForSomeOne: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblForSomeOne.text = "for someone".localize_
        self.notPainLbl.text = "Not Paid".localize_
    }
    
    var object: OrderItem?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.notPainLbl.isHidden = true
    }
    
    func configareCell() {
        if let obj = self.object {
            self.imgItem.imageURL(url: obj.provider?.image ?? "")
            self.lblTitle.text = obj.typeName
            self.lblSubTitle.text = obj.details
            self.lblPrice.text = "\(obj.price ?? 0) \("SAR".localize_)"
            
            if (obj.type == "room" || obj.type == "wedding") {
                self.lblForSomeOne.isHidden = false
            } else {
                self.lblForSomeOne.isHidden = true
            }
            
            if obj.paid == nil {
                if (obj.type == "room" || obj.type == "wedding") {
                    self.notPainLbl.isHidden = true
                } else {
                    self.notPainLbl.isHidden = false
                }
            } else {
                self.notPainLbl.isHidden = true
            }
        }
    }
    
}
