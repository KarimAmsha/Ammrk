/*********************		Yousef El-Madhoun		*********************/
//
//  SiginUpServiceProviderViewController.swift
//  amrk
//
//  Created by yousef on 13/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit
import iOSDropDown

class SiginUpServiceProviderViewController: UIViewController {
    
    @IBOutlet weak var arrowIcon: UIImageView!
    @IBOutlet weak var beforeBackView: UIView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var txtServiceType: DropDown!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var icCountry: UIImageView!
    
    @IBOutlet weak var txtPhoneCode: UITextField!
    
    @IBOutlet weak var txtPhoneNumber: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var txtCommercialRegister: UITextField!
    
    @IBOutlet weak var txtIBANCode: UITextField!
    
    var country: PhoneNumberCodeModel?
    
    var imgCommercialRegister: UIImage?
    
    var imgIBAN: UIImage?
    
    var serviceId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        localized()
        setupData()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    }
    
    @IBAction func btnSelectCountry(_ sender: Any) {
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
    
    @IBAction func btnCommercialRegister(_ sender: Any) {
        let picker = ImagePicker.shared.picker
        
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                self.imgCommercialRegister = photo.image
                self.txtCommercialRegister.text = "photo added".localize_
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func btnIBANCode(_ sender: Any) {
        let picker = ImagePicker.shared.picker
        
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                self.imgIBAN = photo.image
                self.txtIBANCode.text = "photo added".localize_
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        
        guard self.validation() else {
            return
        }
        
        self.signUp()
        
    }
    
}

extension SiginUpServiceProviderViewController {
    
    func setupView() {
        arrowIcon.tintColor = "#219CD8".color_
        
        self.txtServiceType.placeholder = "Service type".localize_
        self.txtServiceType.optionIds = [2, 4, 5, 3]
        self.txtServiceType.optionArray = ["Restaurant".localize_, "Training Hall".localize_, "Wedding hall".localize_, "Hala Shop".localize_]
        
        self.txtServiceType.didSelect { (value, index, id) in
            self.serviceId = id
        }
        
    }
    
    func localized() {
        
    }
    
    func setupData() {
        
    }
    
    func fetchData() {
        
    }

}

extension SiginUpServiceProviderViewController {

    func validation() -> Bool {
        
        guard let name = self.txtName.text, !name.isEmpty else {
            self.showSnackbarMessage(message: "Name field is required".localize_, isError: true)
            return false
        }
        
        guard let serviceType = self.txtServiceType.text, !serviceType.isEmpty else {
            self.showSnackbarMessage(message: "Service type field is required".localize_, isError: true)
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
        
        guard phoneNumber.count == 9 else {
            self.showSnackbarMessage(message: "The phone number must be 9 digits".localize_, isError: true)
            return false
        }
        
        guard let password = self.txtPassword.text, !password.isEmpty else {
            self.showSnackbarMessage(message: "Password field is required".localize_, isError: true)
            return false
        }
        
        guard let commercialRegister = self.txtCommercialRegister.text, !commercialRegister.isEmpty else {
            self.showSnackbarMessage(message: "Commercial register field is required".localize_, isError: true)
            return false
        }

        guard let ibanCode = self.txtIBANCode.text, !ibanCode.isEmpty else {
            self.showSnackbarMessage(message: "IBAN code field is required".localize_, isError: true)
            return false
        }
        
        guard email.isValidEmail() else {
            self.showSnackbarMessage(message: "Email is incorrect".localize_, isError: true)
            return false
        }
        
//        guard phoneNumber.count == 10 else {
//            self.showSnackbarMessage(message: "The phone number must be 10 digits".localize_, isError: true)
//            return false
//        }
        
        return true
    }
    
    func signUp() {
        
        let request = BaseRequest()
        request.url = GlobalConstants.REGISTER_PROVIDER
        request.method = .post
        request.parameters = [
            "name": self.txtName.text ?? "",
            "email": self.txtEmail.text ?? "",
            "phone_code": (self.txtPhoneCode.text ?? "").replacingOccurrences(of: "+", with: ""),
            "mobile": self.txtPhoneNumber.text ?? "",
            "password": self.txtPassword.text ?? "",
            "type": self.serviceId ?? 0,
        ]
        
        if let commercialRegister = self.imgCommercialRegister, let iban = self.imgIBAN {
            if let img = commercialRegister.jpegData(compressionQuality: 0.5) {
                let file = BaseFile(data: img, name: "trade_photo", type: .image)
                request.files.append(file)
            }

            if let img = iban.jpegData(compressionQuality: 0.5) {
                let file = BaseFile(data: img, name: "iban_photo", type: .image)
                request.files.append(file)
            }
        }
        
        RequestBuilder.requestWithSuccessfullRespnose(for: ReviewOrderModel.self, request: request) { (result) in
            
            if result.status ?? false {
                self.showSnackbarMessage(message: result.data?.message ?? "", isError: false)
                self.dismiss(animated: true, completion: nil)
                
            }
        }
    }
    
}
