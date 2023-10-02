//
//  NotificationTableViewCell.swift
//  rukn2
//
//  Created by yousef on 14/06/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var imgItem: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var lblSubTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var object: NotificationItem?
    
    func configureCell() {
        if let obj = object {
            self.lblTime.text = (obj.createdAt ?? Date().toString(customFormat: "MM-dd-yyyy hh:mm a")).toDate(customFormat: "MM-dd-yyyy hh:mm a").timeAgoDisplay
            self.lblTitle.text = obj.order?.type?.localize_
            self.lblSubTitle.text = obj.message
        }
    }
    
}
