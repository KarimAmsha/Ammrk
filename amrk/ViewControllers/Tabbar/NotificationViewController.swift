/*********************		Yousef El-Madhoun		*********************/
//
//  NotificationViewController.swift
//  rukn2
//
//  Created by yousef on 14/06/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class NotificationViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var notifications: [NotificationItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        localized()
        setupData()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getData()
    }
    
}

extension NotificationViewController {
    
    func setupView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationTableViewCell")
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
    }
    
    func localized() {
        
    }
    
    func setupData() {
        
    }
    
    func fetchData() {
        self.getData()
    }

}

extension NotificationViewController {
    
    func getData() {
        
        guard let _ = UserProfile.shared.currentUser else {
            return
        }
        
        let request = BaseRequest()
        request.url = GlobalConstants.NOTIFICATIONS
        request.method = .get
        
        RequestBuilder.requestWithSuccessfullRespnose(for: NotificationModel.self, request: request) { (result) in
            
            if result.status ?? false {
                self.notifications = result.data?.items?.data ?? []
                self.tableView.reloadData()
            }
            
        }
        
    }
    
}

extension NotificationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
        cell.object = self.notifications[indexPath.row]
        cell.configureCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let order = self.notifications[indexPath.row].order {
            let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "OrderDetailsViewController") as! OrderDetailsViewController
            vc.object = order
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension NotificationViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UserProfile.shared.currentUser != nil ? "icEmptyNotifications".image_ : "icNoAuth".image_
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let emptyTitle = UserProfile.shared.currentUser != nil ? "There are no notifications".localize_ : "not logged in".localize_
        
        return NSAttributedString.init(string: emptyTitle, attributes: [NSAttributedString.Key.font : UIFont(name: "NeoSansArabic", size: 16) ?? UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.opaqueSeparator])
    }
    
    func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 20
    }
    
}
