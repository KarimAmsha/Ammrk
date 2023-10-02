/*********************		Yousef El-Madhoun		*********************/
//
//  ProfileViewController.swift
//  rukn2
//
//  Created by yousef on 14/06/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit
import MOLH
import StoreKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var rateLbl: UILabel!
    @IBOutlet weak var rateStack: UIStackView!
    @IBOutlet weak var providerLbl: UILabel!
    @IBOutlet weak var vwEditProfile: UIView!
    
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblEmail: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var itemsList: [Menu] = []
    
    
    
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
    
    @IBAction func btnEditProfile(_ sender: Any) {
       let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "UpdateProfileViewController") as! UpdateProfileViewController
        vc.callback = {
            self.getUserData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ProfileViewController {
    
    func setupView() {

        self.getUserData()
        self.getUser()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "MenuItemTableViewCell", bundle: nil), forCellReuseIdentifier: "MenuItemTableViewCell")
    }
    
    func getUser() {
        let request = BaseRequest()
        request.url = GlobalConstants.PROFILE
        request.method = .get
        
        RequestBuilder.requestWithSuccessfullRespnose(for: ProfileModel.self, request: request) { (result) in
            
            self.rateLbl.text = "\(result.data?.user?.userInfo?.review?.rounded(toPlaces: 2) ?? 0)"
            UserProfile.shared.currentUser = result.data?.user
            self.tableView.reloadData()
            
        }
    }
    
    func localized() {
        
    }
    
    func setupData() {
        if let user = UserProfile.shared.currentUser {
            if user.type == 2 {
                self.rateStack.isHidden = false
                self.providerLbl.isHidden = false
                self.getUser()
                self.itemsList = [Menu.editProfile, Menu.editPassword, Menu.shareTheApp, Menu.changeLanguage, Menu.logout]
            } else {
                self.rateStack.isHidden = true
                self.providerLbl.isHidden = true
                self.itemsList = [ Menu.favorite, Menu.editProfile,Menu.email, Menu.editPassword, Menu.myAddresses, Menu.rateApp, Menu.shareTheApp, Menu.changeLanguage, Menu.termsOfService, Menu.privacyPolicy, Menu.aboutApp, Menu.contactUs, Menu.logout]
                
                if UserProfile.shared.currentUser?.emailVerifiedAt != nil {
                    self.itemsList.remove(at: 2)
                }
                
            }
        } else {
            self.rateStack.isHidden = true
            self.providerLbl.isHidden = true
            self.itemsList = [Menu.login, Menu.rateApp, Menu.shareTheApp, Menu.changeLanguage, Menu.termsOfService, Menu.privacyPolicy, Menu.aboutApp]
        }
    }
    
    func fetchData() {
        
    }

}

extension ProfileViewController {
    
    func getUserData() {
        if let currentUser = UserProfile.shared.currentUser {
            self.imgUser.imageURL(url: currentUser.image ?? "")
            self.lblName.text = currentUser.name
            self.lblEmail.text = currentUser.email
        } else {
            self.vwEditProfile.isHidden = true
            self.lblName.text = "visitor".localize_
            self.lblEmail.text = "not logged in".localize_
        }
    }
    
    func changeLanguage() {
        
        self.showAlertPopUp(title: "Change Language", message: "Are you sure to change the language?", buttonTitle1: "Change Language", action1: {
            let language: Language = UserProfile.shared.language == .arabic ? .english : .arabic
            
            MOLH.setLanguageTo(language.code)
            UserProfile.shared.language = language
            RequestBuilder.shared.updateHeader()
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainNavigationViewController")
            UIView.appearance().semanticContentAttribute = language == .english ? .forceLeftToRight : .forceRightToLeft
            AppDelegate.shared.window?.rootViewController = vc
        }) {
            
        }
        
    }
    
    func resendEmailVerification() {
        self.showAlertPopUp(title: "Resend code".localize_, message: "Do you want to resend code to email?".localize_, buttonTitle1: "Yes".localize_, action1: {
            let request = BaseRequest()
            request.url = GlobalConstants.RESEND_VERIFICATION_EMAIL
            request.method = .get
            
            RequestBuilder.requestWithSuccessfullRespnose(for: GenralRequsetModel.self, request: request) { (result) in
                
                if result.status ?? false {
                    self.showSnackbarMessage(message: result.data?.message ?? "", isError: false)
                    self.getUser()
                } else {
                    self.showSnackbarMessage(message: "Something happened! Please try again later".localize_, isError: true)
                }
                
            }
        }) {
            
        }
    }
    
    func login() {
        AppDelegate.shared.rootNavigationViewController = nil
        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
        vc.isFromOnBoarding = true
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func logout() {
        
        self.navigationController?.showAlertPopUp(title: "Logout".localize_, message: "Are you sure logout?".localize_, buttonTitle1: "Logout".localize_, action1: {
            let request = BaseRequest()
            request.url = GlobalConstants.LOGOUT
            request.method = .get
            
            request.parameters = [
                "push_token": UserProfile.shared.currentUser?.mobileToken ?? ""
            ]
            
            RequestBuilder.requestWithSuccessfullRespnose(for: LogoutModel.self, request: request) { (result) in
                
                if result.status ?? false {
                    UserProfile.shared.currentUser = nil
                    RequestBuilder.shared.updateHeader()
                    AppDelegate.shared.rootNavigationViewController = nil
                    let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
                    vc.isFromOnBoarding = true
                    vc.modalTransitionStyle = .coverVertical
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: true, completion: nil)
                } else {
                    self.showSnackbarMessage(message: "Something happened! Please try again later".localize_, isError: true)
                }
                
            }
        }, action2: {
            
        })
    
    }
    
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemTableViewCell", for: indexPath) as! MenuItemTableViewCell
        cell.object = itemsList[indexPath.row]
        cell.configureCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.itemsList[indexPath.row] {
        case Menu.login:
            self.login()
            break
        case Menu.orders:
            break
        case Menu.email:
            if UserProfile.shared.currentUser?.emailVerifiedAt == nil {
                resendEmailVerification()
            }
            break
        case Menu.shareTheApp:
            if let urlStr = NSURL(string: UserProfile.shared.constantsData?.iosAppURL ?? "") {
//                let objectsToShare = [urlStr]
//                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//                self.present(activityVC, animated: true, completion: nil)
                
                // This lines is for the popover you need to show in iPad
//                activityViewController.popoverPresentationController?.sourceView = (sender as! UIButton)
                
                let activityViewController : UIActivityViewController = UIActivityViewController(
                    activityItems: [ urlStr], applicationActivities: nil)
                                
                // This line remove the arrow of the popover to show in iPad
                activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
                activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
                
                // Pre-configuring activity items
                activityViewController.activityItemsConfiguration = [
                UIActivity.ActivityType.message
                ] as? UIActivityItemsConfigurationReading
                
                // Anything you want to exclude
                activityViewController.excludedActivityTypes = [
                    UIActivity.ActivityType.postToWeibo,
                    UIActivity.ActivityType.print,
                    UIActivity.ActivityType.assignToContact,
                    UIActivity.ActivityType.saveToCameraRoll,
                    UIActivity.ActivityType.addToReadingList,
                    UIActivity.ActivityType.postToFlickr,
                    UIActivity.ActivityType.postToVimeo,
                    UIActivity.ActivityType.postToTencentWeibo,
                    UIActivity.ActivityType.postToFacebook
                ]
                
                activityViewController.isModalInPresentation = true
                self.present(activityViewController, animated: true, completion: nil)
            }

            break
        case Menu.editProfile:
            let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "UpdateProfileViewController") as! UpdateProfileViewController
            vc.callback = {
                self.getUserData()
            }
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case Menu.editPassword:
            let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "UpdatePasswordViewController")
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case Menu.myAddresses:
            let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "MyAddressesViewController")
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case Menu.changeLanguage:
            self.changeLanguage()
            break
        case Menu.termsOfService:
            let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "TermsOfServiceViewController")
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case Menu.privacyPolicy:
            let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "PrivacyPolicyViewController")
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case Menu.rateApp:
//            if let url = URL(string: "itms-apps://itunes.apple.com/app/id1024941703"),
//            UIApplication.shared.canOpenURL(url){
//                if #available(iOS 10.0, *) {
//                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                } else {
//                    UIApplication.shared.openURL(url)
//                }
//            }
            SKStoreReviewController.requestReview()

            break
        case Menu.aboutApp:
            let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "AboutAppViewController")
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case Menu.contactUs:
            let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "HelpOrContactUsViewController") as! HelpOrContactUsViewController
            vc.pageType = .contactUs
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case Menu.chargeWallet:
            break
        case Menu.logout:
            self.logout()
            break
        case .serviceProvider:
            break
        case .favorite:
            let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "FavoriteViewController")
            self.navigationController?.pushViewController(vc, animated: true)
            break
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
}
