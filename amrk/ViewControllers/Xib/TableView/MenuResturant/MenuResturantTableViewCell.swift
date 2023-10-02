//
//  MenuResturantTableViewCell.swift
//  amrk
//
//  Created by yousef on 31/08/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit
import BEMCheckBox

class MenuResturantTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgItem: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var chActive: BEMCheckBox!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var object: RestaurantMenuItem?
    
    func configureCell() {
        if let obj = object {
            self.imgItem.imageURL(url: obj.image ?? "")
            self.lblName.text = obj.name
            self.lblPrice.text = "\(obj.price ?? 0) \("SAR".localize_)"
            
            if let parent = self.parentViewController as? ResturantDetailsViewController {
                if parent.isBookingTable {
                    lblPrice.isHidden = true
                }
            }
            
        }
        
        self.isSelected()
    }
    
    func isSelected() {
        if let parent = self.parentViewController as? ResturantDetailsViewController {
            
            var activeIds: [Int] = []
            
            for item in parent.orders {
                activeIds.append(item.order?.id ?? -1)
            }
            
            if activeIds.contains(self.object?.id ?? 0) {
                self.chActive.isHidden = false
                self.chActive.on = true
            } else {
                self.chActive.isHidden = true
                self.chActive.on = false
            }
            
        }
    }
    
}
