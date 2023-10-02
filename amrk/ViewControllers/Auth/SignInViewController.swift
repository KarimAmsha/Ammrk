/*********************		Yousef El-Madhoun		*********************/
//
//  SignInViewController.swift
//  amrk
//
//  Created by yousef on 24/08/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseMessaging

class SignInViewController: UIViewController {
    
    @IBOutlet weak var serviceProvierBtn: UIButton!
    @IBOutlet weak var beforeBackView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var arrowIcon: UIImageView!
    @IBOutlet weak var topViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var icCountry: UIImageView!
    @IBOutlet weak var serviceProviderLbl: UILabel!
    
    @IBOutlet weak var stPhoneNumber: UIStackView!
    
    @IBOutlet weak var txtCodeNumber: UITextField!
    
    @IBOutlet weak var txtPhoneNumber: UITextField!
    
    @IBOutlet weak var stEmail: UIStackView!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var btnSwitchStatus: UIButton!
    
    var country: PhoneNumberCodeModel?
    var isServiceProvider = false
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
//        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func serviceProviderAction(_ sender: Any) {
        if isServiceProvider {
            isServiceProvider = !isServiceProvider
            self.serviceProviderLbl.isHidden = true
            self.serviceProvierBtn.setTitle("Sign in as service provider".localize_, for: .normal)
        } else {
            isServiceProvider = !isServiceProvider
            self.serviceProviderLbl.isHidden = false
            self.serviceProvierBtn.setTitle("Sign in as user".localize_, for: .normal)
        }
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
                self.txtCodeNumber.text = country.code
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnSwitchStatus(_ sender: Any) {
        self.pageType = self.pageType == .emailStatus ? .phoneStatus : .emailStatus
    }
    
    @IBAction func btnForgotPassword(_ sender: Any) {
        let nav = UINavigationController()
        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "ForgotPasswordViewController")
        nav.viewControllers = [vc]
        nav.modalTransitionStyle = .coverVertical
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func btnSignIn(_ sender: Any) {
        
        guard validation() else {
            return
        }
        
        Messaging.messaging().token { token, error in
           
            if let error = error {
              print("Error fetching remote instance ID: \(error)")
            } else if let token = token {
                UserProfile.shared.fcmToken = token
            }
            
        }
        
        self.signIn()
    
    }
    
}

extension SignInViewController {
    
    func setupView() {
        topView.backgroundColor = .clear
        serviceProviderLbl.text = "Sign in service provider".localize_
        self.serviceProvierBtn.setTitle("Sign in as service provider".localize_, for: .normal)
        serviceProviderLbl.isHidden = true
        arrowIcon.image = UIImage(systemName: "arrow.left")
        arrowIcon.tintColor = "#219CD8".color_
        arrowIcon.isHidden = true
        txtCodeNumber.text = "+966"
        topViewConstraint.constant = 100
        self.view.layoutIfNeeded()
        
        self.setupPage()
    }
    
    func localized() {
        
    }
    
    func setupData() {
        
    }
    
    func fetchData() {

    }

}

extension SignInViewController {
    
    func setupPage() {
        
        self.txtPhoneNumber.delegate = self
        
        switch pageType {
            
        case .emailStatus:
            self.lblTitle.text = "Enter your Email & Password.".localize_
            self.stPhoneNumber.isHidden = true
            self.stEmail.isHidden = false
            self.btnSwitchStatus.setTitle("switch to phone number".localize_.uppercased(), for: .normal)
            break
        case .phoneStatus:
            self.lblTitle.text = "Enter your Mobile & Password.".localize_
            self.stPhoneNumber.isHidden = false
            self.stEmail.isHidden = true
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
            
            guard let password = self.txtPassword.text, !password.isEmpty else {
                self.showSnackbarMessage(message: "Password field is required".localize_, isError: true)
                return false
            }
            
            guard email.isValidEmail() else {
                self.showSnackbarMessage(message: "Email is incorrect".localize_, isError: true)
                return false
            }
            
        case .phoneStatus:
            
            guard let phoneNumber = self.txtPhoneNumber.text, !phoneNumber.isEmpty else {
                self.showSnackbarMessage(message: "The phone number field is required".localize_, isError: true)
                return false
            }
            
            guard let password = self.txtPassword.text, !password.isEmpty else {
                self.showSnackbarMessage(message: "Password field is required".localize_, isError: true)
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
            
        }
        
        return true
    }
    
    func signIn() {
        
        let request = BaseRequest()
        request.url = "\(GlobalConstants.APIV)\(GlobalConstants.LOGIN)?lang=\(UserProfile.shared.language?.code ?? "en")"
        request.method = .post
        
        switch pageType {
        case .emailStatus:
            request.parameters = [
                "email": self.txtEmail.text ?? "",
                "password": self.txtPassword.text ?? "",
            ]
            break
        case .phoneStatus:
            request.parameters = [
                "phone_code": (self.txtCodeNumber.text ?? "").replacingOccurrences(of: "+", with: ""),
                "mobile": (self.txtPhoneNumber.text ?? ""),
                "password": self.txtPassword.text ?? "",
            ]
            break
        }
        
//        RequestBuilder.requestWithSuccessfullRespnose(for: LoginModel.self, request: request) { (result) in
//
//            print(result.data)
//            if result.status ?? false {
//
//                if result.data?.type == 2 {
//                    self.showSnackbarMessage(message: "You do not have permission to use this app".localize_, isError: true)
//                    return
//                }
//
//                UserProfile.shared.currentUser = result.data
//
//                RequestBuilder.shared.updateHeader()
//
//                let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "MainNavigationViewController")
//                vc.modalTransitionStyle = .coverVertical
//                vc.modalPresentationStyle = .overFullScreen
//                self.present(vc, animated: true, completion: nil)
//
//            } else {
//                if result.data?.errors?.contains("email") ?? false {
//                    self.showSnackbarMessage(message: result.data?.message?.joined(separator: ", ") ?? "", isError: true)
//
//                } else if result.data?.errors?.contains("mobileVerified") ?? false {
//                    let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
//                    vc.phoneCode = self.txtCodeNumber.text
//                    vc.phoneNumber = self.txtPhoneNumber.text
//                    vc.modalTransitionStyle = .coverVertical
//                    vc.modalPresentationStyle = .overFullScreen
//                    self.present(vc, animated: true, completion: nil)
//
//                } else {
//                    self.showSnackbarMessage(message: result.data?.message?.joined(separator: ", ") ?? "", isError: true)
//                }
//            }
//
//        }
        
        RequestBuilder.showLoader(isShowLoader: true)
        
        AF.request(request.url, method: request.method, parameters: request.parameters, headers: RequestBuilder.headers, interceptor: nil).responseData { (response) in
        
            RequestBuilder.showLoader(isShowLoader: false)
            
            switch response.result {
                case .success(let data):
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                        
                        let json2 = json as! [String : Any]
                        
                        let data = json2["data"] as! [String : Any]
                        
                        if let status = json2["status"] as? Bool, status {
                            
                            do {
                                let jsonData = try JSONSerialization.data(withJSONObject: json)
                                let object = try JSONDecoder().decode(LoginModel.self, from: jsonData)
                                
                                
                                if object.status ?? false {

                                    if object.data?.type == 2 {
                                        self.showSnackbarMessage(message: "You do not have permission to use this app".localize_, isError: true)
                                        return
                                    }

                                    UserProfile.shared.currentUser = object.data

                                    RequestBuilder.shared.updateHeader()

                                    let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "MainNavigationViewController")
                                    vc.modalTransitionStyle = .coverVertical
                                    vc.modalPresentationStyle = .overFullScreen
                                    self.present(vc, animated: true, completion: nil)

                                } else {
                                    if object.data?.errors?.contains("email") ?? false {
                                        self.showSnackbarMessage(message: object.data?.message?.joined(separator: ", ") ?? "", isError: true)

                                    } else if object.data?.errors?.contains("mobileVerified") ?? false {
                                        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
                                        vc.phoneCode = self.txtCodeNumber.text
                                        vc.phoneNumber = self.txtPhoneNumber.text
                                        vc.modalTransitionStyle = .coverVertical
                                        vc.modalPresentationStyle = .overFullScreen
                                        self.present(vc, animated: true, completion: nil)

                                    } else {
                                        self.showSnackbarMessage(message: object.data?.message?.joined(separator: ", ") ?? "", isError: true)
                                    }
                                }

                                
                                
                            } catch {
                                print(error)
                            }
                            
                        } else {
                            do {
                                
                                let jsonData = try JSONSerialization.data(withJSONObject: json)
                                let object = try JSONDecoder().decode(SignUpErrorModel.self, from: jsonData)
                                
                                self.showSnackbarMessage(message: object.data?.message?.joined(separator: ", ") ?? "", isError: true)
                            } catch {
                                self.showSnackbarMessage(message: data["message"] as! String, isError: true)
                                print(error)
                            }
                    
                        }
                        
                    } catch(let error) {
                        debugPrint(error.localizedDescription)
//                            failure(error)
                    }
                    break
                case .failure(let error):
                    debugPrint(error.localizedDescription)
//                        failure(error)
                    break
            }
            
            
        }
        
    }
    
}

extension SignInViewController: UITextFieldDelegate {
    
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
