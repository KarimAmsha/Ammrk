/*********************		Yousef El-Madhoun		*********************/
//
//  BookingTableViewController.swift
//  amrk
//
//  Created by yousef on 27/08/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit
import FSPagerView
import iOSDropDown
import DZNEmptyDataSet
import MapKit
import Contacts

class BookingTableViewController: UIViewController, CLLocationManagerDelegate {
        
    @IBOutlet weak var pageControll: FSPageControl! {
        didSet {
            self.pageControll.numberOfPages = self.sliderItems.count
            pageControll.setFillColor(UIColor.hexColor(hex: "#D2D2D2"), for: .normal)
            pageControll.setFillColor("#219CD8".color_, for: .selected)
        }
    }
    
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.pagerView.itemSize = FSPagerView.automaticSize
            self.pagerView.transformer = FSPagerViewTransformer(type: .linear)
        }
    }
    
    @IBOutlet weak var txtSearch: UITextField!
    
    @IBOutlet weak var dwSelectCity: DropDown!
    
    @IBOutlet weak var dwSelectRestaurantType: DropDown!
    
    @IBOutlet weak var btnFilter: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var sliderItems: [SliderItem] = []
    
    var restaurants: [RestaurantItem] = []
    
    var cityId: Int?
    
    var kitchenId: Int?
    
    var isReview: Bool?
    var type: Int?
    
    var lat: Double?
    
    var lng: Double?
    
    var myLat: Double?
    
    var myLng: Double?
    
    var cities: [City] = []
    
    var kitchens: [City] = []
    
    var currentCity = ""
    
    let locationManager = CLLocationManager()
    
    var isGetLocation = false
    
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
    
    @IBAction func btnClearFilter(_ sender: Any) {
        self.txtSearch.text = ""
        self.cityId = nil
        self.dwSelectCity.text = ""
        self.kitchenId = nil
        self.dwSelectRestaurantType.text = ""
        self.isReview = nil
        self.lat = nil
        self.lng = nil
        
        self.getData()
    }
    
    @IBAction func btnFilter(_ sender: Any) {
        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.lat = self.lat
        vc.lng = self.lng
        vc.isReview = self.isReview
        vc.callback = { (lat, lng, isReview, type) in
            
            self.lat = lat
            self.lng = lng
            self.type = type
            self.isReview = isReview
            
            self.getData()
        }
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
}

extension BookingTableViewController {
    
    func setupView() {
        self.txtSearch.delegate = self
        
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        self.dwSelectCity.placeholder = "City".localize_
        self.dwSelectCity.font = UIFont(name: "NeoSansArabic", size: 16)
        self.dwSelectCity.didSelect { (value, index, id) in
            self.cityId = id
            self.getData()
        }
        
        self.dwSelectRestaurantType.placeholder = "Restaurant Type".localize_
        self.dwSelectRestaurantType.font = UIFont(name: "NeoSansArabic", size: 16)
        self.dwSelectRestaurantType.didSelect { (value, index, id) in
            self.kitchenId = id
            self.getData()
        }
        
        self.btnFilter.isHidden = true
        
        self.tableView.register(UINib(nibName: "ResturantTableViewCell", bundle: nil), forCellReuseIdentifier: "ResturantTableViewCell")
    }
    
    func localized() {
        
    }
    
    func setupData() {
        
        self.cities = UserProfile.shared.constantsData?.cities ?? []
        self.kitchens = UserProfile.shared.constantsData?.kitchens ?? []
        
        self.dwSelectCity.optionIds = []
        self.dwSelectRestaurantType.optionIds = []
        
        for value in self.cities {
            self.dwSelectCity.optionIds?.append(value.id ?? 0)
            self.dwSelectCity.optionArray.append(value.name ?? "")
        }
        
        for value in self.kitchens {
            self.dwSelectRestaurantType.optionIds?.append(value.id ?? 0)
            self.dwSelectRestaurantType.optionArray.append(value.name ?? "")
        }
    }
    
    func fetchData() {
        self.getData()
    }

}

extension BookingTableViewController {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        if isGetLocation {
            return
        } else {
            isGetLocation = true
        }
        
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.lat = locValue.latitude
        self.lng = locValue.longitude
        
        let request = BaseRequest()
        request.url = GlobalConstants.CITY
        request.method = .get
        request.parameters = [
            "lat": locValue.latitude,
            "lng": locValue.longitude,
        ]
        
        RequestBuilder.requestWithSuccessfullRespnose(for: UserCityModel.self, request: request) { (result) in
            
            if result.status ?? false {
                
                for value in self.cities {
                    
                    if value.id == result.data?.city?.id {
                        self.cityId = result.data?.city?.id
                        self.dwSelectCity.text = result.data?.city?.name
                        self.getData()
                        break
                    }
                    
                }
                
            }
            
        }
        
        
        let location = CLLocation(latitude: self.lat ?? 0, longitude: self.lng ?? 0)
        location.placemark { placemark, error in
            guard let placemark = placemark else {
                print("Error:", error ?? "nil")
                return
            }
            print(placemark.postalAddressFormatted ?? "")
            print(placemark.city ?? "")
            self.currentCity = placemark.city ?? ""
        }
    }
    
    func getData() {
        
        if !(self.txtSearch.isValidValue || self.cityId != nil || self.kitchenId != nil || self.isReview != nil || self.lat != nil || self.lng != nil) {
            self.btnFilter.isHidden = true
        } else {
            self.btnFilter.isHidden = false
        }
        
        let request = BaseRequest()
        request.url = GlobalConstants.RESTAURANTS

        request.method = .get
        
        if myLat != nil {
            request.parameters["lat"] = myLat
        }
        
        if myLng != nil {
            request.parameters["lng"] = myLng
        }
        
        if self.cityId != nil {
            request.parameters["city"] = self.cityId
        }
        
        if self.kitchenId != nil {
            request.parameters["kitchen"] = self.kitchenId
        }
        
        if self.txtSearch.isValidValue {
            request.parameters["name"] = self.txtSearch.text
        }
        
//        request.parameters["review"] = isReview ?? false ? "desc" : "asc"
        
        if lat != nil {
            request.parameters["lat"] = lat
        }
        
        if lng != nil {
            request.parameters["lng"] = lng
        }
        
        request.parameters["order_type"] = "reserve"

        
        RequestBuilder.requestWithSuccessfullRespnose(for: RestaurantModel.self, request: request) { (result) in
            
            if result.status ?? false {
                self.restaurants = result.data?.items?.data ?? []
                self.tableView.reloadData()
                
                self.tableView.emptyDataSetSource = self
                self.tableView.emptyDataSetDelegate = self
                
                if result.data?.slider?.count ?? 0 > 0 {
                    self.sliderItems = result.data?.slider ?? []
                    self.pagerView.reloadData()
                    self.pageControll.numberOfPages = result.data?.slider?.count ?? 0
                    self.pageControll.currentPage = 0
                }
            }
            
        }
    }
    
}

extension BookingTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResturantTableViewCell", for: indexPath) as! ResturantTableViewCell
        cell.object = self.restaurants[indexPath.row]
        cell.configureCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "ResturantDetailsViewController") as! ResturantDetailsViewController
        vc.id = self.restaurants[indexPath.row].id
        vc.isBookingTable = true
        vc.lat = self.lat
        vc.lng = self.lng
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}

extension BookingTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard self.txtSearch.isValidValue else {
            return true
        }
        
        self.view.endEditing(true)
        self.getData()
        
        return true
    }
    
}

extension BookingTableViewController: FSPagerViewDelegate, FSPagerViewDataSource {
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.sliderItems.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.imageURL(url: sliderItems[index].image ?? "")
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        cell.clipsToBounds = true
        return cell
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.pageControll.currentPage = targetIndex
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.pageControll.currentPage = pagerView.currentIndex
    }
    
}

extension BookingTableViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return "icEmptySearch".image_
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let emptyTitle = "No result".localize_
        
        return NSAttributedString.init(string: emptyTitle, attributes: [NSAttributedString.Key.font : UIFont(name: "NeoSansArabic", size: 16) ?? UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.opaqueSeparator])
    }
    
    func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 20
    }
    
}
