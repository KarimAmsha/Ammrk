/*********************		Yousef El-Madhoun		*********************/
//
//  UpdateProfileViewController.swift
//  amrk
//
//  Created by yousef on 26/08/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit

class UpdateProfileViewController: UIViewController {
    
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var icCountry: UIImageView!
    
    @IBOutlet weak var txtPhoneCode: UITextField!
    
    @IBOutlet weak var txtPhoneNumber: UITextField!
    
    var newImage: UIImage?

    var country: PhoneNumberCodeModel?
    
    var callback: (() -> Void)?
    
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
    
    @IBAction func btnUploadImage(_ sender: Any) {
        self.pickerImage()
    }
    
    @IBAction func btnUpdateProfile(_ sender: Any) {
        
        guard validation() else {
            return
        }
        
        self.updateProfile()
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
    
    @IBAction func btnDeleteAccount(_ sender: Any) {
        
        self.showAlertPopUp(title: "Delete Account".localize_, message: "Are you sure delete account?".localize_, buttonTitle1: "Delete".localize_, buttonTitle2: "Close".localize_) {
            
            let request = BaseRequest()
            request.url = GlobalConstants.REMOVE_USER
            request.method = .post
            
            RequestBuilder.requestWithSuccessfullRespnose(for: DeleteAccountModel.self, request: request) { (result) in
                
                if result.status ?? false {
                     UserProfile.shared.currentUser = nil
                    let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
                    vc.isFromOnBoarding = true
                    vc.modalTransitionStyle = .coverVertical
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: true, completion: nil)
                }
                
            }
            
        } action2: {
            
        }
        
    }
    
}

extension UpdateProfileViewController {
    
    func setupView() {
        self.txtPhoneNumber.delegate = self
    }
    
    func localized() {
        
    }
    
    func setupData() {
        if let currentUser = UserProfile.shared.currentUser {
            self.imgUser.imageURL(url: currentUser.image ?? "")
            self.txtName.text = currentUser.name
            self.txtEmail.text = currentUser.email
            switch currentUser.phoneCode {
            case .integer(let code):
                self.txtPhoneCode.text = "\(code)"
            case .string(let strCode):
                self.txtPhoneCode.text = "\(strCode)"
            case .none:
                break
            }
            
            switch currentUser.mobile {
            case .integer(let code):
                self.txtPhoneNumber.text = "\(code)"
            case .string(let strCode):
                self.txtPhoneNumber.text = "\(strCode)"
            case .none:
                break
            }
            
        }
    }
    
    func fetchData() {
        
    }

}

extension UpdateProfileViewController {
    
    func pickerImage() {
        let picker = ImagePicker.shared.picker
        
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                self.imgUser.image = photo.image
                self.newImage = photo.image
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    
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
    
    func updateProfile() {
        
        let request = BaseRequest()
        request.url = GlobalConstants.UPDATE_PROFILE
        request.method = .post
        request.parameters = [
            "name": self.txtName.text ?? "",
            "email": self.txtEmail.text ?? "",
            "phone_code": self.txtPhoneCode.text ?? "",
            "mobile": self.txtPhoneNumber.text ?? "",
        ]
        
        if let image = self.newImage {
            if let img = image.jpegData(compressionQuality: 0.5) {
                let file = BaseFile(data: img, name: "image", type: .image)
                request.files.append(file)
            }
        }
        
        RequestBuilder.requestWithSuccessfullRespnose(for: UpdateProfileModel.self, request: request) { (result) in
            
            if result.status ?? false {
                self.updateCurrentUser()
            } else {
                if let _ = result.data?.email {
                    self.showSnackbarMessage(message: result.data?.email?.joined(separator: ", ") ?? "", isError: true)
                }
                
                if let _ = result.data?.mobile {
                    self.showSnackbarMessage(message: result.data?.mobile?.joined(separator: ", ") ?? "", isError: true)
                }
            }
            
        }
        
    }
    
    func updateCurrentUser() {
        
        let request = BaseRequest()
        request.url = GlobalConstants.PROFILE
        request.method = .get
        
        RequestBuilder.requestWithSuccessfullRespnose(for: ProfileModel.self, request: request) { (result) in
            
            if result.status ?? false {
                
                self.showSnackbarMessage(message: "Profile modified successfully".localize_, isError: false)
                UserProfile.shared.currentUser = result.data?.user
                self.callback?()
                self.navigationController?.popViewController(animated: true)
                
            } else {
                self.showSnackbarMessage(message: "Something happened! Please try again later".localize_, isError: true)
            }
            
        }
        
    }
    
}

extension UpdateProfileViewController: UITextFieldDelegate {
    
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
