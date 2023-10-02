/*********************		Yousef El-Madhoun		*********************/
//
//  OrderDetailsProviderViewController.swift
//  amrk
//
//  Created by yousef on 14/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit

class OrderDetailsProviderViewController: UIViewController {
    
    @IBOutlet weak var lblCustomerName: UILabel!
    
    @IBOutlet weak var lblDeliveryName: UILabel!
    
    @IBOutlet weak var lblPhoneNumber: UILabel!
    
    @IBOutlet weak var lblPersonCount: UILabel!
    
    @IBOutlet weak var lblOrderType: UILabel!
    
    @IBOutlet weak var lblFeedback: UILabel!
    
    @IBOutlet weak var vwOrders: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var object: OrderItem?
    
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

extension OrderDetailsProviderViewController {
    
    func setupView() {
        
        self.lblCustomerName.text = self.object?.ownerName
        self.lblDeliveryName.text = self.object?.time
        self.lblPhoneNumber.text = "\(self.object?.mobile)"
        switch self.object?.persons {
        case .double(let x):
            self.lblPersonCount.text = "\(x)"
        case .string(let x):
            self.lblPersonCount.text = "\(x)"
       
        case .none:
            self.lblPersonCount.text = ""

        }
        self.lblOrderType.text = self.object?.typeName
        self.lblFeedback.text = self.object?.details
        
        self.tableView.register(UINib(nibName: "OrderProductTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderProductTableViewCell")
        
        self.vwOrders.isHidden = true
    }
    
    func localized() {
        
    }
    
    func setupData() {
        
    }
    
    func fetchData() {
        
    }

}

extension OrderDetailsProviderViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderProductTableViewCell", for: indexPath) as! OrderProductTableViewCell
        return cell
    }
    
}
