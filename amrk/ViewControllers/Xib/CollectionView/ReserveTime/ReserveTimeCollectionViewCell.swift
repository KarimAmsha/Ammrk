//
//  ReserveTimeCollectionViewCell.swift
//  amrk
//
//  Created by yousef on 08/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit

class ReserveTimeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var vwContainer: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var object: String?
    
    func configureCell() {
        if let obj = object {
            self.lblTitle.text = obj
        }
        
        if let parent = self.parentViewController as? SelectDateReserveViewController {
            self.isSelected(selected: parent.reserveSelectedTime == self.indexPath?.row)
        }
        
    }
    
    func isSelected(selected: Bool) {
        self.vwContainer.borderColor = selected ? "#219CD8".color_ : .opaqueSeparator
        self.lblTitle.textColor = selected ? "#219CD8".color_ : .opaqueSeparator
    }
    
}
