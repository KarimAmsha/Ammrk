/*********************		Yousef El-Madhoun		*********************/
//
//  ResturantDetailsViewController.swift
//  amrk
//
//  Created by yousef on 20/08/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import CoreLocation

class ResturantDetailsViewController: UIViewController {
    
    @IBOutlet weak var icFavorite: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var imgResturant: UIImageView!
    
    @IBOutlet weak var imgClock: UIImageView!
    
    @IBOutlet weak var lblRate: UILabel!
    
    @IBOutlet weak var lblRateCount: UILabel!
    
    @IBOutlet weak var lblResturantStatus: UILabel!
    
    @IBOutlet weak var lblDistance: UILabel!
    
    @IBOutlet weak var lblDetails: UILabel!
    
    @IBOutlet weak var coCategory: UICollectionView!
    
    @IBOutlet weak var tbMenu: UITableView!
    
    @IBOutlet weak var consTbMenu: NSLayoutConstraint!

    @IBOutlet weak var btnBookingTable: UIButton!
    
    @IBOutlet weak var vwBtnOrderNow: UIView!
    
    @IBOutlet weak var lblCount: UILabel!
    
    var isBookingTable = false
    
    var id: Int?
    
    var object: RestaurantDetailsData?
    
    var categories: [RestaurantCategory] = []
    
    var selectedCategory: RestaurantCategory?
    
    var selectedCategoryIndex: Int?
    
    var orders: [NewOrderItem] = []
    
    let locationManager = CLLocationManager()
    
    var lat: Double?
    var lng: Double?
    
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
        self.scrollView.layoutSubviews()
        self.scrollView.layoutIfNeeded()
        self.consTbMenu.constant = self.selectedCategory?.items?.count == 0 ? 300 : self.tbMenu.contentSize.height
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func locationAction(_ sender: Any) {
        openGoogleMap()
    }
    
    func openGoogleMap() {
        guard let lat = object?.restaurant?.userInfo?.lat else {return }
        guard let long = object?.restaurant?.userInfo?.lng else {return }
        
        
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //if phone has an app
            
            if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(Double(lat)),\(Double(long))&directionsmode=driving") {
                UIApplication.shared.open(url, options: [:])
            }}
        else {
            //Open in browser
            if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(Double(lat)),\(Double(long))&directionsmode=driving") {
                UIApplication.shared.open(urlDestination)
            }
        }
    }

            
    
    @IBAction func btnFavorite(_ sender: Any) {
        
        guard let _ = UserProfile.shared.currentUser else {
            self.showSnackbarMessage(message: "You are not logged in".localize_, isError: true)
            return
        }
        
        let request = BaseRequest()
        
        if self.object?.restaurant?.isFav == 1 {
            request.url = "\(GlobalConstants.FAVORITE)/\(self.object?.restaurant?.favId ?? 0)/delete"
            request.method = .get
        } else {
            request.url = GlobalConstants.ADD_FAVORITE
            request.method = .post
            request.parameters = [
                "id": self.object?.restaurant?.id ?? 0,
                "type": "provider"
            ]
        }
        
        RequestBuilder.requestWithSuccessfullRespnose(for: ReviewOrderModel.self, request: request) { (result) in
            
            if result.status ?? false {
                self.fetchData()
            }
            
        }
        
    }
    
    @IBAction func btnShare(_ sender: Any) { // https://ammrk.com/
        if let urlStr = NSURL(string: "https://ammrk.com/ar/share/\(self.object?.restaurant?.id ?? 0)?app_id=com.amrk.app") {
            let objectsToShare = [urlStr]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnBookingTable(_ sender: Any) {
        
        guard let _ = UserProfile.shared.currentUser else {
            self.showSnackbarMessage(message: "You are not logged in".localize_, isError: true)
            return
        }
        
        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "BookingTableFormViewController") as! BookingTableFormViewController
        vc.idRestaurant = self.id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnOrderNow(_ sender: Any) {
        
        guard let _ = UserProfile.shared.currentUser else {
            self.showSnackbarMessage(message: "You are not logged in".localize_, isError: true)
            return
        }
        
        if (object?.restaurant?.userInfo?.isOpen == 0) {
            self.showSnackbarMessage(message: "Sorry, The restaurant is closed now".localize_, isError: true)
            return
        }
        
        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "ConfiremNewOrderViewController") as! ConfiremNewOrderViewController
        vc.objectResturant = self.object?.restaurant
        vc.orders = self.orders
        vc.callback = { newOrders in
            self.orders = newOrders ?? []
            self.updateBtnOrder()
            self.tbMenu.reloadData()
            self.viewDidLayoutSubviews()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ResturantDetailsViewController {
    
    func setupView() {
        self.coCategory.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        
        self.tbMenu.register(UINib(nibName: "MenuResturantTableViewCell", bundle: nil), forCellReuseIdentifier: "MenuResturantTableViewCell")
        
        self.tbMenu.emptyDataSetSource = self
        self.tbMenu.emptyDataSetDelegate = self
        
        if !self.isBookingTable {
            self.btnBookingTable.isHidden = true
        }
        
        self.vwBtnOrderNow.isHidden = true
        
    }
    
    func localized() {
        
    }
    
    func setupData() {
        
    }
    
    func fetchData() {
        
        let request = BaseRequest()
        request.method = .get
        
//        if CLLocationManager.locationServicesEnabled() {
////            request.url = "\(GlobalConstants.RESTAURANTS)/\(self.id ?? 0)?lat=\(locationManager.location?.coordinate.latitude ?? 0)&lng=\(locationManager.location?.coordinate.longitude ?? 0)"
//            request.url = "\(GlobalConstants.RESTAURANTS)/\(self.id ?? 0)"
//        } else {
//
//        }
        
        request.url = "\(GlobalConstants.RESTAURANTS)/\(self.id ?? 0)"
        
        if let lat = self.lat, let lng = self.lng {
            request.parameters["lat"] = lat
            request.parameters["lng"] = lng
        }
        
        RequestBuilder.requestWithSuccessfullRespnose(for: RestaurantDetailsModel.self, request: request) { (result) in
            
            if result.status ?? false {
                self.object = result.data
                self.updateData()
            }
            
        }
        
    }

}

extension ResturantDetailsViewController {
    
    func setTextInLblDetails(text: String) {
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 18
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: NSMakeRange(0, attributedString.length))
        self.lblDetails.attributedText = attributedString
    }
    
    func updateData() {
        self.icFavorite.image = self.object?.restaurant?.isFav == 1 ? "icFavorite".image_ : "icUnFavorite".image_
        
        self.lblTitle.text = self.object?.restaurant?.name ?? ""
        self.imgResturant.imageURL(url: self.object?.restaurant?.image ?? "")
        self.lblRate.text = "\(self.object?.restaurant?.userInfo?.review?.rounded(toPlaces: 2) ?? 0)"
        
        self.lblDistance.text = "\(self.object?.restaurant?.userInfo?.distance ?? 0) \("KM".localize_)"
        
        self.lblResturantStatus.text = self.object?.restaurant?.userInfo?.isOpen == 1 ? "Opened".localize_ : "Closed".localize_
        
        self.imgClock.imageColor = self.object?.restaurant?.userInfo?.isOpen == 0 ? UIColor.red : UIColor.hexColor(hex: "#008000")
        self.lblResturantStatus.textColor = self.object?.restaurant?.userInfo?.isOpen == 0 ? UIColor.red : UIColor.hexColor(hex: "#008000")
        
        self.setTextInLblDetails(text: self.object?.restaurant?.userInfo?.about ?? "")
        self.categories = self.object?.items ?? []
        
        if self.categories.count > 0 {
            self.selectedCategoryIndex = 0
            self.selectedCategory = self.categories.first
            self.coCategory.reloadData()
        }
    
        self.tbMenu.reloadData()
        self.viewDidLayoutSubviews()
    }
    
    func updateBtnOrder() {
        
        self.lblCount.text = "\(self.orders.count)"
        
        if self.orders.count > 0 {
            self.vwBtnOrderNow.isHidden = false
        } else {
            self.vwBtnOrderNow.isHidden = true
        }
    }
    
}

extension ResturantDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = coCategory.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        cell.indexPath = indexPath
        cell.object = self.categories[indexPath.row].name
        cell.configureCell()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedCategoryIndex = indexPath.row
        self.selectedCategory = self.categories[indexPath.row]
        
        self.coCategory.reloadData()
        self.tbMenu.reloadData()
        self.viewDidLayoutSubviews()
        
    }
    
}

extension ResturantDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedCategory?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuResturantTableViewCell", for: indexPath) as! MenuResturantTableViewCell
        cell.object = self.selectedCategory?.items?[indexPath.row]
        cell.configureCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isBookingTable {
            return
        }
        
        guard let _ = UserProfile.shared.currentUser else {
            self.showSnackbarMessage(message: "You are not logged in".localize_, isError: true)
            return
        }
        
        guard let item = self.selectedCategory?.items?[indexPath.row] else {
            return
        }

        for (index, value) in self.orders.enumerated() {
            if value.order?.id == item.id {
                
                self.showAlertPopUp(title: "Delete Order".localize_, message: "Are you sure delete order?".localize_, buttonTitle1: "Delete".localize_, buttonTitle2: "Close".localize_, action1: {
                    self.orders.remove(at: index)
                    self.updateBtnOrder()
                    self.tbMenu.reloadData()
                    self.viewDidLayoutSubviews()
                }) {
                    
                }
                
                return
            }
        }
        
        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "NewOrderViewController") as! NewOrderViewController
        vc.object = self.selectedCategory?.items?[indexPath.row]
        
        vc.callback = { order in
            
            guard let order = order else {
                return
            }
            
            self.orders.append(order)
            self.updateBtnOrder()
            self.tbMenu.reloadData()
            self.viewDidLayoutSubviews()
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * (200 / 812)
    }
    
}

extension ResturantDetailsViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return "icMealsEmpty".image_
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let emptyTitle = "menu is empty".localize_
        
        return NSAttributedString.init(string: emptyTitle, attributes: [NSAttributedString.Key.font : UIFont(name: "NeoSansArabic", size: 16) ?? UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.opaqueSeparator])
    }
    
    func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 20
    }
    
}
