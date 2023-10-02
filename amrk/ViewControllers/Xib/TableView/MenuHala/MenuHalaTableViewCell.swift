//
//  MenuHalaTableViewCell.swift
//  amrk
//
//  Created by yousef on 02/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit
import BEMCheckBox

class MenuHalaTableViewCell: UITableViewCell {

    @IBOutlet weak var imgItem: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var chActive: BEMCheckBox!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var object: HalaMenuItem?
    
    func configureCell() {
        if let obj = object {
            self.imgItem.imageURL(url: obj.image ?? "")
            self.lblName.text = obj.name
            self.lblPrice.text = "\(obj.price ?? 0) \("SAR".localize_)"
        }
        
        self.isSelected()
    }
    
    func isSelected() {
        if let parent = self.parentViewController as? HalaDetailsViewController {
            
            var activeIds: [Int] = []
            
            for item in parent.orders {
                activeIds.append(item.orderHala?.id ?? -1)
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
