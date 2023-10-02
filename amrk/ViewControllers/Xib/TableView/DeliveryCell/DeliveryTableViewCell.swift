//
//  DeliveryTableViewCell.swift
//  amrk
//
//  Created by yousef on 15/08/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit

class DeliveryTableViewCell: UITableViewCell {

    @IBOutlet weak var imgItem: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var vwDiscount: UIView!
    
    @IBOutlet weak var lblDiscount: UILabel!
    
    @IBOutlet weak var vwAds: UIView!
    
    @IBOutlet weak var lblDetails: UILabel!
    
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet weak var lblDistance: UILabel!
    
    @IBOutlet weak var lblRate: UILabel!
    
    @IBOutlet var icClock: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var object: RestaurantItem?
    
    func configureCell() {
        if let obj = object {
            self.imgItem.imageURL(url: obj.image ?? "")
            self.lblTitle.text = obj.name ?? ""
            self.lblDetails.text = obj.userInfo?.about
            self.lblRate.text = "\(obj.userInfo?.review?.rounded(toPlaces: 2) ?? 0)"
            self.lblDistance.text = "\(obj.userInfo?.distance ?? 0) \("KM".localize_)"
            self.lblStatus.text = obj.userInfo?.isOpen == 0 ? "Closed".localize_ : "Opened".localize_
            
            self.icClock.imageColor = obj.userInfo?.isOpen == 0 ? UIColor.red : UIColor.hexColor(hex: "#008000")
            self.lblStatus.textColor = obj.userInfo?.isOpen == 0 ? UIColor.red : UIColor.hexColor(hex: "#008000")
            
            if let discount = obj.userInfo?.discount {
                self.vwDiscount.isHidden = false
                self.lblDiscount.text = "\(discount) %"
            } else {
                self.vwDiscount.isHidden = true
            }
            
            if let isAd = obj.userInfo?.isAd, isAd == 1 {
                self.vwAds.isHidden = false
            } else {
                self.vwAds.isHidden = true
            }
        }
    }

}
