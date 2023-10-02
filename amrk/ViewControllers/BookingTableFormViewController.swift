/*********************		Yousef El-Madhoun		*********************/
//
//  BookingTableFormViewController.swift
//  amrk
//
//  Created by yousef on 27/08/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit
import iOSDropDown
import BEMCheckBox
import ActionSheetPicker_3_0
import PassKit

class BookingTableFormViewController: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var imgResturant: UIImageView!
    
    @IBOutlet weak var dwSelectBranch: DropDown!
    
    @IBOutlet weak var txtPresonName: UITextField!
    
    @IBOutlet weak var reserveFeesLbl: UILabel!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    
    @IBOutlet weak var dwPersonCount: DropDown!
    
    @IBOutlet weak var chIndoorSessions: BEMCheckBox!
    
    @IBOutlet weak var lblIndoorSessions: UILabel!
    
    @IBOutlet weak var chOutdoorSessions: BEMCheckBox!
    
    @IBOutlet weak var lblOutdoorSessions: UILabel!
    
    @IBOutlet weak var coTime: UICollectionView!
    
    @IBOutlet weak var chMorning: BEMCheckBox!
    
    @IBOutlet weak var lblMorning: UILabel!
    
    @IBOutlet weak var chEvening: BEMCheckBox!
    
    @IBOutlet weak var lblEvening: UILabel!
    
    @IBOutlet weak var txtTime: UITextField!
    
    @IBOutlet weak var txtDiscountCode: UITextField!
    
    @IBOutlet weak var txtDetails: UITextView!
    
    @IBOutlet weak var lblRestaurantPolicy: UILabel!
    
    @IBOutlet weak var chAgree: BEMCheckBox!
    
    @IBOutlet weak var stPaymentType: UISegmentedControl!
    @IBOutlet weak var dwPaymentMethod: DropDown!
    @IBOutlet weak var applePayView: UIStackView!

    var reserveTimes: [String] = ["7.00", "7.15", "7.30", "7.45", "8.00"]
    
    var reserveSelectedTime: Int?
    
    var idRestaurant: Int?
    
    var indexBranch: Int?
    
    var branchItems: [Branch] = []
    
    var fees: Double = 0
    
    var objectRestaurant: RestaurantDetails?
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
    
    @IBAction func paymentActio(_ sender: Any) {
    }
    
    @IBAction func discountAction(_ sender: Any) {
        
        guard let dis = self.txtDiscountCode.text, dis != "" else {
            self.showSnackbarMessage(message: "The discount field is requied".localize_, isError: true)
            return
        }
        
        checkCoupon()
    }
    
    func checkCoupon() {
        let request = BaseRequest()
        request.url = "/check_coupon"
        request.method = .post
        
        request.parameters = [
            "discount_code": txtDiscountCode.text ?? "",
            
        ]
        
        RequestBuilder.requestWithSuccessfullRespnose(for: CouponResponse.self, request: request) { (result) in
            
            if result.status ?? false {
                let amount = result.data?.order?.amount
                let type = result.data?.order?.type
//                var totalAmount = 0.0
                
                if let type = type, type == "percent" {
                    let doubleAmount = ((Double(amount ?? 0)))
                    self.showSnackbarMessage(message: "You have a discount with percent".localize_ + " \(doubleAmount)"  + "%", isError: false)

                } else {
                    self.showSnackbarMessage(message: "You have a discount".localize_ + " \(amount ?? 0)" + " SAR".localize_, isError: false)

                }
                              
                
            } else {
                self.showSnackbarMessage(message: "Sorry, the coupon is not valid".localize_, isError: true)

            }
        
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnMorning(_ sender: Any) {
        self.chMorning.on = true
        self.lblMorning.textColor = "#219CD8".color_
        
        self.lblEvening.textColor = .opaqueSeparator
        self.chEvening.on = false
    }
    
    @IBAction func btnEvening(_ sender: Any) {
        self.chMorning.on = false
        self.lblMorning.textColor = .opaqueSeparator
        
        self.lblEvening.textColor = "#219CD8".color_
        self.chEvening.on = true
    }
    
    @IBAction func btnTerms(_ sender: Any) {
        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "TermsOfServiceViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSelectTime(_ sender: Any) {
        
        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "SelectDateReserveViewController") as! SelectDateReserveViewController
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overFullScreen
        vc.objectRestaurant = self.objectRestaurant
        vc.callback = { date, time in
            self.txtTime.text = "\(date ?? "") \(time ?? "")"
        }
        self.present(vc, animated: true, completion: nil)
        
//        let datePicker = ActionSheetDatePicker(title: "Booking date".localize_,
//                                               datePickerMode: UIDatePicker.Mode.dateAndTime,
//                                               selectedDate: Date(),
//                                               doneBlock: { picker, date, origin in
//                                                self.txtTime.text = (date as? Date)?.toString(customFormat: "yyyy-MM-dd HH:mm:ss")
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
    
    @IBAction func btnIndoorSessions(_ sender: Any) {
        self.chIndoorSessions.on = true
        self.lblIndoorSessions.textColor = "#219CD8".color_
        
        self.lblOutdoorSessions.textColor = .opaqueSeparator
        self.chOutdoorSessions.on = false
    }
    
    @IBAction func btnOutdoorSessions(_ sender: Any) {
        self.chOutdoorSessions.on = true
        self.lblOutdoorSessions.textColor = "#219CD8".color_
        
        self.lblIndoorSessions.textColor = .opaqueSeparator
        self.chIndoorSessions.on = false
    }
    
    @IBAction func brnSendOrder(_ sender: Any) {
        
        guard validation() else {
            return
        }
        
//        if stPaymentType.selectedSegmentIndex == 1 {
//            let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "PaymentViewController")
//            vc.modalTransitionStyle = .coverVertical
//            vc.modalPresentationStyle = .overFullScreen
//            self.present(vc, animated: true, completion: nil)
//        } else {
            self.submitOrder()
//        }
        
    }
    
}

extension BookingTableFormViewController {
    
    func setupView() {
        self.dwSelectBranch.placeholder = "Select branch".localize_
        self.dwSelectBranch.font = UIFont(name: "NeoSansArabic", size: 16)
        self.dwSelectBranch.didSelect { (value, index, id) in
            self.indexBranch = index
        }
        
        self.dwPersonCount.placeholder = "Person count".localize_
        
        self.coTime.register(UINib(nibName: "ReserveTimeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ReserveTimeCollectionViewCell")
        
        self.txtPhoneNumber.delegate = self
        
        self.txtDetails.delegate = self
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 16
        let attributes = [NSAttributedString.Key.paragraphStyle : style, NSAttributedString.Key.font : UIFont(name: "NeoSansArabic", size: 16), NSAttributedString.Key.foregroundColor : UIColor.placeholderText]
        self.txtDetails.attributedText = NSAttributedString(string: "Do you have a special recommendation (subject to availability)?".localize_, attributes: attributes as [NSAttributedString.Key : Any])
        
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
        for value in 1 ... 20 {
            self.dwPersonCount.optionArray.append("\(value)")
        }
    }
    
    func fetchData() {
        let request = BaseRequest()
        request.url = "\(GlobalConstants.RESTAURANTS)/\(self.idRestaurant ?? 0)"
//        request.parameters = ["order_type": "reserve"]
        request.method = .get
        
        RequestBuilder.requestWithSuccessfullRespnose(for: RestaurantDetailsModel.self, request: request) { (result) in
            
            if result.status ?? false {
                
                self.objectRestaurant = result.data?.restaurant
                
                self.lblTitle.text = result.data?.restaurant?.name
                self.imgResturant.imageURL(url: result.data?.restaurant?.image ?? "")
                self.lblRestaurantPolicy.text = result.data?.restaurant?.userInfo?.policy
                self.reserveFeesLbl.text = "\(result.data?.restaurant?.userInfo?.reserveCost ?? 0)" + " SAR".localize_
                self.fees = Double(result.data?.restaurant?.userInfo?.reserveCost ?? 0)
                
                self.dwSelectBranch.optionIds = []
                
                for branch in result.data?.restaurant?.branches ?? [] {
                    self.dwSelectBranch.optionIds?.append(branch.city?.id ?? 0)
                    self.dwSelectBranch.optionArray.append(branch.city?.name ?? "")
                    self.branchItems.append(branch)
                }
            }
        }
    }
}

extension BookingTableFormViewController {
    
    func validation() -> Bool {
        
        guard self.dwSelectBranch.isValidValue else {
            self.showSnackbarMessage(message: "The branch field is required".localize_, isError: true)
            return false
        }
        
//        guard self.txtPresonName.isValidValue else {
//            self.showSnackbarMessage(message: "The preson name field is required".localize_, isError: true)
//            return false
//        }
        
//        guard self.txtPhoneNumber.isValidValue else {
//            self.showSnackbarMessage(message: "The phone number field is required".localize_, isError: true)
//            return false
//        }
        
        guard let _ = self.dwPersonCount.text, self.dwPersonCount.isValidValue else {
            self.showSnackbarMessage(message: "Person count field is required".localize_, isError: true)
            return false
        }
        
        guard self.txtTime.isValidValue else {
            self.showSnackbarMessage(message: "The time is required".localize_, isError: true)
            return false
        }
        
        guard self.chAgree.on else {
            self.showSnackbarMessage(message: "Privacy Policy must be approved".localize_, isError: true)
            return false
        }
        
//        guard self.txtPhoneNumber.text?.count == 10 else {
//            self.showSnackbarMessage(message: "The phone number must be 10 digits".localize_, isError: true)
//            return false
//        }
//
//        guard self.txtPhoneNumber.text?.starts(with: "05") ?? false else {
//            self.showSnackbarMessage(message: "The phone number must start with 05".localize_, isError: true)
//            return false
//        }
        
        return true
    }
    
    func submitOrder() {
        if paymentMethodType == .visa {
            
            let personCount = Int(self.dwPersonCount.text ?? "0") ?? 0
            
            let request = BaseRequest()
            request.url = "\(GlobalConstants.RESTAURANTS)/\(self.idRestaurant ?? 0)/reserve"
            request.method = .post
            
            request.parameters = [
                "branch_id": self.branchItems[indexBranch ?? 0].cityID ?? 0,
                "district_id": self.branchItems[indexBranch ?? 0].id ?? 0,
                "time": self.txtTime.text ?? "",
                "pay_type":  "visa" ,
                "persons": personCount,
                "mobile":  "",
                "owner_name":  "",
            ]
            
    //        print(request.parameters["pay_type"])
            
            if self.txtDiscountCode.isValidValue {
                request.parameters["discount_code"] = self.txtDiscountCode.text ?? ""
            }
            
            if self.txtDetails.isValidValue && self.txtDetails.text != "Do you have a special recommendation (subject to availability)?".localize_ {
                request.parameters["details"] = self.txtDetails.text
            }
            
            RequestBuilder.requestWithSuccessfullRespnose(for: ReserveModel.self, request: request) { (result) in
                            
                if result.status ?? false {
                    
                    if self.fees > 0 {
                        self.showSnackbarMessage(message: "We hope to pay in order to confirm your order, and the fees will be discount from the bill".localize_, isError: false)

                    } else {
                        self.showSnackbarMessage(message: "Your order has been successfully received".localize_, isError: false)

                    }
                    
                    if let total = result.data?.order?.paymentInfo?.total, total > 0 {
                        let url = "https://ammrk.com/api/payment/\(result.data?.order?.id ?? 0)?api_token=\(UserProfile.shared.currentUser?.apiToken ?? "")"
                        print(url)
                        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "PaymentWebKitViewController") as! PaymentWebKitViewController
                        vc.paymentUrl = url
                        vc.object = result.data?.order
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    } else {
                        let vc1 = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "MainTabbarViewController")
                        let vc2 = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "OrderDetailsViewController") as! OrderDetailsViewController
                        vc2.object = result.data?.order

                        self.navigationController?.setViewControllers([vc1, vc2], animated: true)
                    }
                } else {
                    self.showSnackbarMessage(message: result.data?.message ?? "", isError: true)
                }
                
            }
            
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

        let personCount = Int(self.dwPersonCount.text ?? "0") ?? 0

        let request = BaseRequest()
        request.url = "\(GlobalConstants.RESTAURANTS)/\(self.idRestaurant ?? 0)/reserve"
        request.method = .post
        
        request.parameters = [
            "branch_id": self.branchItems[indexBranch ?? 0].cityID ?? 0,
            "district_id": self.branchItems[indexBranch ?? 0].id ?? 0,
            "time": self.txtTime.text ?? "",
            "pay_type":  "visa" ,
            "persons": personCount,
            "mobile":  "",
            "owner_name":  "",
        ]
        
//        print(request.parameters["pay_type"])
        
        if self.txtDiscountCode.isValidValue {
            request.parameters["discount_code"] = self.txtDiscountCode.text ?? ""
        }
        
        if self.txtDetails.isValidValue && self.txtDetails.text != "Do you have a special recommendation (subject to availability)?".localize_ {
            request.parameters["details"] = self.txtDetails.text
        }

        RequestBuilder.requestWithSuccessfullRespnose(for: ReserveModel.self, request: request) { (result) in
            
            if result.status ?? false {
                
                if self.fees > 0 {
                    self.showSnackbarMessage(message: "We hope to pay in order to confirm your order, and the fees will be discount from the bill".localize_, isError: false)
                    
                } else {
                    self.showSnackbarMessage(message: "Your order has been successfully received".localize_, isError: false)
                    
                }
                
                if let total = result.data?.order?.paymentInfo?.total, total > 0 {
                    if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {

                        let request = PKPaymentRequest()
                        request.currencyCode = "SAR"
                        request.countryCode = "SA"
                        request.merchantIdentifier = "merchant.amrklive.com"
                        request.merchantCapabilities = PKMerchantCapability.capability3DS
                        request.supportedNetworks = paymentNetworks
                        request.paymentSummaryItems = [PKPaymentSummaryItem(label: "\(result.data?.order?.provider?.name ?? "") \("VIA".localize_) \("Ammrk".localize_)", amount: NSDecimalNumber(value: total))]

                        guard let paymentVC = PKPaymentAuthorizationViewController(paymentRequest: request) else {
                            self.showAlertError(message: "Unable to present Apple Pay authorization".localize_)
                            return
                        }

                        paymentVC.delegate = self

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            self.present(paymentVC, animated: true, completion: nil)
                            self.showAlertPopUp(title: "Success!", message: "The Apple Pay transaction was complete") {

                            } action2: {
                                self.submitDataRestaurantToApplePay(result: result)
                            }
                        }


                    } else {
                        let message = PKPaymentAuthorizationViewController.canMakePayments() ? "Apple Pay is not set up on this device. Please set up Apple Pay in the Settings app." : "Unable to make Apple Pay transaction".localize_
                        self.showAlertError(message: message)
                    }
                }
            }
        }
    }
    
    func submitDataRestaurantToApplePay(result: ReserveModel) {

        let request = BaseRequest()

        request.url = "\(GlobalConstants.RESTAURANTS)/\(self.objectRestaurant?.id ?? 0)/order"

        request.method = .post

        request.parameters = [
            "branch_id": self.branchItems[indexBranch ?? 0].cityID ?? 0,
            "district_id": self.branchItems[indexBranch ?? 0].id ?? 0,
            "time": self.txtTime.text ?? "",
            "delivery": UserProfile.shared.tempReceivingMethod == ReceivingMethod.delivery ? 1 : 0,
            "mobile": "",
            "pay_type": "visa",
            "lat": UserProfile.shared.currentUser?.userInfo?.lat ?? 0.0,
            "lng": UserProfile.shared.currentUser?.userInfo?.lng ?? 0.0,
        ]

        if self.txtDiscountCode.isValidValue {
            request.parameters["discount_code"] = self.txtDiscountCode.text ?? ""
        }
        
        if self.txtDetails.isValidValue && self.txtDetails.text != "Do you have a special recommendation (subject to availability)?".localize_ {
            request.parameters["details"] = self.txtDetails.text
        }
 
        var additions: [String] = []
        var removes: [String] = []
        let index = 0

        request.parameters["order[id][\(index)]"] = result.data?.order?.id ?? 0
        request.parameters["order[qnt][\(index)]"] = 1
        request.parameters["order[additions][\(index)]"] = additions.joined(separator: ",")
        request.parameters["order[removes][\(index)]"] = removes.joined(separator: ",")
        let subDictionary: [String: Any] = [
            "trackId": result.data?.order?.id ?? 0,
            "amount": result.data?.order?.price ?? 0,
            "paymentMethod": "credit_ard",
            "transactionIdentifier": self.transactionId
        ]
        request.parameters["applePay"] = subDictionary

        RequestBuilder.requestWithSuccessfullRespnose(for: ReserveModel.self, request: request) { (result) in
            if result.status ?? false {
                self.showSnackbarMessage(message: "We hope to pay in order to confirm your order".localize_, isError: false)
            } else {
                self.showSnackbarMessage(message: result.data?.message ?? "Something happened! Please try again later".localize_, isError: true)
            }
        }
    }
}

extension BookingTableFormViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.reserveTimes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.coTime.dequeueReusableCell(withReuseIdentifier: "ReserveTimeCollectionViewCell", for: indexPath) as! ReserveTimeCollectionViewCell
        cell.indexPath = indexPath
        cell.object = self.reserveTimes[indexPath.row]
        cell.configureCell()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.reserveSelectedTime = indexPath.row
        self.coTime.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 80
        let height = 45
        return CGSize(width: width, height: height)
    }
    
}

extension BookingTableFormViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 10
    }
    
}

extension BookingTableFormViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtDetails.text == "Do you have a special recommendation (subject to availability)?".localize_ && txtDetails.textColor == UIColor.placeholderText {
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 10
            let attributes = [NSAttributedString.Key.paragraphStyle : style, NSAttributedString.Key.font : UIFont(name: "NeoSansArabic", size: 16), NSAttributedString.Key.foregroundColor : UIColor.placeholderText]
            self.txtDetails.attributedText = NSAttributedString(string: "", attributes: attributes as [NSAttributedString.Key : Any])
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard txtDetails.text == "Do you have a special recommendation (subject to availability)?".localize_ && txtDetails.textColor == UIColor.placeholderText else {
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 10
            let attributes = [NSAttributedString.Key.paragraphStyle : style, NSAttributedString.Key.font : UIFont(name: "NeoSansArabic", size: 16), NSAttributedString.Key.foregroundColor : UIColor.black]
            self.txtDetails.attributedText = NSAttributedString(string: txtDetails.text, attributes: attributes as [NSAttributedString.Key : Any])
            return
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if txtDetails.text.isEmpty {
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 10
            let attributes = [NSAttributedString.Key.paragraphStyle : style, NSAttributedString.Key.font : UIFont(name: "NeoSansArabic", size: 16), NSAttributedString.Key.foregroundColor : UIColor.placeholderText]
            self.txtDetails.attributedText = NSAttributedString(string: "Do you have a special recommendation (subject to availability)?".localize_, attributes: attributes as [NSAttributedString.Key : Any])
        }
    }
    
}

extension BookingTableFormViewController: PKPaymentAuthorizationViewControllerDelegate {

    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        self.dismiss(animated: true)
    }

    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {

        self.transactionId = payment.token.transactionIdentifier

        
        completion(PKPaymentAuthorizationResult(status: PKPaymentAuthorizationStatus.success, errors: []))
        
    }

}
