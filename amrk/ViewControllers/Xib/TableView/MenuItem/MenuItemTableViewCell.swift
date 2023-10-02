//
//  MenuItemTableViewCell.swift
//  rukn2
//
//  Created by yousef on 14/06/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit

class MenuItemTableViewCell: UITableViewCell {

    @IBOutlet weak var icItem: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var imgLanguage: UIImageView!
    
    @IBOutlet weak var verifiedLbl: UILabel!
    @IBOutlet weak var icArrowRight: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let lang = UserProfile.shared.language ?? Language.english
        self.imgLanguage.image = lang == Language.arabic ? "icArabic".image_ : "icEnglish".image_
        self.verifiedLbl.text = "Not Verified".localize_
        self.verifiedLbl.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.verifiedLbl.isHidden = true
    }
    
    var object: Menu?
    
    func configureCell() {
        if let obj = object {
            
            self.icItem.image = obj.image.image_
            self.lblTitle.text = obj.title
            
            if obj == .logout {
                self.lblTitle.textColor = UIColor.hexColor(hex: "#FF4A52")
                self.icArrowRight.isHidden = true
            } else {
                self.lblTitle.textColor = UIColor.black
                self.icArrowRight.isHidden = false
            }
            
            if obj != .changeLanguage {
                self.imgLanguage.isHidden = true
            } else {
                self.icArrowRight.isHidden = true
            }
            
            if obj == .email {
                if UserProfile.shared.currentUser?.emailVerifiedAt == nil {
                    self.verifiedLbl.isHidden = false
                }
                
                self.lblTitle.text = UserProfile.shared.currentUser?.email
            } else {
                self.verifiedLbl.isHidden = true
            }
            
        }
    }
    
}
