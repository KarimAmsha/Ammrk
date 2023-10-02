/*********************		Yousef El-Madhoun		*********************/
//
//  FavoriteViewController.swift
//  amrk
//
//  Created by yousef on 26/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit
import CoreLocation

class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var favorites: [FavoriteItem] = []
    
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
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension FavoriteViewController {
    
    func setupView() {
        self.collectionView.register(UINib(nibName: "FavoriteCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FavoriteCollectionViewCell")
        

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func localized() {
        
    }
    
    func setupData() {
        
    }
    
    func fetchData() {
        self.getData()
    }

}

extension FavoriteViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        if isGetLocation {
            return
        } else {
            isGetLocation = true
        }
        
        self.lat = locValue.latitude
        self.lng = locValue.longitude
        
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
            self.lat = locValue.latitude
            self.lng = locValue.longitude
        }
    }
    
}

extension FavoriteViewController {
    
    func getData() {
        
        let request = BaseRequest()
        request.url = GlobalConstants.FAVORITE
        request.method = .get
        
        RequestBuilder.requestWithSuccessfullRespnose(for: FavoriteModel.self, request: request) { (result) in
            
            if result.status ?? false {
                self.favorites = result.data?.items ?? []
                self.collectionView.reloadData()
            }
            
        }
        
    }
    
}

extension FavoriteViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCollectionViewCell", for: indexPath) as! FavoriteCollectionViewCell
        cell.object = self.favorites[indexPath.row]
        cell.configureCell()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.size.width - 50) / 2
        let height = UIScreen.main.bounds.size.height * 160 / 812
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch self.favorites[indexPath.row].account?.type {
        case 2: // restaurants
            let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "ResturantDetailsViewController") as! ResturantDetailsViewController
            vc.id = self.favorites[indexPath.row].account?.id
            vc.lat = self.lat
            vc.lng = self.lng
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 3: // halas
            let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "HalaDetailsViewController") as! HalaDetailsViewController
            vc.id = self.favorites[indexPath.row].account?.id
            vc.lat = self.lat
            vc.lng = self.lng
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 4: // training_rooms
            let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "HallDetailsViewController") as! HallDetailsViewController
            vc.pageType = .trainingHall
            vc.id = self.favorites[indexPath.row].account?.id
            vc.lat = self.lat
            vc.lng = self.lng
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 5: // wedding rooms"
            let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "HallDetailsViewController") as! HallDetailsViewController
            vc.pageType = .weddingHall
            vc.id = self.favorites[indexPath.row].account?.id
            vc.lat = self.lat
            vc.lng = self.lng
            self.navigationController?.pushViewController(vc, animated: true)
            break
        default:
            break
        }
    }
    
}
