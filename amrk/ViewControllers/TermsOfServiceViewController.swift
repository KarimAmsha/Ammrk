/*********************		Yousef El-Madhoun		*********************/
//
//  TermsOfServiceViewController.swift
//  amrk
//
//  Created by yousef on 01/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit

class TermsOfServiceViewController: UIViewController {
    
    @IBOutlet weak var arrowIcon: UIImageView!
    @IBOutlet weak var beforeBackView: UIView!
    @IBOutlet weak var txtDetails: UITextView!
    @IBOutlet weak var topView: UIView!
    
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
        
        if let _ = self.navigationController {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
}

extension TermsOfServiceViewController {
    
    func setupView() {
        arrowIcon.tintColor = .hexColor(hex: "#219CD8")

    }
    
    func localized() {
        
    }
    
    func setupData() {
        
    }
    
    func fetchData() {
        
        let request = BaseRequest()
        request.url = GlobalConstants.CONDITIONS
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
