/*********************		Yousef El-Madhoun		*********************/
//
//  SelectLanguageViewController.swift
//  amrk
//
//  Created by yousef on 23/08/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit
import MOLH

class SelectLanguageViewController: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var btnEnglish: UIButton!
    
    @IBOutlet weak var btnArabic: UIButton!
    
    @IBOutlet weak var imgCheckEnglish: UIImageView!
    
    @IBOutlet weak var imgCheckArbic: UIImageView!
    
    @IBOutlet weak var btnConfirm: UIButton!
    
    var language: Language? {
        didSet {
            self.changeButtonsStatus()
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
    }
    
    @IBAction func btnEnglish(_ sender: Any) {
        self.language = .english
    }
    
    @IBAction func btnArabic(_ sender: Any) {
        self.language = .arabic
    }
    
    @IBAction func btnConfirm(_ sender: Any) {
        self.changeLanguage()
    }
    
}

extension SelectLanguageViewController {
    
    func setupView() {
        
    }
    
    func localized() {
        
    }
    
    func setupData() {
        self.language = Locale.current.languageCode == "ar" ? .arabic : .english
    }
    
    func fetchData() {
        
    }

}

extension SelectLanguageViewController {
    
    func changeButtonsStatus() {
        
        switch self.language {
        case .english:
            self.lblTitle.text = "Choose your language"
            self.lblTitle.textAlignment = .left
            
            self.imgCheckEnglish.isHidden = false
            self.btnEnglish.borderColor = "#219CD8".color_
            self.btnEnglish.setTitleColor("#219CD8".color_, for: .normal)
            
            self.imgCheckArbic.isHidden = true
            self.btnArabic.borderColor = .opaqueSeparator
            self.btnArabic.setTitleColor(.gray, for: .normal)
            
            self.btnConfirm.setTitle("Confirm", for: .normal)
            break
        case .arabic:
            self.lblTitle.text = "إختر لغتك"
            self.lblTitle.textAlignment = .right
            
            self.imgCheckEnglish.isHidden = true
            self.btnEnglish.borderColor = .opaqueSeparator
            self.btnEnglish.setTitleColor(.gray, for: .normal)
            
            self.imgCheckArbic.isHidden = false
            self.btnArabic.borderColor = "#219CD8".color_
            self.btnArabic.setTitleColor("#219CD8".color_, for: .normal)
            
            self.btnConfirm.setTitle("تأكيد", for: .normal)
            break
        default:
            break
        }
        
    }
    
    func changeLanguage() {
        MOLH.setLanguageTo(language?.code ?? "en")
        UserProfile.shared.language = language
        RequestBuilder.shared.updateHeader()
        UIView.appearance().semanticContentAttribute = language == .english ? .forceLeftToRight : .forceRightToLeft
        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "OnBoardingViewController")
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}
