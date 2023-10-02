//
//  MyAdressesTableViewCell.swift
//  amrk
//
//  Created by yousef on 09/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit

class MyAdressesTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblSubTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var object: AddressItem?
    
    func configureCell() {
        if let obj = object {
            self.lblTitle.text = obj.name
            self.lblSubTitle.text = obj.address
        }
    }
    
    @IBAction func btnEdit(_ sender: Any) {
        if let parent = self.parentViewController as? MyAddressesViewController {
            let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "AddOrEditAddressViewController") as! AddOrEditAddressViewController
            vc.object = self.object
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .overFullScreen
            vc.callback = {
                parent.fetchData()
            }
            parent.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnDelete(_ sender: Any) {
        if let parent = self.parentViewController as? MyAddressesViewController {
            
            parent.showAlertPopUp(title: "Delete Address".localize_, message: "Are you sure delete address?".localize_, buttonTitle1: "Delete".localize_, buttonTitle2: "Close".localize_, action1: {
                self.deleteAddress()
            }) {
                
            }
            
        }
    }
    
    func deleteAddress() {
        let request = BaseRequest()
        request.url = "\(GlobalConstants.ADDRESSES)/\(self.object?.id ?? 0)/delete"
        request.method = .get
        
        RequestBuilder.requestWithSuccessfullRespnose(for: AddressModel.self, request: request) { (result) in
            
            if let parent = self.parentViewController as? MyAddressesViewController {
                if result.status ?? false {
                    let title = "The address has been deleted successfully".localize_
                    parent.showSnackbarMessage(message: title, isError: false)
                    parent.fetchData()
                } else {
                    parent.showSnackbarMessage(message: "Something happened! Please try again later".localize_, isError: true)
                }
            }
            
            
        }
    }
    
}
