/*********************		Yousef El-Madhoun		*********************/
//
//  ForgotPasswordViewController.swift
//  amrk
//
//  Created by yousef on 24/08/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var arrowIcon: UIImageView!
    @IBOutlet weak var beforeArrowView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var stPhone: UIStackView!
    
    @IBOutlet weak var icCountry: UIImageView!
    
    @IBOutlet weak var txtPhoneCode: UITextField!
    
    @IBOutlet weak var txtPhoneNumber: UITextField!
    
    @IBOutlet weak var vwEmail: UIView!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var btnSwitchStatus: UIButton!
    
    var country: PhoneNumberCodeModel?
    
    enum PageType {
        case emailStatus
        case phoneStatus
    }
    
    var pageType: PageType = .phoneStatus {
        didSet {
            self.setupPage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        localized()
        setupData()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIView.animate(withDuration: 0.5, animations: {
                self.topView.isHidden = true
                self.arrowIcon.isHidden = false
                self.beforeArrowView.isHidden = true
            })
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSwitchStatus(_ sender: Any) {
        self.pageType = self.pageType == .emailStatus ? .phoneStatus : .emailStatus
    }
    
    @IBAction func btnSelectCodeNumber(_ sender: Any) {
        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "SelectCountryViewController") as! SelectCountryViewController
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overFullScreen
        vc.selectedCountry = self.country
        vc.callback = { country in
            if let country = country {
                self.country = country
                self.icCountry.image = country.flag
                self.txtPhoneCode.text = country.code
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnForgotPassword(_ sender: Any) {
        
        guard self.validation() else {
            return
        }
        
        self.forgotPassword()
        
    }
    
}

extension ForgotPasswordViewController {
    
    func setupView() {
        arrowIcon.tintColor = "#219CD8".color_
        self.setupPage()
    }
    
    func localized() {
        
    }
    
    func setupData() {
        
    }
    
    func fetchData() {
        
    }

}

extension ForgotPasswordViewController {

    func setupPage() {
        
        self.txtPhoneNumber.delegate = self
        
        switch pageType {
            
        case .emailStatus:
            self.lblTitle.text = "Enter your Email.".localize_
            self.stPhone.isHidden = true
            self.vwEmail.isHidden = false
            self.btnSwitchStatus.setTitle("switch to phone number".localize_.uppercased(), for: .normal)
            break
        case .phoneStatus:
            self.lblTitle.text = "Enter your Mobile.".localize_
            self.stPhone.isHidden = false
            self.vwEmail.isHidden = true
            self.btnSwitchStatus.setTitle("switch to email".localize_.uppercased(), for: .normal)
            break
        }
        
    }
    
    func validation() -> Bool {
        
        switch pageType {
        case .emailStatus:
            guard let email = self.txtEmail.text, !email.isEmpty else {
                self.showSnackbarMessage(message: "Email field is required".localize_, isError: true)
                return false
            }
            
            guard email.isValidEmail() else {
                self.showSnackbarMessage(message: "Email is incorrect".localize_, isError: true)
                return false
            }
            break
        case .phoneStatus:
            guard let phoneNumber = self.txtPhoneNumber.text, !phoneNumber.isEmpty else {
                self.showSnackbarMessage(message: "The phone number field is required".localize_, isError: true)
                return false
            }
            
            guard phoneNumber.count == 9 else {
                self.showSnackbarMessage(message: "The phone number must be 9 digits".localize_, isError: true)
                return false
            }
            
//            guard phoneNumber.starts(with: "05") else {
//                self.showSnackbarMessage(message: "The phone number must start with 05".localize_, isError: true)
//                return false
//            }
            
            break
        }
        
        return true
    }
    
    func forgotPassword() {
        
        let request = BaseRequest()
        request.url = GlobalConstants.RESET_PASSWORD
        request.method = .post
        
        switch pageType {
        case .emailStatus:
            request.parameters = [
                "email": self.txtEmail.text ?? "",
            ]
            break
        case .phoneStatus:
            request.parameters = [
                "phone_code": (self.txtPhoneCode.text ?? "").replacingOccurrences(of: "+", with: ""),
                "mobile": (self.txtPhoneNumber.text ?? ""),
            ]
            break
        }
        
        RequestBuilder.requestWithSuccessfullRespnose(for: StatusModel.self, request: request) { (result) in
            
            self.showSnackbarMessage(message: result.data?.message ?? "", isError: !(result.status ?? false))
            
            if result.status ?? false {
//                self.navigationController?.popViewController(animated: true)
                let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "UpdatePasswordViewController") as! UpdatePasswordViewController
                vc.isFromUpdatePass = false
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        
    }
    
}

extension ForgotPasswordViewController: UITextFieldDelegate {
    
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
