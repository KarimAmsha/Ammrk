//
//  FavoriteCollectionViewCell.swift
//  amrk
//
//  Created by yousef on 26/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit

class FavoriteCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgItem: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    var object: FavoriteItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell() {
        if let obj = self.object {
            self.imgItem.imageURL(url: obj.account?.image ?? "")
            self.lblTitle.text = obj.account?.name
        }
    }

    @IBAction func btnUnFavorite(_ sender: Any) {
        self.parentViewController?.showAlertPopUp(title: "Remove Form Favourites".localize_, message: "Are you sure remove from favourites?".localize_, buttonTitle1: "Remove".localize_, buttonTitle2: "Close".localize_, action1: {
            let request = BaseRequest()
            request.url = "\(GlobalConstants.FAVORITE)/\(self.object?.id ?? 0)/delete"
            request.method = .get
            
            RequestBuilder.requestWithSuccessfullRespnose(for: ReviewOrderModel.self, request: request) { (result) in
                
                if result.status ?? false {
                    if let parent = self.parentViewController as? FavoriteViewController {
                        parent.getData()
                    }
                }
                
            }
        }, action2: {
            
        })
    }
    
}
