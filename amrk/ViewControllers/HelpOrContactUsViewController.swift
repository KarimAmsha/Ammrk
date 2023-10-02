/*********************		Yousef El-Madhoun		*********************/
//
//  HelpOrContactUsViewController.swift
//  amrk
//
//  Created by yousef on 01/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit

class HelpOrContactUsViewController: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var txtTitle: UITextField!
    
    @IBOutlet weak var txtMessage: UITextView!
    
    enum PageType {
        case help
        case contactUs
    }
    
    var pageType: PageType = .help
    
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
    
    @IBAction func btnSendMessage(_ sender: Any) {
        
        guard let _ = UserProfile.shared.currentUser else {
            self.showSnackbarMessage(message: "You are not logged in".localize_, isError: true)
            return
        }
        
        guard let title = self.txtTitle.text, self.txtTitle.isValidValue else {
            self.showSnackbarMessage(message: "Please enter the title".localize_, isError: true)
            return
        }
        
        guard let message = self.txtMessage.text, self.txtMessage.isValidValue, message != "Enter Message..".localize_ else {
            self.showSnackbarMessage(message: "Please enter the message".localize_, isError: true)
            return
        }
        
        let request = BaseRequest()
        
        switch pageType {
        case .help:
            request.url = GlobalConstants.HELP
            break
        case .contactUs:
            request.url = GlobalConstants.CONTACT_US
            break
        }
        
        request.method = .post
        request.parameters = [
            "title": title,
            "message": message
        ]
        
        RequestBuilder.requestWithSuccessfullRespnose(for: GenralRequsetModel.self, request: request) { (result) in
            
            if result.status ?? false {
                
                self.showSnackbarMessage(message: result.data?.message ?? "", isError: false)
                
                let style = NSMutableParagraphStyle()
                style.lineSpacing = 18
                let attributes = [NSAttributedString.Key.paragraphStyle : style, NSAttributedString.Key.font : UIFont(name: "NeoSansArabic", size: 18), NSAttributedString.Key.foregroundColor : UIColor.placeholderText]
                self.txtMessage.attributedText = NSAttributedString(string: "Enter Message..".localize_, attributes: attributes as [NSAttributedString.Key : Any])
                
            } else {
                self.showSnackbarMessage(message: "Something happened! Please try again later".localize_, isError: true)
            }
            
            
        }
        
    }
    
}

extension HelpOrContactUsViewController {
    
    func setupView() {
        switch pageType {
        case .help:
            self.lblTitle.text = "Help".localize_
            break
        case .contactUs:
            self.lblTitle.text = "Contact Us".localize_
            break
        }
        
        self.txtMessage.delegate = self
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 18
        let attributes = [NSAttributedString.Key.paragraphStyle : style, NSAttributedString.Key.font : UIFont(name: "NeoSansArabic", size: 16), NSAttributedString.Key.foregroundColor : UIColor.placeholderText]
        self.txtMessage.attributedText = NSAttributedString(string: "Enter Message..".localize_, attributes: attributes as [NSAttributedString.Key : Any])
    }
    
    func localized() {
        
    }
    
    func setupData() {
        
    }
    
    func fetchData() {
        
    }

}

extension HelpOrContactUsViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtMessage.text == "Enter Message..".localize_ && txtMessage.textColor == UIColor.placeholderText {
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 10
            let attributes = [NSAttributedString.Key.paragraphStyle : style, NSAttributedString.Key.font : UIFont(name: "NeoSansArabic", size: 16), NSAttributedString.Key.foregroundColor : UIColor.placeholderText]
            self.txtMessage.attributedText = NSAttributedString(string: "", attributes: attributes as [NSAttributedString.Key : Any])
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard txtMessage.text == "Enter Message..".localize_ && txtMessage.textColor == UIColor.placeholderText else {
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 10
            let attributes = [NSAttributedString.Key.paragraphStyle : style, NSAttributedString.Key.font : UIFont(name: "NeoSansArabic", size: 16), NSAttributedString.Key.foregroundColor : UIColor.black]
            self.txtMessage.attributedText = NSAttributedString(string: txtMessage.text, attributes: attributes as [NSAttributedString.Key : Any])
            return
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if txtMessage.text.isEmpty {
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 10
            let attributes = [NSAttributedString.Key.paragraphStyle : style, NSAttributedString.Key.font : UIFont(name: "NeoSansArabic", size: 16), NSAttributedString.Key.foregroundColor : UIColor.placeholderText]
            self.txtMessage.attributedText = NSAttributedString(string: "Enter Message..".localize_, attributes: attributes as [NSAttributedString.Key : Any])
        }
    }
    
}
