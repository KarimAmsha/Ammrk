/*********************		Yousef El-Madhoun		*********************/
//
//  SignUpViewController.swift
//  amrk
//
//  Created by yousef on 14/08/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var arrowIcon: UIImageView!
    @IBOutlet weak var beforeBackView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var icCountry: UIImageView!
    
    @IBOutlet weak var txtPhoneCode: UITextField!
    
    @IBOutlet weak var txtPhoneNumber: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    var country: PhoneNumberCodeModel?
    
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIView.animate(withDuration: 0.5, animations: {
                self.topView.isHidden = true
                self.arrowIcon.isHidden = false
                self.beforeBackView.isHidden = true
            })
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
//        self.navigationController?.popViewController(animated: true)
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
    
    @IBAction func btnSignUp(_ sender: Any) {
        
        guard validation() else {
            return
        }
        
        self.signUp()
        
    }
    
}

extension SignUpViewController {
    
    func setupView() {
        self.txtPhoneNumber.delegate = self
        arrowIcon.tintColor = "#219CD8".color_

    }
    
    func localized() {
        
    }
    
    func setupData() {
        
    }
    
    func fetchData() {
        
    }

}

extension SignUpViewController {
    
    func validation() -> Bool {
        
        guard let name = self.txtName.text, !name.isEmpty else {
            self.showSnackbarMessage(message: "Name field is required".localize_, isError: true)
            return false
        }
        
        guard let email = self.txtEmail.text, !email.isEmpty else {
            self.showSnackbarMessage(message: "Email field is required".localize_, isError: true)
            return false
        }
        
        guard let phoneNumber = self.txtPhoneNumber.text, !phoneNumber.isEmpty else {
            self.showSnackbarMessage(message: "The phone number field is required".localize_, isError: true)
            return false
        }
        
        guard let password = self.txtPassword.text, !password.isEmpty else {
            self.showSnackbarMessage(message: "Password field is required".localize_, isError: true)
            return false
        }
        
        guard email.isValidEmail() else {
            self.showSnackbarMessage(message: "Email is incorrect".localize_, isError: true)
            return false
        }
        
        guard phoneNumber.count == 9 else {
            self.showSnackbarMessage(message: "The phone number must be 9 digits".localize_, isError: true)
            return false
        }
        
//        guard phoneNumber.starts(with: "05") else {
//            self.showSnackbarMessage(message: "The phone number must start with 05".localize_, isError: true)
//            return false
//        }
        
        return true
    }
    
    func signUp() {
        
        let request = BaseRequest()
        request.url = GlobalConstants.REGISTER
        request.method = .post
        request.parameters = [
            "name": self.txtName.text ?? "",
            "email": self.txtEmail.text ?? "",
            "phone_code": (self.txtPhoneCode.text ?? "").replacingOccurrences(of: "+", with: ""),
            "mobile": self.txtPhoneNumber.text ?? "",
            "password": self.txtPassword.text ?? "",
        ]
        
        RequestBuilder.requestWithSuccessfullRespnose(for: AdsModel.self, request: request) { (result) in
            
            if result.status ?? false {
                switch result.data?.message {
                case .messageElementArray(let messages):
                    self.showSnackbarMessage(message: messages.joined(separator: ", "), isError: false)
                    break
                    
                case .string(let message):
                    self.showSnackbarMessage(message: message , isError: false)
                    break
                case .none:
                    break
                }
                
                let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
                vc.phoneCode = self.txtPhoneCode.text
                vc.phoneNumber = self.txtPhoneNumber.text
                vc.modalTransitionStyle = .coverVertical
                vc.modalPresentationStyle = .overFullScreen
                vc.callback = {
                    self.dismiss(animated: true, completion: nil)
                }
                self.present(vc, animated: true, completion: nil)
                
            } else {
                switch result.data?.message {
                case .messageElementArray(let messages):
                    self.showSnackbarMessage(message: messages.joined(separator: ", "), isError: false)
                    break
                    
                case .string(let message):
                    self.showSnackbarMessage(message: message , isError: false)
                    break
                case .none:
                    break
                }
                
//                self.showSnackbarMessage(message: result.data?.message?.joined(separator: ", ") ?? "", isError: true)

            }
        }
        
    }
    
}

extension SignUpViewController: UITextFieldDelegate {
    
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
