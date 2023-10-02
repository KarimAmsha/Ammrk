/*********************		Yousef El-Madhoun		*********************/
//
//  UpdatePasswordViewController.swift
//  amrk
//
//  Created by yousef on 01/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit

class UpdatePasswordViewController: UIViewController {
    
    @IBOutlet weak var txtCurrentPassword: UITextField!
    
    @IBOutlet weak var txtNewPassword: UITextField!
    
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    
    var isFromUpdatePass = true
    
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
        if isFromUpdatePass {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func btnUpdatePassword(_ sender: Any) {
        
        guard validation() else {
            return
        }
        
        if isFromUpdatePass {
            self.sumbitData()
        } else {
            self.resetPass()
        }
        
        
    }
    
}

extension UpdatePasswordViewController {
    
    func setupView() {
        if !isFromUpdatePass {
            txtCurrentPassword.placeholder = "Code".localize_
        }
    }
    
    func localized() {
        
    }
    
    func setupData() {
        
    }
    
    func fetchData() {
        
    }

}

extension UpdatePasswordViewController {
    
    func validation() -> Bool {
        
        if isFromUpdatePass {
            guard self.txtCurrentPassword.isValidValue else {
                self.showSnackbarMessage(message: "Current password field is required".localize_, isError: true)
                return false
            }
        } else {
            guard self.txtCurrentPassword.isValidValue else {
                self.showSnackbarMessage(message: "Code field is required".localize_, isError: true)
                return false
            }
        }
        
        guard self.txtNewPassword.isValidValue else {
            self.showSnackbarMessage(message: "New password field is required".localize_, isError: true)
            return false
        }
        
        guard self.txtConfirmPassword.isValidValue else {
            self.showSnackbarMessage(message: "Confirm password field is required".localize_, isError: true)
            return false
        }
        
        guard self.txtNewPassword.text == self.txtConfirmPassword.text else {
            self.showSnackbarMessage(message: "Passwords do not match".localize_, isError: true)
            return false
        }
        
        return true
    }
    
    func sumbitData() {
        
        let request = BaseRequest()
        request.url = GlobalConstants.UPDATE_PASSWORD
        request.method = .post
        
        request.parameters = [
            "oldpassword": self.txtCurrentPassword.text ?? "",
            "password": self.txtNewPassword.text ?? "",
            "password_confirmation": self.txtConfirmPassword.text ?? "",
        ]
        
        RequestBuilder.requestWithSuccessfullRespnose(for: UpdatePasswordModel.self, request: request, showErrorMessage: false) { (result) in
            
            if result.status ?? false {
                self.showSnackbarMessage(message: "Password has been updated".localize_, isError: false)
                self.navigationController?.popViewController(animated: true)
            } else {
                self.showSnackbarMessage(message: result.data?.message?.joined(separator: ", ") ?? "Something happened! Please try again later".localize_, isError: true)
            }
            
        }
        
    }
    
    func resetPass() {
        
        let request = BaseRequest()
        request.url = GlobalConstants.RESET_UPDATE_PASSWORD
        request.method = .post
        
        request.parameters = [
            "code": self.txtCurrentPassword.text ?? "",
            "password": self.txtNewPassword.text ?? "",
            "password_confirmation": self.txtConfirmPassword.text ?? "",
        ]
        
        RequestBuilder.requestWithSuccessfullRespnose(for: StatusModel.self, request: request, showErrorMessage: false) { (result) in
            
            if result.status ?? false {
                self.showSnackbarMessage(message: result.data?.message ?? "", isError: false)
                self.dismiss(animated: true, completion: nil)
            } else {
//                self.showSnackbarMessage(message: result.data?.message?.joined(separator: ", ") ?? "Something happened! Please try again later".localize_, isError: true)
                self.showSnackbarMessage(message: result.data?.message ?? "", isError: true)

            }
            
        }
        
    }
    
}
