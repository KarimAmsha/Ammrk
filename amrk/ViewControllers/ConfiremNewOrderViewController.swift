/*********************		Yousef El-Madhoun		*********************/
//
//  ConfiremNewOrderViewController.swift
//  amrk
//
//  Created by yousef on 06/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit
import iOSDropDown
import BEMCheckBox
import ActionSheetPicker_3_0
import PassKit

enum paymentMethodType {
    case cash
    case visa
    case applePay
}

class ConfiremNewOrderViewController: UIViewController {

    @IBOutlet weak var branchStack: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var deliveryLbl: UILabel!
    @IBOutlet weak var vwContact: UIView!
    @IBOutlet weak var consTableView: NSLayoutConstraint!

    @IBOutlet weak var txtPhoneNumber: UITextField!

    @IBOutlet weak var vwDateAndTime: UIView!

    @IBOutlet weak var txtDateAndTime: UITextField!

    @IBOutlet weak var chDelivery: BEMCheckBox!

    @IBOutlet weak var lblDelivery: UILabel!

    @IBOutlet weak var chWithoutDelivey: BEMCheckBox!

    @IBOutlet weak var lblWithoutDelivery: UILabel!

    @IBOutlet weak var SgPaymentMethod: UISegmentedControl!

    @IBOutlet weak var dwBranch: DropDown!

    @IBOutlet weak var dwDeliveryAddress: DropDown!

    @IBOutlet weak var stDeliveryAddress: UIStackView!

    @IBOutlet weak var txtDiscount: UITextField!

    @IBOutlet weak var lblOrderPrice: UILabel!

    @IBOutlet weak var lblDeliveryPrice: UILabel!

    @IBOutlet weak var lblTotalPrice: UILabel!

    @IBOutlet weak var confirmDiscountBtn: UIButton!
    @IBOutlet weak var chAgree: BEMCheckBox!

    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var dwPaymentMethod: DropDown!
    @IBOutlet weak var applePayView: UIStackView!
    var objectResturant: RestaurantDetails?

    var objectHala: Hala?

    var orders: [NewOrderItem] = []

    var cityId: Int?

    var idBranch: Int?

    var idAddress: Int?

    var deliveryPrice = 0.0

    var callback: ((_ orders: [NewOrderItem]?) -> Void)?

    var totalPrice: Double?

    var totalOrderPrice: Double?

    var totalAmount: Double = 0
    var paymentMethodType: paymentMethodType = .visa
    var transactionId = ""

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
        self.consTableView.constant = self.tableView.contentSize.height
    }

    @IBAction func btnBack(_ sender: Any) {
        self.callback?(orders)
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnSelectDate(_ sender: Any) {

        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "SelectDateReserveViewController") as! SelectDateReserveViewController
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overFullScreen
        vc.objectRestaurant = self.objectResturant
        vc.objectHala = self.objectHala
        vc.callback = { date, time in
            self.txtDateAndTime.text = "\(date ?? "") \(time ?? "")"
        }
        self.present(vc, animated: true, completion: nil)

//        let datePicker = ActionSheetDatePicker(title: "Date and Time".localize_,
//                                               datePickerMode: UIDatePicker.Mode.dateAndTime,
//                                               selectedDate: Date(),
//                                               doneBlock: { picker, date, origin in
//                                                self.txtDateAndTime.text = (date as? Date)?.toString(customFormat: "yyyy-MM-dd HH:mm:ss")
//                                                    return
//                                                },
//                                               cancel: { picker in
//                                                    return
//                                               },
//                                               origin: (sender as AnyObject).superview?.superview)
//        let secondsInWeek: TimeInterval = 7 * 24 * 60 * 60;
//        datePicker?.minimumDate = Date(timeInterval: -secondsInWeek, since: Date())
//        datePicker?.maximumDate = Date(timeInterval: secondsInWeek, since: Date())
//
//        datePicker?.show()
    }

    @IBAction func confirmDiscountAction(_ sender: Any) {

        guard let dis = self.txtDiscount.text, dis != "" else {
            self.showSnackbarMessage(message: "The discount field is requied".localize_, isError: true)
            return
        }

        checkCoupon()
    }


    @IBAction func btnDelivery(_ sender: Any) {

        self.chDelivery.on = true
        self.lblDelivery.textColor = "#219CD8".color_
        self.stDeliveryAddress.isHidden = false

        self.chWithoutDelivey.on = false
        self.lblWithoutDelivery.textColor = .opaqueSeparator

        self.calcDeliveryPrice()
    }

    @IBAction func btnWithDelivery(_ sender: Any) {

        self.chDelivery.on = false
        self.lblDelivery.textColor = .opaqueSeparator

        self.stDeliveryAddress.isHidden = true

        self.chWithoutDelivey.on = true
        self.lblWithoutDelivery.textColor = "#219CD8".color_

        self.calcDeliveryPrice()
    }

    @IBAction func btnTermsAndConditions(_ sender: Any) {
        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "TermsOfServiceViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func btnSubmitOrder(_ sender: Any) {
        if UserProfile.shared.tempReceivingMethod == ReceivingMethod.delivery {
            let dateNow = "\((Calendar.current.date(byAdding: .hour, value: 3, to: Date()) ?? Date()))"
            self.txtDateAndTime.text = dateNow.convertNumberToEnglish
        }

        guard validation() else {
            return
        }

        if paymentMethodType == .visa {
    //        if SgPaymentMethod.selectedSegmentIndex == 1 {
    //            let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "PaymentViewController")
    //            vc.modalTransitionStyle = .coverVertical
    //            vc.modalPresentationStyle = .overFullScreen
    //            self.present(vc, animated: true, completion: nil)
    //        } else {
            if let _ = self.objectResturant {
                self.submitDataRestaurant()
            } else if let _ = self.objectHala {
                self.submitDataHala()
            }
    //        }
        } else {
            if PKPaymentAuthorizationController.canMakePayments() {
                // Apple Pay is available on this device
                payWithApplePay()
            } else {
                // Apple Pay is not available on this device
                let message = "Apple Pay is not set up on your device. To make payments with Apple Pay, please go to Settings > Wallet & Apple Pay and add your payment methods."
                self.showAlertError(message: message)
            }
        }
    }
    
    func payWithApplePay() {
        let paymentNetworks = [PKPaymentNetwork.mada, .masterCard, .visa,]

        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {

            let request = PKPaymentRequest()
            request.currencyCode = "SAR"
            request.countryCode = "SA"
            request.merchantIdentifier = "merchant.amrklive.com"
            request.merchantCapabilities = PKMerchantCapability.capability3DS
            request.supportedNetworks = paymentNetworks
            if let _ = self.objectResturant {
                request.paymentSummaryItems = [PKPaymentSummaryItem(label: "\(self.objectResturant?.name ?? "") \("VIA".localize_) \("Ammrk".localize_)", amount: NSDecimalNumber(value: totalAmount))]
            } else if let _ = self.objectHala {
                request.paymentSummaryItems = [PKPaymentSummaryItem(label: "\(self.objectHala?.name ?? "") \("VIA".localize_) \("Ammrk".localize_)", amount: NSDecimalNumber(value: totalAmount))]
            }

            guard let paymentVC = PKPaymentAuthorizationViewController(paymentRequest: request) else {
                showAlertError(message: "Unable to present Apple Pay authorization".localize_)
                return
            }

            paymentVC.delegate = self

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.present(paymentVC, animated: true, completion: nil)
                self.showAlertPopUp(title: "Success!", message: "The Apple Pay transaction was complete") {

                } action2: {
                    self.submitDataRestaurantToApplePay()
                }
            }


        } else {
            let message = PKPaymentAuthorizationViewController.canMakePayments() ? "Apple Pay is not set up on this device. Please set up Apple Pay in the Settings app." : "Unable to make Apple Pay transaction".localize_
            showAlertError(message: message)
        }
    }
}

extension ConfiremNewOrderViewController {

    func setupView() {

        switch UserProfile.shared.tempReceivingMethod {
        case .delivery:
            self.stDeliveryAddress.isHidden = false
//            self.vwDateAndTime.isHidden = true
//            self.vwContact.isHidden = true

            self.deliveryLbl.text = "Delivery in 60 minute".localize_
            let dateNow = "\(Calendar.current.date(byAdding: .hour, value: 3, to: Date()) ?? Date())"

            self.txtDateAndTime.text = "\(dateNow)"
            break
        case .receiptFromBranch:
            self.stDeliveryAddress.isHidden = true
            self.deliveryLbl.text = "Recieve in 25 minute".localize_

            break
        default:
            break
        }

        self.discountLbl.text = "0" + " SAR".localize_

        self.calcPrices()
        self.calcDeliveryPrice()

        self.tableView.register(UINib(nibName: "OrderItemTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderItemTableViewCell")

        self.dwBranch.placeholder = "Branch".localize_
        self.dwBranch.font = UIFont(name: "NeoSansArabic", size: 16)
        self.dwBranch.textAlignment = .center
        self.dwBranch.didSelect { (value, index, id) in
            if let _ = self.objectResturant {
                self.cityId = self.objectResturant?.branches?[index].cityID
            } else if let _ = self.objectHala {
                self.cityId = self.objectHala?.branches?[index].cityID
            }

            self.idBranch = id
            self.calcDeliveryPrice()
        }

        self.dwDeliveryAddress.placeholder = "Address".localize_
        self.dwDeliveryAddress.font = UIFont(name: "NeoSansArabic", size: 16)
        self.dwDeliveryAddress.textAlignment = .center
        self.dwDeliveryAddress.didSelect { (value, index, id) in

            if index == 0 {

                let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "MyAddressesViewController") as! MyAddressesViewController
                vc.callback = {
                    self.dwDeliveryAddress.text = ""
                    self.fetchData()
                }
                self.navigationController?.pushViewController(vc, animated: true)

            } else {
                self.idAddress = id
                self.calcDeliveryPrice()
            }
        }
        
        self.dwPaymentMethod.placeholder = "Payment Method".localize_
        self.dwPaymentMethod.optionIds = [0, 1]
        self.dwPaymentMethod.optionArray = ["Visa".localize_, "Apple Pay".localize_]
        self.dwPaymentMethod.font = UIFont(name: "NeoSansArabic", size: 16)
        self.dwPaymentMethod.textAlignment = .center
        self.dwPaymentMethod.didSelect { (value, index, id) in
            if index == 0 {
                self.paymentMethodType = .visa
            } else {
                self.paymentMethodType = .applePay
            }
            self.applePayView.isHidden = self.paymentMethodType != .applePay
        }
    }

    func localized() {

    }

    func setupData() {
        self.dwBranch.optionIds = []
        self.dwDeliveryAddress.optionIds = []

        for value in self.objectResturant?.branches ?? self.objectHala?.branches ?? [] {
            self.dwBranch.optionIds?.append(value.id ?? 0)
            self.dwBranch.optionArray.append(value.city?.name ?? "")
        }

//        self.stDeliveryAddress.isHidden = true

    }

    func fetchData() {
        let request = BaseRequest()
        request.url = GlobalConstants.ADDRESSES
        request.method = .get

        RequestBuilder.requestWithSuccessfullRespnose(for: AddressModel.self, request: request) { (result) in

            self.dwDeliveryAddress.optionIds?.append(-1)
            self.dwDeliveryAddress.optionArray.append("+ add new address".localize_)

            if result.status ?? false {
                for address in result.data?.items ?? [] {
                    self.dwDeliveryAddress.optionIds?.append(address.id ?? 0)
                    self.dwDeliveryAddress.optionArray.append(address.name ?? "")
                }
            }

        }
    }

    func checkCoupon() {
        let request = BaseRequest()
        request.url = "/check_coupon"
        request.method = .post

        request.parameters = [
            "discount_code": txtDiscount.text ?? "",
        ]

        RequestBuilder.requestWithSuccessfullRespnose(for: CouponResponse.self, request: request) { (result) in

            if result.status ?? false {
                let amount = result.data?.order?.amount
                let type = result.data?.order?.type
                var totalAmount = 0.0

                if let type = type, type == "percent" {
                    let doubleAmount = ((Double(amount ?? 0) ?? 0) / 100)
                    let discount = (self.totalOrderPrice ?? 0) * doubleAmount
                    self.discountLbl.text = "\(discount.rounded(toPlaces: 2))" + " SAR".localize_
                    totalAmount = (self.totalPrice ?? 0) - discount
                } else {
//                    let discount = (self.totalPrice ?? 0) - (Double(amount ?? "0") ?? 0)
                    self.discountLbl.text = "\((Double(amount ?? 0) ?? 0).rounded(toPlaces: 2))" + " SAR".localize_

                    totalAmount = (self.totalPrice ?? 0) - (Double(amount ?? 0) ?? 0)
                }

                self.totalAmount = totalAmount

                self.lblTotalPrice.text = "\(totalAmount.rounded(toPlaces: 2))" + " SAR".localize_


            } else {
                self.showSnackbarMessage(message: "Sorry, the coupon is not valid".localize_, isError: true)

            }
        }
    }

}

extension ConfiremNewOrderViewController {

    func calcDeliveryPrice() {

        if UserProfile.shared.tempReceivingMethod != ReceivingMethod.delivery {
            self.lblDeliveryPrice.text = "0"
        } else {
            self.lblDeliveryPrice.text = "Price calculation".localize_
        }

        guard let cityId = self.cityId, let idBranch = self.idBranch, let idAddress = self.idAddress else {
            return
        }

        var id = 0

        if let obj = objectResturant {
            id = obj.id ?? 0
        } else if let obj = objectHala {
            id = obj.id ?? 0
        }

        let request = BaseRequest()
        request.url = "\(GlobalConstants.RESTAURANTS)/\(id)/order"
        request.method = .post

        request.parameters = [
            "branch_id": cityId,
            "district_id": idBranch,
            "delivery": UserProfile.shared.tempReceivingMethod == ReceivingMethod.delivery ? 1 : 0,
            "address_id": idAddress,
            "get_price": 1
        ]

        RequestBuilder.requestWithSuccessfullRespnose(for: DeliveryPriceModel.self, request: request) { (result) in

            if result.status ?? false {
                let deliveryPrice = result.data?.order?.deliveryPrice ?? 0
                let totalPrice = (self.totalOrderPrice ?? 0) + Double(deliveryPrice)

                self.lblDeliveryPrice.text = "\(deliveryPrice)" + " SAR".localize_
                self.lblTotalPrice.text = "\(totalPrice.rounded(toPlaces: 2))" + " SAR".localize_
                self.totalPrice = totalPrice.rounded(toPlaces: 2)
                self.totalAmount = totalPrice.rounded(toPlaces: 2)
            }
        }
    }

    func calcPrices() {

        var orderPrice = 0.0

        var totalAdditionsPrice = 0.0

        for (_, order) in self.orders.enumerated() {

            let quantity = Double(order.quantity ?? 0)

            orderPrice += (Double(order.order?.price ?? order.orderHala?.price ?? 0)) * quantity

            totalAdditionsPrice += ((order.additionsPrice ?? 1) * quantity)
        }

        let totalOrderPrice = orderPrice + totalAdditionsPrice
        self.totalOrderPrice = totalOrderPrice.rounded(toPlaces: 2)

        self.lblOrderPrice.text = "\(totalOrderPrice.rounded(toPlaces: 2))" + " SAR".localize_
        self.totalPrice = totalOrderPrice.rounded(toPlaces: 2)

        if UserProfile.shared.tempReceivingMethod != ReceivingMethod.delivery {
            self.lblTotalPrice.text = "\(totalOrderPrice.rounded(toPlaces: 2))" + " SAR".localize_
        }
    }

    func validation() -> Bool {

//        guard self.txtPhoneNumber.isValidValue else {
//            self.showSnackbarMessage(message: "The phone number field is required".localize_, isError: true)
//            return false
//        }

        guard self.txtDateAndTime.isValidValue else {
            self.showSnackbarMessage(message: "The date and time field is required".localize_, isError: true)
            return false
        }

//        guard self.chDelivery.on || chWithoutDelivey.on else {
//            self.showSnackbarMessage(message: "The delivey field is required".localize_, isError: true)
//            return false
//        }

        if chDelivery.on == false {
            guard self.dwBranch.isValidValue else {
                self.showSnackbarMessage(message: "The branch field is required".localize_, isError: true)
                return false
            }
        }


        if UserProfile.shared.tempReceivingMethod == ReceivingMethod.delivery {
            guard self.dwDeliveryAddress.isValidValue else {
                self.showSnackbarMessage(message: "The delivery address field is required".localize_, isError: true)
                return false
            }
        }

        guard self.chAgree.on else {
            self.showSnackbarMessage(message: "Privacy Policy must be approved".localize_, isError: true)
            return false
        }

//        guard self.txtPhoneNumber.text?.count == 10 else {
//            self.showSnackbarMessage(message: "The phone number must be 10 digits".localize_, isError: true)
//            return false
//        }

//        guard self.txtPhoneNumber.text?.starts(with: "05") ?? false else {
//            self.showSnackbarMessage(message: "The phone number must start with 05".localize_, isError: true)
//            return false
//        }

        return true
    }

    func submitDataRestaurant() {

        let request = BaseRequest()

        if let _ = self.objectResturant {
            request.url = "\(GlobalConstants.RESTAURANTS)/\(self.objectResturant?.id ?? 0)/order"
        } else if let _ = self.objectHala {
            request.url = "\(GlobalConstants.HALAS)/\(self.objectHala?.id ?? 0)/order"
        }

        request.method = .post

        request.parameters = [
            "branch_id": self.cityId ?? 0,
            "district_id": self.idBranch ?? 0,
            "time": self.txtDateAndTime.text ?? "",
            "delivery": UserProfile.shared.tempReceivingMethod == ReceivingMethod.delivery ? 1 : 0,
            "mobile": "",
            "pay_type": "visa",
        ]

        if self.txtDiscount.isValidValue {
            request.parameters["discount_code"] = self.txtDiscount.text ?? ""
        }

        if UserProfile.shared.tempReceivingMethod == ReceivingMethod.delivery {
            request.parameters["address_id"] = self.idAddress ?? 0
        }

        for (index, order) in self.orders.enumerated() {

            var additions: [String] = []
            var removes: [String] = []

            for item in order.additions ?? [] {
                additions.append("\(item)")
            }

            for item in order.removes ?? [] {
                removes.append("\(item)")
            }

            request.parameters["order[id][\(index)]"] = order.order?.id ?? 0
            request.parameters["order[qnt][\(index)]"] = order.quantity ?? 0
            request.parameters["order[additions][\(index)]"] = additions.joined(separator: ",")
            request.parameters["order[removes][\(index)]"] = removes.joined(separator: ",")
        }

        RequestBuilder.requestWithSuccessfullRespnose(for: ReserveModel.self, request: request) { (result) in

            if result.status ?? false {
                self.showSnackbarMessage(message: "We hope to pay in order to confirm your order".localize_, isError: false)

//                if self.SgPaymentMethod.selectedSegmentIndex == 1  {
//                    var id = 0
//
//                    if let obj = self.objectResturant {
//                        id = obj.id ?? 0
//                    } else if let obj = self.objectHala {
//                        id = obj.id ?? 0
//                    }

                let url = "https://ammrk.com/api/payment/\(result.data?.order?.id ?? 0)?api_token=\(UserProfile.shared.currentUser?.apiToken ?? "")"
                print(url)
                let vc =

                UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "PaymentWebKitViewController") as! PaymentWebKitViewController
                vc.paymentUrl = url
                vc.object = result.data?.order
                self.navigationController?.pushViewController(vc, animated: true)

//                } else {

//                    let vc1 = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "MainTabbarViewController")
//                    let vc2 = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "OrderDetailsViewController") as! OrderDetailsViewController
//                    vc2.object = result.data?.order
//
//                    self.navigationController?.setViewControllers([vc1, vc2], animated: true)
//                }


            } else {
                self.showSnackbarMessage(message: result.data?.message ?? "Something happened! Please try again later".localize_, isError: true)
            }

        }

    }
    
    func submitDataRestaurantToApplePay() {

        let request = BaseRequest()

        if let _ = self.objectResturant {
            request.url = "\(GlobalConstants.RESTAURANTS)/\(self.objectResturant?.id ?? 0)/order"
        } else if let _ = self.objectHala {
            request.url = "\(GlobalConstants.HALAS)/\(self.objectHala?.id ?? 0)/order"
        }

        request.method = .post

        request.parameters = [
            "branch_id": self.cityId ?? 0,
            "district_id": self.idBranch ?? 0,
            "time": self.txtDateAndTime.text ?? "",
            "delivery": UserProfile.shared.tempReceivingMethod == ReceivingMethod.delivery ? 1 : 0,
            "mobile": "",
            "pay_type": "visa",
            "lat": UserProfile.shared.currentUser?.userInfo?.lat ?? 0.0,
            "lng": UserProfile.shared.currentUser?.userInfo?.lng ?? 0.0,
        ]

        if self.txtDiscount.isValidValue {
            request.parameters["discount_code"] = self.txtDiscount.text ?? ""
        }

        if UserProfile.shared.tempReceivingMethod == ReceivingMethod.delivery {
            request.parameters["address_id"] = self.idAddress ?? 0
        }

        for (index, order) in self.orders.enumerated() {

            var additions: [String] = []
            var removes: [String] = []

            for item in order.additions ?? [] {
                additions.append("\(item)")
            }

            for item in order.removes ?? [] {
                removes.append("\(item)")
            }

            request.parameters["order[id][\(index)]"] = order.order?.id ?? 0
            request.parameters["order[qnt][\(index)]"] = order.quantity ?? 0
            request.parameters["order[additions][\(index)]"] = additions.joined(separator: ",")
            request.parameters["order[removes][\(index)]"] = removes.joined(separator: ",")
            let subDictionary: [String: Any] = [
                "trackId": order.order?.id ?? 0,
                "amount": order.quantity ?? 0,
                "paymentMethod": "credit_card",
                "transactionIdentifier": self.transactionId
            ]
            request.parameters["applePay"] = subDictionary
        }

        RequestBuilder.requestWithSuccessfullRespnose(for: ReserveModel.self, request: request) { (result) in
            if result.status ?? false {
                self.showSnackbarMessage(message: "We hope to pay in order to confirm your order".localize_, isError: false)
            } else {
                self.showSnackbarMessage(message: result.data?.message ?? "Something happened! Please try again later".localize_, isError: true)
            }
        }
    }

    func submitDataHala() {

        let request = BaseRequest()
        request.url = "\(GlobalConstants.HALAS)/\(self.objectHala?.id ?? 0)/order"
        request.method = .post

        request.parameters = [
            "branch_id": self.cityId ?? 0,
            "district_id": self.idBranch ?? 0,
            "time": self.txtDateAndTime.text ?? "",
            "delivery": self.chDelivery.on ? 1 : 0,
            "mobile": "",
            "pay_type": "visa",
        ]


        if self.txtDiscount.isValidValue {
            request.parameters["discount_code"] = self.txtDiscount.text ?? ""
        }

        if self.chDelivery.on {
            request.parameters["address_id"] = self.idAddress ?? 0
        }

        for (index, order) in self.orders.enumerated() {

            var additions: [String] = []
            var removes: [String] = []

            for item in order.additions ?? [] {
                additions.append("\(item)")
            }

            for item in order.removes ?? [] {
                removes.append("\(item)")
            }

            request.parameters["order[id][\(index)]"] = order.orderHala?.id ?? 0
            request.parameters["order[qnt][\(index)]"] = order.quantity ?? 0
            request.parameters["order[additions][\(index)]"] = removes.joined(separator: ",")
            request.parameters["order[removes][\(index)]"] = additions.joined(separator: ",")
        }

        RequestBuilder.requestWithSuccessfullRespnose(for: ReserveModel.self, request: request) { (result) in

            if result.status ?? false {

                self.showSnackbarMessage(message: "We hope to pay in order to confirm your order".localize_, isError: false)
//                if self.SgPaymentMethod.selectedSegmentIndex == 1  {
//                    var id = 0
//
//                    if let obj = self.objectResturant {
//                        id = obj.id ?? 0
//                    } else if let obj = self.objectHala {
//                        id = obj.id ?? 0
//                    }
                print("order id is: \(result.data?.order?.id ?? 0)")
                let url = "https://ammrk.com/api/payment/\(result.data?.order?.id ?? 0)?api_token=\(UserProfile.shared.currentUser?.apiToken ?? "")"
                print(url)
                let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "PaymentWebKitViewController") as! PaymentWebKitViewController
                vc.paymentUrl = url
                vc.object = result.data?.order
                self.navigationController?.pushViewController(vc, animated: true)

//                } else {
//                    let vc1 = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "MainTabbarViewController")
//                    let vc2 = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "OrderDetailsViewController") as! OrderDetailsViewController
//                    vc2.object = result.data?.order
//
//                    self.navigationController?.setViewControllers([vc1, vc2], animated: true)
//
//                }

            } else {
                self.showSnackbarMessage(message: result.data?.message ?? "Something happened! Please try again later".localize_, isError: true)
            }

        }

    }

}


extension ConfiremNewOrderViewController: PKPaymentAuthorizationViewControllerDelegate {

    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        self.dismiss(animated: true)
    }

    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {

        self.transactionId = payment.token.transactionIdentifier

        
        completion(PKPaymentAuthorizationResult(status: PKPaymentAuthorizationStatus.success, errors: []))
        
    }

}

extension ConfiremNewOrderViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemTableViewCell", for: indexPath) as! OrderItemTableViewCell
        cell.indexPath = indexPath
        cell.object = self.orders[indexPath.row]
        cell.configureCell()
        return cell
    }

}
