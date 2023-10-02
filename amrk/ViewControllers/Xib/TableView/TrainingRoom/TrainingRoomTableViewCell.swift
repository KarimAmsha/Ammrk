//
//  TrainingRoomTableViewCell.swift
//  amrk
//
//  Created by yousef on 27/08/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit

class TrainingRoomTableViewCell: UITableViewCell {

    @IBOutlet weak var imgItem: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblDiscount: UILabel!
    
    @IBOutlet weak var vwAds: UIView!
    
    @IBOutlet weak var vwDiscount: UIView!
    
    @IBOutlet weak var lblDetails: UILabel!
    
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet weak var lblDistance: UILabel!
    
    @IBOutlet weak var lblRate: UILabel!
    
    @IBOutlet var icClock: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var object: RoomItemData?
    
    func configureCell() {
        if let obj = object {
            self.imgItem.imageURL(url: obj.image ?? "")
            self.lblName.text = obj.name
            self.lblRate.text = "\(obj.userInfo?.review?.rounded(toPlaces: 2) ?? 0)"
            self.lblDetails.text = obj.userInfo?.address
            self.lblStatus.text = obj.userInfo?.isOpen == 0 ? "Closed".localize_ : "Opened".localize_
            
            self.icClock.imageColor = obj.userInfo?.isOpen == 0 ? UIColor.red : UIColor.hexColor(hex: "#008000")
            self.lblStatus.textColor = obj.userInfo?.isOpen == 0 ? UIColor.red : UIColor.hexColor(hex: "#008000")
            
            self.lblDistance.text = "\(obj.userInfo?.distance ?? 0)" + " \("KM".localize_)"
            
            if obj.userInfo?.discount ?? 0 > 0 {
                self.vwDiscount.isHidden = false
            } else {
                self.vwDiscount.isHidden = true
            }
            
            self.lblDiscount.text = "\(obj.userInfo?.discount ?? 0) %"
            
            if let isAd = obj.userInfo?.isAd, isAd == 1 {
                self.vwAds.isHidden = false
            } else {
                self.vwAds.isHidden = true
            }
        }
    }
    
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
