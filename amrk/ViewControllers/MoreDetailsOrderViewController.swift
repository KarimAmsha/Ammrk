/*********************		Yousef El-Madhoun		*********************/
//
//  MoreDetailsOrderViewController.swift
//  amrk
//
//  Created by yousef on 15/10/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit

class MoreDetailsOrderViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var stBranch: UIStackView!
    
    @IBOutlet weak var lblBranch: UILabel!
    
    @IBOutlet weak var stUserName: UIStackView!
    
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var stCompany: UIStackView!
    
    @IBOutlet weak var lblCompany: UILabel!
    
    @IBOutlet weak var stPhoneNumber: UIStackView!
    
    @IBOutlet weak var lblPhoneNumber: UILabel!
    
    @IBOutlet weak var stEmail: UIStackView!
    
    @IBOutlet weak var lblEmail: UILabel!
    
    @IBOutlet weak var stPersonCount: UIStackView!
    
    @IBOutlet weak var lblPersonCount: UILabel!
    
    @IBOutlet weak var discountLbl: UILabel!
    
    @IBOutlet weak var stCoffeeBreak: UIStackView!
    
    @IBOutlet weak var lblCoffeeBreak: UILabel!
    
    @IBOutlet weak var stTimePeriod: UIStackView!
    
    @IBOutlet weak var lblTimePeriod: UILabel!
    
    @IBOutlet weak var stPreparingkosha: UIStackView!
    
    @IBOutlet weak var lblPreparingkosha: UILabel!
    
    @IBOutlet weak var stPhotographs: UIStackView!
    
    @IBOutlet weak var lblPhotographs: UILabel!
    
    @IBOutlet weak var stDisplayScreen: UIStackView!
    
    @IBOutlet weak var lblDisplayScreen: UILabel!
    
    @IBOutlet weak var stSessionType: UIStackView!
    
    @IBOutlet weak var lblSessionType: UILabel!
    
    @IBOutlet weak var stBookingDate: UIStackView!
    
    @IBOutlet weak var lblBookingDate: UILabel!
    
    @IBOutlet weak var stPaymentMethod: UIStackView!
    
    @IBOutlet weak var lblPaymentMethod: UILabel!
    
    @IBOutlet weak var stDiscountCode: UIStackView!
    
    @IBOutlet weak var lblDiscountCode: UILabel!
    
    @IBOutlet weak var stSpecialDetails: UIStackView!
    
    @IBOutlet weak var lblSpecialDetails: UILabel!
    
    @IBOutlet weak var vwProducts: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var consTableView: NSLayoutConstraint!
    
    @IBOutlet weak var vwPayment: UIView!
    
    @IBOutlet weak var lblCartPrice: UILabel!
    
    @IBOutlet weak var lblDeliveryPrice: UILabel!
    
    @IBOutlet weak var lblServicePrice: UILabel!
    
    @IBOutlet weak var lblTotalOrder: UILabel!
    
    @IBOutlet weak var stDeliveryMethod: UIStackView!
    
    @IBOutlet weak var lblDeliveryMethod: UILabel!
    
    var object: OrderItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        localized()
        setupData()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.layoutSubviews()
        self.scrollView.layoutIfNeeded()
        self.consTableView.constant = self.object?.products == nil ? 100 : self.tableView.contentSize.height
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MoreDetailsOrderViewController {
    
    func setupView() {
        if let branch = self.object?.branch {
            self.lblBranch.text = branch.address
        } else {
            self.stBranch.isHidden = true
        }
        self.stBranch.isHidden = true
        
        if let userName = self.object?.ownerName {
            self.lblUserName.text = userName
        } else {
            self.stUserName.isHidden = true
        }
        
        if let companyName = self.object?.ownerCompanyName {
            self.lblCompany.text = companyName
        } else {
            self.stCompany.isHidden = true
        }
        
        if let phoneNumber = self.object?.mobile {
            switch phoneNumber {
            case .integer(let int):
                self.lblPhoneNumber.text = "\(int)"
            case .string(let string):
                self.lblPhoneNumber.text = "\(string)"
            }
        } else {
            self.stPhoneNumber.isHidden = true
        }
        
        
        
//        if let discount = self.object?.coupon {
//            if discount.type == "percent" {
//                self.discountLbl.text = "\(discount.amount ?? 0)%"
//            } else {
//                self.discountLbl.text = "\(discount.amount ?? 0)" + " SAR".localize_
//            }
//        } else {
//            self.discountLbl.text = "0" + " SAR".localize_
//
//        }
        
        
        self.discountLbl.text = "\(self.object?.paymentInfo?.discountPrice ?? 0)" + " SAR".localize_

        
//        if let email = self.object?.ownerEmail {
//            self.lblEmail.text = email
//        } else {
//            self.stEmail.isHidden = true
//        }
        
        self.stEmail.isHidden = true
        
        if let deliveryMethod = self.object?.delivery {
            switch deliveryMethod {
            case .double(let x):
                self.lblDeliveryMethod.text = x == 1 ? "Delivery".localize_ : "Recepipt from the branch".localize_
                break
            case .string(let x):
                self.lblDeliveryMethod.text = x == "1" ? "yes".localize_ : "no".localize_
                break
            }
        } else {
            self.stDeliveryMethod.isHidden = true
        }
        
        if let personCount = self.object?.persons {
            switch personCount {
            case .double(let x):
                self.lblPersonCount.text = "\(Int(x))"
                break
            case .string(let x):
                self.lblPersonCount.text = "\(x)"
                break
            }
        } else {
            self.stPersonCount.isHidden = true
        }
        
        if let coffeeBreak = self.object?.coffeeBreak {
            switch coffeeBreak {
            case .double(let x):
                self.lblCoffeeBreak.text = x == 1 ? "yes".localize_ : "no".localize_
                break
            case .string(let x):
                self.lblCoffeeBreak.text = x == "1" ? "yes".localize_ : "no".localize_
                break
            }
        } else {
            self.stCoffeeBreak.isHidden = true
        }
        
        if let timeSection = self.object?.timeSection {
            self.lblTimePeriod.text = timeSection.localize_
        } else {
            self.stTimePeriod.isHidden = true
        }
        
        if let kosha = self.object?.kosha {
            switch kosha {
            case .double(let x):
                self.lblPreparingkosha.text = x == 1 ? "yes".localize_ : "no".localize_
                break
            case .string(let x):
                self.lblPreparingkosha.text = x == "1" ? "yes".localize_ : "no".localize_
                break
            }
        } else {
            self.stPreparingkosha.isHidden = true
        }
        
        if let videoAndPhoto = self.object?.videoAndPhoto {
            switch videoAndPhoto {
            case .double(let x):
                self.lblPhotographs.text = x == 1 ? "yes".localize_ : "no".localize_
                break
            case .string(let x):
                self.lblPhotographs.text = x == "1" ? "yes".localize_ : "no".localize_
                break
            }
        } else {
            self.stPhotographs.isHidden = true
        }
        
        if let screens = self.object?.screens {
            switch screens {
            case .double(let x):
                self.lblDisplayScreen.text = x == 1 ? "yes".localize_ : "no".localize_
                break
            case .string(let x):
                self.lblDisplayScreen.text = x == "1" ? "yes".localize_ : "no".localize_
                break
            }
        } else {
            self.stDisplayScreen.isHidden = true
        }
        
        self.stSessionType.isHidden = true
        if let sessionType = self.object?.screens {
            switch sessionType {
            case .double(let x):
                self.lblSessionType.text = x == 1 ? "yes".localize_ : "no".localize_
                break
            case .string(let x):
                self.lblSessionType.text = x == "1" ? "yes".localize_ : "no".localize_
                break
            }
        } else {
            self.stSessionType.isHidden = true
        }
        
        if let time = self.object?.time {
            self.lblBookingDate.text = time
        } else {
            self.stBookingDate.isHidden = true
        }
        
        if let payType = self.object?.payType {
            self.lblPaymentMethod.text = payType.localize_
        } else {
            self.stPaymentMethod.isHidden = true
        }
        
        if let discountCode = self.object?.coupon?.amount {
            self.lblDiscountCode.text = "\(discountCode)%"
        } else {
            self.stDiscountCode.isHidden = true
        }
        
        if let details = self.object?.details {
            self.lblSpecialDetails.text = details
        } else {
            self.stSpecialDetails.isHidden = true
        }
        
        self.tableView.register(UINib(nibName: "OrderDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderDetailsTableViewCell")
        
        if self.object?.products == nil {
            self.vwProducts.isHidden = true
        }
        
        if self.object?.products == nil {
            self.vwPayment.isHidden = true
        }
        
        self.lblCartPrice.text = "\(self.object?.paymentInfo?.productsPrice ?? 0) \("SAR".localize_)"
        self.lblDeliveryPrice.text = "\(self.object?.paymentInfo?.deliveryPrice ?? 0) \("SAR".localize_)"
        self.lblServicePrice.text = "\(self.object?.paymentInfo?.servicePrice ?? 0) \("SAR".localize_)"
        self.lblTotalOrder.text = "\(self.object?.paymentInfo?.total ?? 0) \("SAR".localize_)"
    }
    
    func localized() {
        
    }
    
    func setupData() {

    }
    
    func fetchData() {
        
    }

}

extension MoreDetailsOrderViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.object?.products?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailsTableViewCell", for: indexPath) as! OrderDetailsTableViewCell
        cell.object = self.object?.products?[indexPath.row]
        cell.configureCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
