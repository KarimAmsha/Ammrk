/*********************		Yousef El-Madhoun		*********************/
//
//  DeliversViewController.swift
//  amrk
//
//  Created by yousef on 15/08/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit
import FSPagerView
import iOSDropDown
import DZNEmptyDataSet
import MapKit
import Contacts
import BEMCheckBox

class DeliversViewController: UIViewController, CLLocationManagerDelegate {
    
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
    
    @IBOutlet weak var allBtn: UIButton!
    @IBOutlet weak var chFromBranch: BEMCheckBox!
    @IBOutlet weak var chDelivery: BEMCheckBox!
    @IBOutlet weak var lblFromBranch: UILabel!
    @IBOutlet weak var lbldelivery: UILabel!
//    @IBOutlet weak var txtSearch: UITextField!
    
    @IBOutlet weak var dwSelectCity: DropDown!
    
    @IBOutlet weak var dwSelectRestaurantType: DropDown!
    
    @IBOutlet weak var btnClearFilter: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var sliderItems: [SliderItem] = []
    
    var restaurants: [RestaurantItem] = []
    
    var cityId: Int?
    
    var kitchenId: Int?
    
    var isReview: Bool?
    
    var lat: Double?
    
    var lng: Double?
    
    var myLat: Double?
    
    var myLng: Double?
    
    var cities: [City] = []
    
    var kitchens: [City] = []
    
    // 1: city, 2: nearest, 3: location, 4: review
    var type: Int?
    
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
    
    @IBAction func allAction(_ sender: Any) {
        self.cityId = nil
        self.dwSelectCity.text = ""
        self.kitchenId = nil
        self.dwSelectRestaurantType.text = ""
        self.isReview = nil
        self.lat = nil
        self.lng = nil
        
        self.getData()
    }
    
    @IBAction func btnFitter(_ sender: Any) {
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
    
    @IBAction func fromBranchAction(_ sender: Any) {
        self.chDelivery.on = false
        self.lbldelivery.textColor = .opaqueSeparator
        
        self.chFromBranch.on = true
        self.lblFromBranch.textColor = "#219CD8".color_
        
        
        UserProfile.shared.tempReceivingMethod = .receiptFromBranch
    }
    
    @IBAction func deliveryAction(_ sender: Any) {
        self.chDelivery.on = true
        self.lbldelivery.textColor = "#219CD8".color_
        
        self.chFromBranch.on = false
        self.lblFromBranch.textColor = .opaqueSeparator
        
        UserProfile.shared.tempReceivingMethod = .delivery
    }
    
    @IBAction func searchAction(_ sender: Any) {
        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "SearchViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnClearFilter(_ sender: Any) {
//        self.txtSearch.text = ""
        self.cityId = nil
        self.dwSelectCity.text = ""
        self.kitchenId = nil
        self.dwSelectRestaurantType.text = ""
        self.isReview = nil
        self.lat = nil
        self.lng = nil
        
        self.getData()
    }
    
}

extension DeliversViewController {
    
    func setupView() {
//        self.txtSearch.delegate = self
        
        UserProfile.shared.tempReceivingMethod = .delivery
        
        self.chDelivery.on = true
        self.lbldelivery.textColor = "#219CD8".color_
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        self.lbldelivery.text = "Delivery".localize_
        self.lblFromBranch.text = "From Branch".localize_
        
        self.allBtn.setTitle("All".localize_, for: .normal)
        
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
        
        self.btnClearFilter.isHidden = true
        
        self.tableView.register(UINib(nibName: "DeliveryTableViewCell", bundle: nil), forCellReuseIdentifier: "DeliveryTableViewCell")
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

}

extension DeliversViewController {
    
    func getData() {
        
        if !( self.cityId != nil || self.kitchenId != nil || self.isReview != nil || self.lat != nil || self.lng != nil) {
            self.btnClearFilter.isHidden = true
        } else {
            self.btnClearFilter.isHidden = false
        }
        
        let request = BaseRequest()
        request.url = GlobalConstants.RESTAURANTS
        request.parameters = ["order_type": "order"]
        request.method = .get
        
        if type == 1 {
            if self.cities.contains(where: {$0.name == self.currentCity}) {
                self.cityId = self.cities.first(where: {$0.name == self.currentCity})?.id
            }
        }
        
        if myLat != nil {
            request.parameters["lat"] = myLat//24.682411
        }
        
        if myLng != nil {
            request.parameters["lng"] = myLng//46.6261111
        }
        
        if self.cityId != nil {
            request.parameters["city"] = self.cityId
        }
        
        if self.kitchenId != nil {
            request.parameters["kitchen"] = self.kitchenId
        }
        
//        if self.txtSearch.isValidValue {
//            request.parameters["name"] = self.txtSearch.text
//        }
        
        request.parameters["review"] = isReview == true ? "desc" : "asc"
        
        if lat != nil {
            request.parameters["lat"] = lat//24.682411
        }
        
        if lng != nil {
            request.parameters["lng"] = lng//46.6261111
        }
        
        RequestBuilder.requestWithSuccessfullRespnose(for: RestaurantModel.self, request: request) { (result) in
            
            if result.status ?? false {
                self.restaurants = result.data?.items?.data ?? []
                print("rrrr \(result.data?.items?.data ?? [])")
                print(self.restaurants)
                if self.type == 2 {
                    self.restaurants = self.restaurants.sorted(by: { $0.userInfo?.distance ?? 0 > $1.userInfo?.distance ?? 0 })
                    print(self.restaurants)

                }
                
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

extension DeliversViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
//        guard self.txtSearch.isValidValue else {
//            return true
//        }
        
        self.view.endEditing(true)
        self.getData()
        
        return true
    }
    
}

extension DeliversViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryTableViewCell", for: indexPath) as! DeliveryTableViewCell
        cell.object = self.restaurants[indexPath.row]
        cell.configureCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "ResturantDetailsViewController") as! ResturantDetailsViewController
        vc.id = self.restaurants[indexPath.row].id
        vc.lat = self.lat
        vc.lng = self.lng
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension DeliversViewController: FSPagerViewDelegate, FSPagerViewDataSource {
    
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

extension DeliversViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
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

extension CLLocation {
    func placemark(completion: @escaping (_ placemark: CLPlacemark?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first, $1) }
    }
}

extension CLPlacemark {
    /// street name, eg. Infinite Loop
    var streetName: String? { thoroughfare }
    /// // eg. 1
    var streetNumber: String? { subThoroughfare }
    /// city, eg. Cupertino
    var city: String? { locality }
    /// neighborhood, common name, eg. Mission District
    var neighborhood: String? { subLocality }
    /// state, eg. CA
    var state: String? { administrativeArea }
    /// county, eg. Santa Clara
    var county: String? { subAdministrativeArea }
    /// zip code, eg. 95014
    var zipCode: String? { postalCode }
    /// postal address formatted
    @available(iOS 11.0, *)
    var postalAddressFormatted: String? {
        guard let postalAddress = postalAddress else { return nil }
        return CNPostalAddressFormatter().string(from: postalAddress)
    }
}
