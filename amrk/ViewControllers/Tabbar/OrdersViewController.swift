/*********************		Yousef El-Madhoun		*********************/
//
//  OrdersViewController.swift
//  rukn2
//
//  Created by yousef on 21/06/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import iOSDropDown
import MOLH

class OrdersViewController: UIViewController {
    
    @IBOutlet weak var stOrderStatus: UIStackView!
    
    @IBOutlet weak var dwOrderStatus: DropDown!
    
    @IBOutlet weak var tableView: UITableView!
    
    var orders: [OrderItem] = []
    
    var idOrderType: Int?
    var orderType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        localized()
        setupData()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchData()
    }
    
}

extension OrdersViewController {
    
    func setupView() {
        self.tableView.register(UINib(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderTableViewCell")
        
        self.tableView.register(UINib(nibName: "ProviderOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "ProviderOrderTableViewCell")
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        
        if UserProfile.shared.currentUser?.type != 2 {
            self.stOrderStatus.isHidden = true
        }
        
        self.dwOrderStatus.placeholder = "Order Status".localize_
        self.dwOrderStatus.optionIds = [0, 1]
        self.dwOrderStatus.optionArray = ["Current orders".localize_, "History".localize_]
        self.dwOrderStatus.didSelect { (value, index, id) in
            self.idOrderType = id
            self.fetchData()
        }
        
        if UserProfile.shared.currentUser?.type == 2 {
            self.idOrderType = 0
            self.dwOrderStatus.text = self.dwOrderStatus.optionArray.first ?? ""
        }
        
    }
    
    func localized() {
        
    }
    
    func setupData() {
        
    }
    
    func fetchData() {
        
        guard let _ = UserProfile.shared.currentUser else {
            return
        }
        
        let request = BaseRequest()
        request.url = GlobalConstants.ORDERS
        request.method = .get
        
        if let id = self.idOrderType {
            if id == 0 {
                request.parameters = ["orders_type": "current"]
            } else {
                request.parameters = ["orders_type": "finished"]
            }
            
            request.parameters["lang"] = MOLHLanguage.currentAppleLanguage()
        }
        
        RequestBuilder.requestWithSuccessfullRespnose(for: OrderModel.self, request: request) { (result) in
            
            if result.status ?? false {
                self.orders = result.data?.items?.data ?? []
                self.tableView.reloadData()
            }
            
        }
    }

}

extension OrdersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if UserProfile.shared.currentUser?.type == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProviderOrderTableViewCell", for: indexPath) as! ProviderOrderTableViewCell
            cell.object = self.orders[indexPath.row]
            
            cell.acceptBtn.tag = indexPath.row
            cell.acceptBtn.addTarget(self, action: #selector(acceptOrderAction), for: .touchUpInside)
            
            cell.rejectBtn.tag = indexPath.row
            cell.rejectBtn.addTarget(self, action: #selector(rejectOrderAction), for: .touchUpInside)
            
            cell.configuareCell()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath) as! OrderTableViewCell
            cell.object = self.orders[indexPath.row]
            cell.configareCell()
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if UserProfile.shared.currentUser?.type == 2 {
            let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "OrderDetailsProviderViewController") as! OrderDetailsProviderViewController
            vc.object = self.orders[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "OrderDetailsViewController") as! OrderDetailsViewController
            vc.object = self.orders[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UserProfile.shared.currentUser?.type == 2 {
            return 250
        } else {
            return 135
        }
    }
    
    @objc func acceptOrderAction(sender: UIButton) {
        
        
        let request = BaseRequest()
        request.url = "/order/\(self.orders[sender.tag].id ?? 0)/status"
        request.method = .post
        
        request.parameters["status"] = "1"
        
        
        RequestBuilder.requestWithSuccessfullRespnose(for: StatusModel.self, request: request) { (result) in
            print(result)
            
//            if result.status ?? false {
//                self.showSnackbarMessage(message: result.data?.message ?? "", isError: false)
//            }
            
            self.showSnackbarMessage(message: result.data?.message ?? "", isError: false)
            self.fetchData()
            
        }
    }
    
    @objc func rejectOrderAction(sender: UIButton) {
        
        let request = BaseRequest()
        request.url = "/order/\(self.orders[sender.tag].id ?? 0)/status"
        request.method = .post
        
        request.parameters["status"] = "4"
        
        
        RequestBuilder.requestWithSuccessfullRespnose(for: StatusModel.self, request: request) { (result) in
            print(result)
            
//            if result.status ?? false {
//                self.showSnackbarMessage(message: result.data?.message ?? "", isError: false)
//            }
            
            self.showSnackbarMessage(message: result.data?.message ?? "", isError: false)
            self.fetchData()
        }
    }
}

extension OrdersViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UserProfile.shared.currentUser != nil ? "icNoOrder".image_ : "icNoAuth".image_
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let emptyTitle = UserProfile.shared.currentUser != nil ? "There are no orders".localize_ : "not logged in".localize_
        
        return NSAttributedString.init(string: emptyTitle, attributes: [NSAttributedString.Key.font : UIFont(name: "NeoSansArabic", size: 16) ?? UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.opaqueSeparator])
    }
    
    func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 20
    }
}
