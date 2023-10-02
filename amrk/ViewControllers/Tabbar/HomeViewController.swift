/*********************		Yousef El-Madhoun		*********************/
//
//  HomeViewController.swift
//  rukn2
//
//  Created by yousef on 08/06/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit
import FSPagerView
import SwiftMessages
import CoreLocation

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var lblTitle: UILabel!
    
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
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var sliderItems: [SliderItem] = []
    
    let servicesList: [HomeItem] = [.bookingTable, .restaurantDelivers, .sweets, .courseHills, .weddingBase, .help]
    
    let locationManager = CLLocationManager()
    
    var isGetLocation = false

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
    
    @IBAction func btnSearch(_ sender: Any) {
        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        vc.lat = self.lat
        vc.lng = self.lng
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension HomeViewController {
    
    func setupView() {
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        if let currentUser = UserProfile.shared.currentUser {
            self.lblTitle.text = "\("Welcome".localize_) \(currentUser.name ?? "")"
            self.updateFcmTocken()
        }
        
        self.collectionView.register(UINib(nibName: "HomeServiceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeServiceCollectionViewCell")
    }
    
    func localized() {
        
    }
    
    func setupData() {
        
    }
    
    func fetchData() {
        self.getSliderData()
        self.getConstantsData()
        self.checkUserIsLogged()
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
        
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
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
            
            
            let location = CLLocation(latitude: self.lat ?? 0, longitude: self.lng ?? 0)
            location.placemark { placemark, error in
                guard let placemark = placemark else {
                    print("Error:", error ?? "nil")
                    return
                }
                print(placemark.postalAddressFormatted ?? "")
                print(placemark.city ?? "")
            }
        }
    }

}

extension HomeViewController {
    
    func getSliderData() {
        let request = BaseRequest()
        request.url = GlobalConstants.SLIDER
        request.method = .get
        
        RequestBuilder.requestWithSuccessfullRespnose(for: SliderModel.self, request: request) { (result) in
            
            if result.status ?? false {
                if result.data?.items?.count ?? 0 > 0 {
                    self.sliderItems = result.data?.items ?? []
                    self.pagerView.reloadData()
                    self.pageControll.numberOfPages = result.data?.items?.count ?? 0
                    self.pageControll.currentPage = 0
                }
            }
            
        }
    }
    
    func getConstantsData() {
        let request = BaseRequest()
        request.url = GlobalConstants.CONSTANTS
        request.method = .get
        
        RequestBuilder.requestWithSuccessfullRespnose(for: ConstantsModel.self, request: request) { (result) in
            
            if result.status ?? false {
                UserProfile.shared.constantsData = result.data
            }
            
        }
    }
    
    func checkUserIsLogged() {
        let request = BaseRequest()
        request.url = GlobalConstants.PROFILE
        request.method = .get
        
        RequestBuilder.requestWithSuccessfullRespnose(for: ProfileModel.self, request: request) { (result) in
            
            if result.data?.user == nil {
                UserProfile.shared.currentUser = nil
                RequestBuilder.shared.updateHeader()
            }
            
        }
    }
    
}

extension HomeViewController {
    
    func updateFcmTocken() {
        
        guard let fcmToken = UserProfile.shared.fcmToken else {
            return
        }
        
        let request = BaseRequest()
        request.url = GlobalConstants.UPDATE_PROFILE
        request.method = .post
        request.parameters = [
            "push_token": fcmToken,
        ]
        
        RequestBuilder.requestWithSuccessfullRespnose(for: UpdateProfileModel.self, request: request, showLoader: false) { (_) in
            
        }
        
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return servicesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeServiceCollectionViewCell", for: indexPath) as! HomeServiceCollectionViewCell
        cell.object = servicesList[indexPath.row]
        cell.configureCell()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.size.width - 30) / 2
        let height = UIScreen.main.bounds.size.height * 145 / 812
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch servicesList[indexPath.row] {
        case .bookingTable:
            let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "BookingTableViewController") as! BookingTableViewController
            vc.myLat = self.lat
            vc.myLng = self.lng
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .restaurantDelivers:
            let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "DeliversViewController") as! DeliversViewController
            vc.myLat = self.lat
            vc.myLng = self.lng
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .sweets:
            let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "SweetsViewController") as! SweetsViewController
            vc.myLat = self.lat
            vc.myLng = self.lng
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .courseHills:
            let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "TrainingRoomsViewController") as! TrainingRoomsViewController
            vc.myLat = self.lat
            vc.myLng = self.lng
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .weddingBase:
            let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "WeddingHallViewController") as! WeddingHallViewController
            vc.myLat = self.lat
            vc.myLng = self.lng
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .help:
            let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: servicesList[indexPath.row].viewController)
            self.navigationController?.pushViewController(vc, animated: true)
            break
        }
        
    }
    
}

extension HomeViewController: FSPagerViewDelegate, FSPagerViewDataSource {
    
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
