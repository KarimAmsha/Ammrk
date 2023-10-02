/*********************		Yousef El-Madhoun		*********************/
//
//  RateServiceViewController.swift
//  amrk
//
//  Created by yousef on 13/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit
import Cosmos

class RateServiceViewController: UIViewController {
    
    @IBOutlet weak var vwRate: CosmosView!
    
    var idOrder: Int?
    
    var callback: ((_ rate: Double) -> Void)?
    
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
    
    @IBAction func btnRate(_ sender: Any) {
        let request = BaseRequest()
        request.url = "\(GlobalConstants.ORDER)/\(self.idOrder ?? 0)/review"
        request.method = .post
        
        request.parameters["review"] = Int(self.vwRate.rating)
        
        RequestBuilder.requestWithSuccessfullRespnose(for: ReviewOrderModel.self, request: request) { (result) in
            
            if result.status ?? false {
                self.callback?(self.vwRate.rating)
                self.dismiss(animated: true, completion: nil)
            } else {
                self.showSnackbarMessage(message: "Something happened! Please try again later".localize_, isError: true)
            }
            
        }
    }
    
}

extension RateServiceViewController {
    
    func setupView() {
        self.vwRate.rating = 5
    }
    
    func localized() {
        
    }
    
    func setupData() {
        
    }
    
    func fetchData() {
        
    }

}
