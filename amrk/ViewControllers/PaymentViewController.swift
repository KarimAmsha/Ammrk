/*********************		Yousef El-Madhoun		*********************/
//
//  PaymentViewController.swift
//  amrk
//
//  Created by yousef on 11/10/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController {
    
    @IBOutlet weak var creditCard: MFCardView!
    
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
    
}

extension PaymentViewController {
    
    func setupView() {
        creditCard.autoDismiss = true
//        creditCard.backgroundColor = UIColor.hexColor(hex: "#219CD8")
//        creditCard.backColor = UIColor.hexColor(hex: "#219CD8")
//        creditCard.backTape = UIColor.hexColor(hex: "#219CD8")
//        creditCard.frontChromeColor = UIColor.hexColor(hex: "#219CD8")
        creditCard.toast = false
        creditCard.delegate = self
        creditCard.controlButtonsRadius = 5
        creditCard.cardRadius = 5
    }
    
    func localized() {
        
    }
    
    func setupData() {
        
    }
    
    func fetchData() {
        
    }

}

extension PaymentViewController: MFCardDelegate {

    func cardDoneButtonClicked(_ card: Card?, error: String?) {
        if error == nil{
            print(card!)
            let cardNumber = card?.number!
                self.view.makeToast("\(cardNumber!) Card added")
        }else{
            print(error!)
            
        }
    }
    
    func cardTypeDidIdentify(_ cardType: String) {
        print(cardType)
        
        // Notes -
        
        // You can change Card background and other parameters once Card Type is identified
        // e.g - myCard?.cardImage  will help set Card Image
    }
    
    func cardDidClose() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
