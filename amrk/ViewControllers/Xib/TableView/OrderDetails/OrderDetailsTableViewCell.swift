//
//  OrderDetailsTableViewCell.swift
//  amrk
//
//  Created by yousef on 15/10/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit

class OrderDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var imgItem: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblSupTitle: UILabel!
    
    @IBOutlet weak var lblQuantity: UILabel!
    
    @IBOutlet weak var lblPrice: UILabel!
    
    var object: ProductOrder?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell() {
        if let obj = self.object {
            self.imgItem.imageURL(url: obj.image ?? "")
            self.lblTitle.text = obj.name
            self.lblSupTitle.text = obj.productDescription
            self.lblQuantity.text = "\(obj.orderData?.qnt ?? 0) x"
            self.lblPrice.text = "\(obj.price ?? 0) \("SAR".localize_)"
        }
    }
    
}
