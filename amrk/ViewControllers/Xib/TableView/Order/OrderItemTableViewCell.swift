//
//  OrderItemTableViewCell.swift
//  amrk
//
//  Created by yousef on 06/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit

class OrderItemTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblQuantity: UILabel!
    
    @IBOutlet weak var lblPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var indexPath: IndexPath?
    
    var object: NewOrderItem?
    
    func configureCell() {
        if let obj = object {
            self.lblQuantity.text = "\(obj.quantity ?? 0)"
            if let orderRes = obj.order {
                self.lblTitle.text = orderRes.name
        
                let totalPrice = (Double(orderRes.price ?? 0)) + (obj.additionsPrice ?? 0)
                
                self.lblPrice.text = "\((totalPrice * Double(obj.quantity ?? 0)).rounded(toPlaces: 2)) \("SAR".localize_)"
                
            } else if let orderHala = obj.orderHala {
                
                let totalPrice = (Double(orderHala.price ?? 0)) + (obj.additionsPrice ?? 0)
                
                self.lblPrice.text = "\((totalPrice * Double(obj.quantity ?? 0)).rounded(toPlaces: 2)) \("SAR".localize_)"
                
                self.lblTitle.text = orderHala.name
//                self.lblPrice.text = "\(orderHala.price ?? 0) \("SAR".localize_)"
            }
        }
    }
    
    @IBAction func btnAdd(_ sender: Any) {
        if let parent = self.parentViewController as? ConfiremNewOrderViewController {
            
            let object = parent.orders[indexPath?.row ?? 0]
            
            if let _ = parent.objectResturant {
                let curentQuantity = object.order?.quantity
                
                if self.object?.quantity ?? 0 < curentQuantity ?? 0 {
                    parent.orders[indexPath?.row ?? 0].quantity = (self.object?.quantity ?? 0) + 1
                    
//                    if let _ = parent.orders[indexPath?.row ?? 0].additionsPrice {
//                        parent.orders[indexPath?.row ?? 0].additionsPrice! += (object.additionsPrice ?? 0)
//                    }
                    
                    parent.calcPrices()
                }
            } else if let _ = parent.objectHala {
                let curentQuantity = parent.orders[indexPath?.row ?? 0].orderHala?.quantity
                
                if self.object?.quantity ?? 0 < curentQuantity ?? 0 {
                    parent.orders[indexPath?.row ?? 0].quantity = (self.object?.quantity ?? 0) + 1
                }
                
//                if let _ = parent.orders[indexPath?.row ?? 0].additionsPrice {
//                    parent.orders[indexPath?.row ?? 0].additionsPrice! += (object.additionsPrice ?? 0)
//                }
                
                parent.calcPrices()
            }
            
            parent.tableView.reloadData()
            parent.viewDidLayoutSubviews()
            
        }
    }
    
    @IBAction func btnMinus(_ sender: Any) {
        if let parent = self.parentViewController as? ConfiremNewOrderViewController {
            
            let object = parent.orders[indexPath?.row ?? 0]
            
            let curentQuantity = object.quantity
            
            if let _ = parent.objectResturant {
                
                guard curentQuantity ?? 0 > 1 else {
                    return
                }
                
                parent.orders[indexPath?.row ?? 0].quantity = (self.object?.quantity ?? 0) - 1
                
//                if let _ = parent.orders[indexPath?.row ?? 0].additionsPrice {
//                    parent.orders[indexPath?.row ?? 0].additionsPrice! -= (object.additionsPrice ?? 0)
//                }
                
                parent.calcPrices()
                
            } else if let _ = parent.objectHala {
                
                guard curentQuantity ?? 0 > 1 else {
                    return
                }
                
                parent.orders[indexPath?.row ?? 0].quantity = (self.object?.quantity ?? 0) - 1
                
//                if let _ = parent.orders[indexPath?.row ?? 0].additionsPrice {
//                    parent.orders[indexPath?.row ?? 0].additionsPrice! -= (object.additionsPrice ?? 0)
//                }
                
                parent.calcPrices()
            }
            
            parent.tableView.reloadData()
            parent.viewDidLayoutSubviews()
        }
    }
    
    @IBAction func btnDelete(_ sender: Any) {
        
        if let parent = self.parentViewController as? ConfiremNewOrderViewController {
            
            parent.showAlertPopUp(title: "Delete Order".localize_, message: "Are you sure delete order?".localize_, buttonTitle1: "Delete".localize_, buttonTitle2: "Close".localize_, action1: {

                guard parent.orders.count > 1 else {
                    parent.showSnackbarMessage(message: "The must be at least one order".localize_, isError: true)
                    return
                }
                
                parent.orders.remove(at: self.indexPath?.row ?? 0)
                
                parent.tableView.reloadData()
                parent.viewDidLayoutSubviews()
                
                parent.calcPrices()
                
            }) {
                
            }
            
        }
        
    }
    
}
