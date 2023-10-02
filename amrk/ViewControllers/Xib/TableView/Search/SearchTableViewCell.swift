//
//  SearchTableViewCell.swift
//  amrk
//
//  Created by yousef on 02/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var imgItem: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblDiscount: UILabel!
    
    @IBOutlet weak var vwAds: UIView!
    
    @IBOutlet weak var lblDetails: UILabel!
    
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet weak var lblDistance: UILabel!
    
    @IBOutlet weak var lblRate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var object: SearchItem?
    
    func configureCell() {
        if let obj = object {
            self.imgItem.imageURL(url: obj.image ?? "")
            self.lblTitle.text = obj.name ?? ""
        }
    }
    
}
