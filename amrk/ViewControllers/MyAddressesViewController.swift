/*********************		Yousef El-Madhoun		*********************/
//
//  MyAddressesViewController.swift
//  amrk
//
//  Created by yousef on 09/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class MyAddressesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var addresses: [AddressItem] = []
    
    var callback: (() -> Void)?
    
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
        self.callback?()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAdd(_ sender: Any) {
        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "AddOrEditAddressViewController") as! AddOrEditAddressViewController
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overFullScreen
        vc.callback = {
            self.fetchData()
        }
        self.present(vc, animated: true, completion: nil)
    }
    
}

extension MyAddressesViewController {
    
    func setupView() {
        self.tableView.register(UINib(nibName: "MyAdressesTableViewCell", bundle: nil), forCellReuseIdentifier: "MyAdressesTableViewCell")
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
    }
    
    func localized() {
        
    }
    
    func setupData() {
        
    }
    
    func fetchData() {
        let request = BaseRequest()
        request.url = GlobalConstants.ADDRESSES
        request.method = .get
        
        RequestBuilder.requestWithSuccessfullRespnose(for: AddressModel.self, request: request) { (result) in
            
            if result.status ?? false {
                self.addresses = result.data?.items ?? []
                self.tableView.reloadData()
            }
            
        }
    }

}

extension MyAddressesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyAdressesTableViewCell", for: indexPath) as! MyAdressesTableViewCell
        cell.object = self.addresses[indexPath.row]
        cell.configureCell()
        return cell
    }
    
}

extension MyAddressesViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return "icAddressesEmpty".image_
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let emptyTitle = "There are no addresses".localize_
        
        return NSAttributedString.init(string: emptyTitle, attributes: [NSAttributedString.Key.font : UIFont(name: "NeoSansArabic", size: 16) ?? UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.opaqueSeparator])
    }
    
    func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 20
    }
}
