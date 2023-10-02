/*********************        Yousef El-Madhoun        *********************/
//
//  OrderTrainingHallViewController.swift
//  amrk
//
//  Created by yousef on 31/08/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit
import BEMCheckBox
import ActionSheetPicker_3_0
import iOSDropDown
import MOLH
import PassKit

class OrderTrainingHallViewController: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var imgHall: UIImageView!
    
    @IBOutlet weak var txtPersonName: UITextField!
    
    @IBOutlet weak var txtCompanyName: UITextField!
    
    @IBOutlet weak var txtPhoneNumber: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var dwPersonCount: DropDown!
    
    @IBOutlet weak var chCoffeeBreak: BEMCheckBox!
    
    @IBOutlet weak var lblCoffeeBreak: UILabel!
    
    @IBOutlet weak var chWithoutCoffeeBreak: BEMCheckBox!
    
    @IBOutlet weak var lblWithoutCoffeeBreak: UILabel!
    
    @IBOutlet weak var chMorning: BEMCheckBox!
    
    @IBOutlet weak var lblMorning: UILabel!
    
    @IBOutlet weak var chEvening: BEMCheckBox!
    
    @IBOutlet weak var lblEvening: UILabel!
    
    @IBOutlet weak var txtBookingDate: UITextField!
    
    @IBOutlet weak var txtDiscount: UITextField!
    
    @IBOutlet weak var txtDetails: UITextView!
    
    @IBOutlet weak var lblPolicy: UILabel!
    
    @IBOutlet weak var chAgree: BEMCheckBox!
    
    @IBOutlet weak var sgPaymentType: UISegmentedControl!
    @IBOutlet weak var dwPaymentMethod: DropDown!
    @IBOutlet weak var applePayView: UIStackView!

    var object: RoomItemData?
    var selectedPersonType: PersonData?
    var personType = ""
    var paymentMethodType: paymentMethodType = .visa
    var transactionId = ""
    var amount: Int = 0

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
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmDiscount(_ sender: Any) {
        
        guard let dis = self.txtDiscount.text, dis != "" else {
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
            "discount_code": txtDiscount.text ?? "",
            
        ]
        
        RequestBuilder.requestWithSuccessfullRespnose(for: CouponResponse.self, request: request) { (result) in
            
            if result.status ?? false {
                self.amount = result.data?.order?.amount ?? 0
                let type = result.data?.order?.type
    //                var totalAmount = 0.0
                
                if let type = type, type == "percent" {
                    let doubleAmount = ((Double(self.amount ) ))
                    self.showSnackbarMessage(message: "You have a discount with percent".localize_ + " \(doubleAmount)"  + "%", isError: false)

                } else {
                    self.showSnackbarMessage(message: "You have a discount".localize_ + " \(self.amount )" + " SAR".localize_, isError: false)

                }
                              
                
            } else {
                self.showSnackbarMessage(message: "Sorry, the coupon is not valid".localize_, isError: true)

            }
        
        }
    }
    
    
    
    @IBAction func btnCoffeeBreak(_ sender: Any) {
        if !self.chCoffeeBreak.on {
            self.chCoffeeBreak.on = true
            self.lblCoffeeBreak.textColor = "#219CD8".color_
            self.chWithoutCoffeeBreak.on = false
            self.lblWithoutCoffeeBreak.textColor = .opaqueSeparator
        }
    }
    
    @IBAction func btnWithoutCoffeeBreak(_ sender: Any) {
        if !self.chWithoutCoffeeBreak.on {
            self.chCoffeeBreak.on = false
            self.lblCoffeeBreak.textColor = .opaqueSeparator
            self.chWithoutCoffeeBreak.on = true
            self.lblWithoutCoffeeBreak.textColor = "#219CD8".color_
        }
    }
    
    @IBAction func btnMorningTime(_ sender: Any) {
        if !self.chMorning.on {
            self.chMorning.on = true
            self.lblMorning.textColor = "#219CD8".color_
            self.chEvening.on = false
            self.lblEvening.textColor = .opaqueSeparator
        }
    }
    
    @IBAction func btnEveningTime(_ sender: Any) {
        if !self.chEvening.on {
            self.chMorning.on = false
            self.lblMorning.textColor = .opaqueSeparator
            self.chEvening.on = true
            self.lblEvening.textColor = "#219CD8".color_
        }
    }
    
    @IBAction func btnChooseTime(_ sender: Any) {
        
        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "SelectDateReserveViewController") as! SelectDateReserveViewController
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overFullScreen
        vc.objectTraining = self.object
        vc.callback = { date, time in
            self.txtBookingDate.text = "\(date ?? "") \(time ?? "")"
        }
        self.present(vc, animated: true, completion: nil)
        
//        let datePicker = ActionSheetDatePicker(title: "Booking date".localize_,
//                                               datePickerMode: UIDatePicker.Mode.dateAndTime,
//                                               selectedDate: Date(),
//                                               doneBlock: { picker, date, origin in
//                                                self.txtBookingDate.text = (date as? Date)?.toString(customFormat: "yyyy-MM-dd HH:mm:ss")
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
    
    @IBAction func btnTerms(_ sender: Any) {
        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "TermsOfServiceViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSendOrder(_ sender: Any) {
        
        guard validation() else {
            return
        }
        
//        if sgPaymentType.selectedSegmentIndex == 1 {
//            let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "PaymentViewController")
//            vc.modalTransitionStyle = .coverVertical
//            vc.modalPresentationStyle = .overFullScreen
//            self.present(vc, animated: true, completion: nil)
//        } else {
//        }
        if paymentMethodType == .visa || paymentMethodType == .cash {
            self.sendOrder()
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
            request.paymentSummaryItems = [PKPaymentSummaryItem(label: "\(self.object?.name ?? "") \("VIA".localize_) \("Ammrk".localize_)", amount: NSDecimalNumber(value: amount))]

            guard let paymentVC = PKPaymentAuthorizationViewController(paymentRequest: request) else {
                showAlertError(message: "Unable to present Apple Pay authorization".localize_)
                return
            }

            paymentVC.delegate = self

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.present(paymentVC, animated: true, completion: nil)
                self.showAlertPopUp(title: "Success!", message: "The Apple Pay transaction was complete") {

                } action2: {
                    self.submitDataToApplePay()
                }
            }


        } else {
            let message = PKPaymentAuthorizationViewController.canMakePayments() ? "Apple Pay is not set up on this device. Please set up Apple Pay in the Settings app." : "Unable to make Apple Pay transaction".localize_
            showAlertError(message: message)
        }
    }
    
    func submitDataToApplePay() {
        let request = BaseRequest()
        request.url = "\(GlobalConstants.ROOMS)/\(self.object?.id ?? 0)/reserve_wedding"
        request.method = .post
        
        request.parameters = [
            "persons": self.selectedPersonType?.max ?? 0,
            "owner_name":  "",
            "time": self.txtBookingDate.text ?? "",
            "owner_email": "",//self.txtEmail.text ?? "",
            "owner_company_name": self.txtCompanyName.text ?? "",
            "mobile":  "",
            "persons_type": self.personType,
            "pay_type": paymentMethodType == .cash ? "cash" : paymentMethodType == .visa ? "visa" : "apple pay",
            "time_section": self.chMorning.on ? "am" : "pm",
            "coffee_break": self.chCoffeeBreak.on ? 1 : 0,
            "discount_code": self.txtDiscount.text ?? "",
        ]
        let subDictionary: [String: Any] = [
            "trackId": self.object?.id ?? 0,
            "amount": self.object?.offers?.first?.price ?? 0,
            "paymentMethod": "credit_card",
            "transactionIdentifier": self.transactionId
        ]
        request.parameters["applePay"] = subDictionary

        if self.txtDetails.isValidValue && self.txtDetails.text != "Do you have a special recommendation (subject to availability)?".localize_ {
            request.parameters["details"] = self.txtDetails.text
        }
        
        RequestBuilder.requestWithSuccessfullRespnose(for: ReserveModel.self, request: request) { (result) in
            
            if result.status ?? false {
                self.showSnackbarMessage(message: "We hope to pay in order to confirm your order".localize_, isError: false)
            } else {
                self.showSnackbarMessage(message: result.data?.message ?? "Something happened! Please try again later".localize_, isError: true)
            }
        }
    }
}

extension OrderTrainingHallViewController {
 
    func validation() -> Bool {
        
//        guard let _ = self.txtPersonName.text, self.txtPersonName.isValidValue else {
//            self.showSnackbarMessage(message: "Person name field is required".localize_, isError: true)
//            return false
//        }
        
        guard let _ = self.txtCompanyName.text, self.txtCompanyName.isValidValue else {
            self.showSnackbarMessage(message: "Company name field is required".localize_, isError: true)
            return false
        }
        
//        guard let phoneNumber = self.txtPhoneNumber.text, self.txtPhoneNumber.isValidValue else {
//            self.showSnackbarMessage(message: "Phone number field is required".localize_, isError: true)
//            return false
//        }
        
//        guard let _ = self.txtEmail.text, self.txtEmail.isValidValue else {
//            self.showSnackbarMessage(message: "Email field is required".localize_, isError: true)
//            return false
//        }
        
        guard let _ = self.dwPersonCount.text, self.dwPersonCount.isValidValue else {
            self.showSnackbarMessage(message: "Person count field is required".localize_, isError: true)
            return false
        }
        
        guard self.chCoffeeBreak.on || self.chWithoutCoffeeBreak.on else {
            self.showSnackbarMessage(message: "Coffee break field is required".localize_, isError: true)
            return false
        }
        
        guard self.chMorning.on || self.chEvening.on else {
            self.showSnackbarMessage(message: "Time section field is required".localize_, isError: true)
            return false
        }
        
        guard let _ = self.txtBookingDate.text, self.txtBookingDate.isValidValue else {
            self.showSnackbarMessage(message: "Booking date field is required".localize_, isError: true)
            return false
        }
        
        guard self.chAgree.on else {
            self.showSnackbarMessage(message: "Privacy Policy must be approved".localize_, isError: true)
            return false
        }
        
//        guard self.txtEmail.text?.isValidEmail() ?? true else {
//            self.showSnackbarMessage(message: "Email is incorrect".localize_, isError: true)
//            return false
//        }
        
//        guard phoneNumber.count == 10 else {
//            self.showSnackbarMessage(message: "The phone number must be 10 digits".localize_, isError: true)
//            return false
//        }
//
//        guard phoneNumber.starts(with: "05") else {
//            self.showSnackbarMessage(message: "The phone number must start with 05".localize_, isError: true)
//            return false
//        }
        
        return true
    }
    
    func sendOrder() {
        
        let request = BaseRequest()
        request.url = "\(GlobalConstants.ROOMS)/\(self.object?.id ?? 0)/reserve_training"
        request.method = .post
        
    
        
        request.parameters = [
            
            
            
            "persons": self.selectedPersonType?.max ?? 0,
            "owner_name":  "",
            "time": self.txtBookingDate.text ?? "",
            "owner_email": "",//self.txtEmail.text ?? "",
            "owner_company_name": self.txtCompanyName.text ?? "",
            "mobile":  "",
            "persons_type": self.personType,
            "pay_type": paymentMethodType == .cash ? "cash" : paymentMethodType == .visa ? "visa" : "apple pay",
            "time_section": self.chMorning.on ? "am" : "pm",
            "coffee_break": self.chCoffeeBreak.on ? 1 : 0,
            "discount_code": self.txtDiscount.text ?? "",
        ]
        
        if self.txtDetails.isValidValue && self.txtDetails.text != "Do you have a special recommendation (subject to availability)?".localize_ {
            request.parameters["details"] = self.txtDetails.text
        }
        
        RequestBuilder.requestWithSuccessfullRespnose(for: ReserveModel.self, request: request) { (result) in
            
            if result.status ?? false {
                self.showSnackbarMessage(message: "Your order has been successfully received".localize_, isError: false)
                
                
                if self.sgPaymentType.selectedSegmentIndex == 1  {
                    
                    
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
                self.showSnackbarMessage(message: "Something happened! Please try again later".localize_, isError: true)
            }
            
        }
        
    }
    
}

extension OrderTrainingHallViewController {
    
    func setupView() {
        self.lblTitle.text = self.object?.name
        self.imgHall.imageURL(url: self.object?.image ?? "")
        self.lblPolicy.text = self.object?.userInfo?.policy
        
        self.dwPersonCount.placeholder = "Select Hall".localize_
        
        self.txtPhoneNumber.delegate = self
        
        self.txtEmail.isHidden = true
        
        self.txtDetails.delegate = self
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 16
        let attributes = [NSAttributedString.Key.paragraphStyle : style, NSAttributedString.Key.font : UIFont(name: "NeoSansArabic", size: 16), NSAttributedString.Key.foregroundColor : UIColor.placeholderText]
        self.txtDetails.attributedText = NSAttributedString(string: "Do you have a special recommendation (subject to availability)?".localize_, attributes: attributes as [NSAttributedString.Key : Any])
        
        self.dwPaymentMethod.placeholder = "Payment Method".localize_
        self.dwPaymentMethod.optionIds = [0, 1, 2]
        self.dwPaymentMethod.optionArray = ["Cash".localize_, "Visa".localize_, "Apple Pay".localize_]
        self.dwPaymentMethod.font = UIFont(name: "NeoSansArabic", size: 16)
        self.dwPaymentMethod.textAlignment = .center
        self.dwPaymentMethod.didSelect { (value, index, id) in
            if index == 0 {
                self.paymentMethodType = .cash
            } else if index == 1 {
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
//        for value in stride(from: 10, to: 110, by: 10){
//            self.dwPersonCount.optionArray.append("\(value)")
//        }

        var str = ""
        
        if MOLHLanguage.currentAppleLanguage() == "ar" {
            str = "Type".localize_ + "\t\t" + "Hall capacity".localize_ + "\t" + "Price person".localize_
        } else {
            str = "Type".localize_ + "\t\t" + "Hall capacity".localize_ + "\t\t" + "Price person".localize_
        }
        
        self.dwPersonCount.optionArray.append(str)
        
        if let obj = object, let userData = obj.userInfo {
            if let men = userData.men {
                var str = ""
                
                if MOLHLanguage.currentAppleLanguage() == "ar" {
                    str = "Men".localize_ + "\t\t\t" + "\(men.max ?? 0)" + "\t\t " + "\(men.price ?? 0)"
                } else {
                    str = "Men".localize_ + "\t\t\t   " + "\(men.max ?? 0)" + "\t\t\t " + "\(men.price ?? 0)"
                }
                
                self.dwPersonCount.optionArray.append(str)
            }
            
            if let women = userData.women {
                var str = ""
                
                if MOLHLanguage.currentAppleLanguage() == "ar" {
                    str = "Women".localize_ + "\t\t\t" + "\(women.max ?? 0)" + "\t\t " + "\(women.price ?? 0)"
                } else {
                    str = "Women".localize_ + "\t\t   " + "\(women.max ?? 0)" + "\t\t\t " + "\(women.price ?? 0)"
                }

                self.dwPersonCount.optionArray.append(str)
            }
            
            if let womenMen = userData.womenMen {
                var str = ""
                
                if MOLHLanguage.currentAppleLanguage() == "ar" {
                    str = "Men & Women".localize_ + "\t" + "\(womenMen.max ?? 0)" + "\t\t " + "\(womenMen.price ?? 0)"
                } else {
                    str = "Men & Women".localize_ + "\t   " + "\(womenMen.max ?? 0)" + "\t\t\t " + "\(womenMen.price ?? 0)"
                }
                
                self.dwPersonCount.optionArray.append(str)
            }
        }
        
        
        
        var selectedIndex = 0
        
        dwPersonCount.didSelect{(selectedText , index ,id) in
            if (index == 0) {
                
                
            } else if (index == 1) {

                self.selectedPersonType = self.object?.userInfo?.men
                self.personType = "men"
            } else if (index == 2) {

                self.selectedPersonType = self.object?.userInfo?.women
                self.personType = "women"

            } else if (index == 3) {
                self.selectedPersonType = self.object?.userInfo?.womenMen
                self.personType = "women_men"

            }
            
            selectedIndex = index
            print("index is \(index)")
        }
        
        dwPersonCount.listDidDisappear {
            if selectedIndex == 0 {
                self.dwPersonCount.text = ""
            }
        }
        
    }
    
    func fetchData() {
        
    }

}

extension OrderTrainingHallViewController: UITextFieldDelegate {
    
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

extension OrderTrainingHallViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtDetails.text == "Do you have a special recommendation (subject to availability)?".localize_ && txtDetails.textColor == UIColor.placeholderText {
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 10
            let attributes = [NSAttributedString.Key.paragraphStyle : style, NSAttributedString.Key.font : UIFont(name: "NeoSansArabic", size: 18), NSAttributedString.Key.foregroundColor : UIColor.placeholderText]
            self.txtDetails.attributedText = NSAttributedString(string: "", attributes: attributes as [NSAttributedString.Key : Any])
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard txtDetails.text == "Do you have a special recommendation (subject to availability)?".localize_ && txtDetails.textColor == UIColor.placeholderText else {
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 10
            let attributes = [NSAttributedString.Key.paragraphStyle : style, NSAttributedString.Key.font : UIFont(name: "NeoSansArabic", size: 18), NSAttributedString.Key.foregroundColor : UIColor.black]
            self.txtDetails.attributedText = NSAttributedString(string: txtDetails.text, attributes: attributes as [NSAttributedString.Key : Any])
            return
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if txtDetails.text.isEmpty {
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 10
            let attributes = [NSAttributedString.Key.paragraphStyle : style, NSAttributedString.Key.font : UIFont(name: "NeoSansArabic", size: 18), NSAttributedString.Key.foregroundColor : UIColor.placeholderText]
            self.txtDetails.attributedText = NSAttributedString(string: "Do you have a special recommendation (subject to availability)?".localize_, attributes: attributes as [NSAttributedString.Key : Any])
        }
    }
}

extension OrderTrainingHallViewController: PKPaymentAuthorizationViewControllerDelegate {

    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        self.dismiss(animated: true)
    }

    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {

        self.transactionId = payment.token.transactionIdentifier

        
        completion(PKPaymentAuthorizationResult(status: PKPaymentAuthorizationStatus.success, errors: []))
        
    }

}
