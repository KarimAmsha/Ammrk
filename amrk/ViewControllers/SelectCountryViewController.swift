/*********************		Yousef El-Madhoun		*********************/
//
//  SelectCountryViewController.swift
//  amrk
//
//  Created by yousef on 12/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit
import MRCountryPicker

class SelectCountryViewController: UIViewController {
    
    @IBOutlet weak var countryPicker: MRCountryPicker!
    
    var selectedCountry: PhoneNumberCodeModel?
    
    var callback: ((_ object: PhoneNumberCodeModel?) -> Void)?
       
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
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSelectCountry(_ sender: Any) {
        self.callback?(selectedCountry)
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension SelectCountryViewController {
    
    func setupView() {
        self.countryPicker.countryPickerDelegate = self
        
        if UserProfile.shared.language == Language.arabic {
            self.countryPicker.setLocale("ar")
        } else {
            self.countryPicker.setLocale("en")
        }
    }
    
    func localized() {
        
    }
    
    func setupData() {
        
    }
    
    func fetchData() {
       
    }

}

extension SelectCountryViewController: MRCountryPickerDelegate {

    func countryPhoneCodePicker(_ picker: MRCountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        self.selectedCountry = PhoneNumberCodeModel(name: name, code: phoneCode, flag: flag)
    }
    
}
