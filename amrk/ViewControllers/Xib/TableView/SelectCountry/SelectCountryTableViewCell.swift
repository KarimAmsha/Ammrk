//
//  SelectCountryTableViewCell.swift
//  amrk
//
//  Created by yousef on 12/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit

class SelectCountryTableViewCell: UITableViewCell {

    @IBOutlet weak var flag: UIImageView!
    
    @IBOutlet weak var lblCountryName: UILabel!
    
    @IBOutlet weak var lblCountryCode: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var object: PhoneNumberCodeModel?
    
    func configureCell() {
        if let obj = object {
            self.lblCountryName.text = obj.name
            self.lblCountryCode.text = obj.code
        }
        
        self.isSelected()
    }
    
    func isSelected() {
        
        if let parent = self.parentViewController as? SelectCountryViewController {
            if parent.selectedCountry?.code == self.object?.code {
                self.lblCountryName.textColor = "#219CD8".color_
            } else {
                self.lblCountryName.textColor = "#444251".color_
            }
        }
        
    }
    
}
