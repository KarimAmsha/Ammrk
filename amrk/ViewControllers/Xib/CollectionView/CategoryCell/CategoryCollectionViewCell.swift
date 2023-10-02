//
//  CategoryCollectionViewCell.swift
//  rukn2
//
//  Created by yousef on 21/06/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

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
            lblTitle.text = obj
        }
        
        if let parent = self.parentViewController as? ResturantDetailsViewController {
            self.isSelected(selected: parent.selectedCategoryIndex == self.indexPath?.row)
        } else if let parent = self.parentViewController as? HalaDetailsViewController {
            self.isSelected(selected: parent.selectedCategoryIndex == self.indexPath?.row)
        } else {
            if indexPath?.row == 0 {
                self.isSelected(selected: true)
            }
        }
    }

    func isSelected(selected: Bool) {
        self.vwContainer.borderColor = selected ? "#219CD8".color_ : .opaqueSeparator
        self.lblTitle.textColor = selected ? "#219CD8".color_ : .opaqueSeparator
    }
    
}
