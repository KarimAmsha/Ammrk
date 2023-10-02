/*********************		Yousef El-Madhoun		*********************/
//
//  SplashViewController.swift
//  amrk
//
//  Created by yousef on 06/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    @IBOutlet weak var amrakConstraint: NSLayoutConstraint!
    @IBOutlet weak var amrakLblAr: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var amrakLblEn: UILabel!
    
    var isFromOnBoarding = false
    
    private let icLogo: UIImageView = {
        let img = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 250 / 375, height: UIScreen.main.bounds.height * 350 / 812))
        img.image = "icLogo-1".image_
        return img
    }()
    
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
        if isFromOnBoarding {
            var vcName = ""

            if let _ = UserProfile.shared.currentUser {
                vcName = "MainNavigationViewController"
            } else {
                vcName = "SignInPopupViewController"
                
                UIView.animate(withDuration: 1, animations: {
                    self.imgLogo.alpha = 1
                    self.amrakLblEn.alpha = 1
                    self.amrakLblAr.alpha = 1
                   
                })
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.amrakConstraint.constant = 10

                    UIView.animate(withDuration: 1) {
                        self.view.layoutIfNeeded()
                    }
                }
               
                
            }
            
            let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: vcName)
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        } else {
            self.icLogo.center = view.center

            self.animate()
        }
    }
    
}

extension SplashViewController {
    
    func setupView() {
        self.imgLogo.alpha = 0
        self.amrakLblAr.alpha = 0
        self.amrakLblEn.alpha = 0
        if !isFromOnBoarding {
            self.view.addSubview(self.icLogo)

        }
    }
    
    func localized() {
        
    }
    
    func setupData() {
        
    }
    
    func fetchData() {
        
    }

}

extension SplashViewController {
    
    func animate() {
        
        UIView.animate(withDuration: 1, animations: {
            let size = self.view.frame.size.width * 3
            let diffX = size - self.view.frame.size.width
            let diffY = self.view.frame.size.height - size
            
            self.icLogo.frame = CGRect(x: -(diffX / 2), y: diffY / 2, width: size, height: size)
            
        })
        
        UIView.animate(withDuration: 1.5, animations: {
            self.icLogo.alpha = 0
        }, completion: { done in
            if done {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                    
                    var vcName = ""
                    
                    if UserProfile.shared.language == nil {
                        vcName = "SelectLanguageViewController"
                        
                        UIView.animate(withDuration: 1, animations: {
                            self.imgLogo.alpha = 1
                            self.amrakLblEn.alpha = 1
                            self.amrakLblAr.alpha = 1
                           
                        })
                    } else if UserProfile.shared.isOpenApp == nil || UserProfile.shared.isOpenApp == false {
                        
                        vcName = "OnBoardingViewController"
                        
                    } else if let _ = UserProfile.shared.currentUser {
                        vcName = "MainNavigationViewController"
                    } else {
                        vcName = "SignInPopupViewController"
                        
                        UIView.animate(withDuration: 1, animations: {
                            self.imgLogo.alpha = 1
                            self.amrakLblEn.alpha = 1
                            self.amrakLblAr.alpha = 1
                           
                        })
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.amrakConstraint.constant = 10

                            UIView.animate(withDuration: 1) {
                                self.view.layoutIfNeeded()
                            }
                        }
                       
                        
                    }
                    
                    let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: vcName)
                    vc.modalTransitionStyle = .coverVertical
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: true, completion: nil)

                })
            }
        })
        
    }
    
}
