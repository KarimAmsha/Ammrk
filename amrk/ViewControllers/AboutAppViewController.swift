/*********************		Yousef El-Madhoun		*********************/
//
//  AboutAppViewController.swift
//  amrk
//
//  Created by yousef on 01/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit

class AboutAppViewController: UIViewController {
    
    @IBOutlet weak var lblDetails: UILabel!
    
    @IBOutlet weak var lblPhoneNumber: UILabel!
    
    @IBOutlet weak var lblEmail: UILabel!
    
    var object: PageData?
    
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
    
    @IBAction func btnFacebook(_ sender: Any) {
    }
    
    @IBAction func btnInstagram(_ sender: Any) {
    }
    
    @IBAction func btnTwitter(_ sender: Any) {
    }
    
    @IBAction func btnWhatsUp(_ sender: Any) {
    }
}

extension AboutAppViewController {
    
    func setupView() {

    }
    
    func localized() {
        
    }
    
    func setupData() {
        
    }
    
    func fetchData() {
        
        let request = BaseRequest()
        request.url = GlobalConstants.ABOUT
        request.method = .get
        
        RequestBuilder.requestWithSuccessfullRespnose(for: PageModel.self, request: request) { (result) in
            
            if result.status ?? false {
                
                self.object = result.data
                
                let style = NSMutableParagraphStyle()
                style.lineSpacing = 18
                style.alignment = .center
                
                let attributes = [
                    NSAttributedString.Key.paragraphStyle : style,
                    NSAttributedString.Key.foregroundColor : UIColor.hexColor(hex: "#444251"),
                    NSAttributedString.Key.font : UIFont(name: "NeoSansArabic", size: 16),
                ]
                
                self.lblDetails.attributedText = NSAttributedString(string: result.data?.page?.content ?? "", attributes: attributes as [NSAttributedString.Key : Any])
                
                self.lblPhoneNumber.text = "\(result.data?.whatsapp ?? "")"
                self.lblEmail.text = result.data?.email
                
            }
            
        }
        
    }

}
