//
//  HomeServiceCollectionViewCell.swift
//  rukn2
//
//  Created by yousef on 08/06/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit

class HomeServiceCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgService: UIImageView!
    
    @IBOutlet weak var lblService: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var object: HomeItem?
    
    func configureCell() {
        if let obj = object {
            imgService.image = obj.image.image_
            lblService.text = obj.title
        }
    }
    
}
