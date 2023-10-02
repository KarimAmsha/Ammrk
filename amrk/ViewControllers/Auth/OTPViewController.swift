/*********************		Yousef El-Madhoun		*********************/
//
//  OTPViewController.swift
//  amrk
//
//  Created by yousef on 24/08/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit

class OTPViewController: UIViewController {
    
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var arrowIcon: UIImageView!
    @IBOutlet weak var beforeBackView: UIView!
    @IBOutlet weak var vwTxtOne: UIView!
    
    @IBOutlet weak var txtOne: UITextField!
    
    @IBOutlet weak var otpTF: UITextField!
    @IBOutlet weak var vwTxtTwo: UIView!
    
    @IBOutlet weak var txtTwo: UITextField!
    
    @IBOutlet weak var vwTxtThree: UIView!
    
    @IBOutlet weak var txtThree: UITextField!
    
    @IBOutlet weak var vwTxtFour: UIView!
    
    @IBOutlet weak var txtFour: UITextField!
    
    var phoneCode: String?
    
    var phoneNumber: String?
    
    var callback:(() -> Void)?
    
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
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSignIn(_ sender: Any) {
        self.verifyMobile()
    }
    
}

extension OTPViewController {
    
    func setupView() {
        self.txtOne.delegate = self
        self.txtTwo.delegate = self
        self.txtThree.delegate = self
        self.txtFour.delegate = self
        otpTF.delegate = self
        otpTF.textContentType = .oneTimeCode
        
        arrowIcon.tintColor = "#219CD8".color_
        self.otpTF.becomeFirstResponder()
        
        phoneLbl.text = "OTP has been sent to ".localize_ + ( phoneNumber  ?? "")
    }
    
    func localized() {
        
    }
    
    func setupData() {
        
    }
    
    func fetchData() {
        
    }

}

extension OTPViewController {
    
    func setUpTextField() {
        
        if self.txtOne.text?.count == 1 {
            self.vwTxtOne.backgroundColor = UIColor.hexColor(hex: "#F3F3F3")
        }
        
        if self.txtTwo.text?.count == 1 {
            self.vwTxtTwo.backgroundColor = UIColor.hexColor(hex: "#F3F3F3")
        }
        
        if self.txtThree.text?.count == 1 {
            self.vwTxtThree.backgroundColor = UIColor.hexColor(hex: "#F3F3F3")
        }
        
        if self.txtFour.text?.count == 1 {
            self.vwTxtFour.backgroundColor = UIColor.hexColor(hex: "#F3F3F3")
        }
        
    }
    
    func verifyMobile() {
        
        let request = BaseRequest()
        request.url = GlobalConstants.VERIFY_MOBILE
        request.method = .post
//        let code1Txt = (self.txtOne.text ?? "") + (self.txtTwo.text ?? "")
//        let code2Txt = (self.txtThree.text ?? "") + (self.txtFour.text ?? "")
        request.parameters = [
            "code": otpTF.text ?? "",
            "phone_code": (self.phoneCode ?? "").replacingOccurrences(of: "+", with: ""),
            "mobile": self.phoneNumber ?? "",
        ]
        
        RequestBuilder.requestWithSuccessfullRespnose(for: RegisterModel.self, request: request) { (result) in
            
            if result.status ?? false {
                
                UserProfile.shared.currentUser = result.data?.user
                
                RequestBuilder.shared.updateHeader()
                
                let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "MainNavigationViewController")
                vc.modalTransitionStyle = .coverVertical
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true, completion: nil)
                
//                switch result.data?.message {
//                case .messageElementArray(let messages):
//                    self.showSnackbarMessage(message: messages.map({$0.message ?? ""}).joined(separator: ", "), isError: false)
//                    break
//
//                case .string(let message):
//                    self.showSnackbarMessage(message: message , isError: false)
//                    break
//                case .none:
//                    break
//                }
//
//                self.dismiss(animated: true) {
//                    self.callback?()
//                }
                
//                self.showSnackbarMessage(message: result.data?.message?.joined(separator: ", ") ?? "", isError: false)
//                let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
//                vc.modalTransitionStyle = .coverVertical
//                vc.modalPresentationStyle = .overFullScreen
//                self.present(vc, animated: true, completion: nil)
                
            } else {
//                switch result.data?.message {
//                case .messageElementArray(let messages):
//                    self.showSnackbarMessage(message: messages.map({$0.message ?? ""}).joined(separator: ", "), isError: false)
//                    break
//
//                case .string(let message):
//                    self.showSnackbarMessage(message: message , isError: false)
//                    break
//                case .none:
//                    break
//                }
                
                self.showSnackbarMessage(message: result.data?.message ?? "", isError: true)
            }
        }
        
    }
    
}

extension OTPViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.txtOne {
            self.vwTxtOne.borderColor = "#219CD8".color_
            self.vwTxtOne.backgroundColor = .white
        } else if textField == self.txtTwo {
            self.vwTxtTwo.borderColor = "#219CD8".color_
            self.vwTxtTwo.backgroundColor = .white
        } else if textField == self.txtThree {
            self.vwTxtThree.borderColor = "#219CD8".color_
            self.vwTxtThree.backgroundColor = .white
        } else if textField == self.txtFour{
            self.vwTxtFour.borderColor = "#219CD8".color_
            self.vwTxtFour.backgroundColor = .white
        } else {
            self.vwTxtOne.borderColor = "#DFEEFF".color_
            self.vwTxtTwo.borderColor = "#DFEEFF".color_
            self.vwTxtThree.borderColor = "#DFEEFF".color_
            self.vwTxtFour.borderColor = "#DFEEFF".color_
        }
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        guard let textFieldText = textField.text,
//            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
//                return false
//        }
//        let substringToReplace = textFieldText[rangeOfTextToReplace]
//        let count = textFieldText.count - substringToReplace.count + string.count
//
//        if count == 1 {
//
//            if textField == self.txtOne {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
//                    self.txtTwo.becomeFirstResponder()
//                }
//            } else if textField == self.txtTwo {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
//                    self.txtThree.becomeFirstResponder()
//                }
//            } else if textField == self.txtThree {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
//                    self.txtFour.becomeFirstResponder()
//                }
//            } else if textField == self.txtFour {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
//                    self.view.endEditing(true)
//                }
//            }
//
//        }
//
//        return count <= 1
//
//    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.setUpTextField()
        self.vwTxtOne.borderColor = "#DFEEFF".color_
        self.vwTxtTwo.borderColor = "#DFEEFF".color_
        self.vwTxtThree.borderColor = "#DFEEFF".color_
        self.vwTxtFour.borderColor = "#DFEEFF".color_
    }
    
}
