/*********************		Yousef El-Madhoun		*********************/
//
//  PrivacyPolicyViewController.swift
//  amrk
//
//  Created by yousef on 01/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit

class PrivacyPolicyViewController: UIViewController {
    
    @IBOutlet weak var txtDetails: UITextView!
    
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
    
}

extension PrivacyPolicyViewController {
    
    func setupView() {
        
    }
    
    func localized() {
        
    }
    
    func setupData() {
        
    }
    
    func fetchData() {
        
        let request = BaseRequest()
        request.url = GlobalConstants.PRIVACY
        request.method = .get
        
        RequestBuilder.requestWithSuccessfullRespnose(for: PageModel.self, request: request) { (result) in
            
            if result.status ?? false {
                
                let style = NSMutableParagraphStyle()
                style.lineSpacing = 18
                let attributes = [NSAttributedString.Key.paragraphStyle : style, NSAttributedString.Key.foregroundColor : UIColor.hexColor(hex: "#444251"), NSAttributedString.Key.font : UIFont(name: "NeoSansArabic", size: 16)]
                self.txtDetails.attributedText = NSAttributedString(string: result.data?.page?.content ?? "", attributes: attributes as [NSAttributedString.Key : Any])
                
            }
            
        }
        
    }

}
