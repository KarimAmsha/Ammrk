/*********************		Yousef El-Madhoun		*********************/
//
//  AddOrEditAddressViewController.swift
//  amrk
//
//  Created by yousef on 09/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit
import GoogleMaps

class AddOrEditAddressViewController: UIViewController {
    
    @IBOutlet weak var map: GMSMapView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var txtTitle: UITextField!
    
    @IBOutlet weak var txtAddress: UITextField!
    
    @IBOutlet weak var btnAddOrEdit: UIButton!
    
    enum TypePage {
        case add
        case edit
    }
    
    var typePage: TypePage = .add
    
    var object: AddressItem?
    
    var callback: (() -> Void)?
    
    let marker = GMSMarker()
    
    let locationManager = CLLocationManager()
    
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
    
    @IBAction func btnAddOrEdit(_ sender: Any) {
        
        guard validation() else {
            return
        }
        
        let request = BaseRequest()
        request.url = typePage == TypePage.edit ? "\(GlobalConstants.ADDRESSES)/\(self.object?.id ?? 0)/edit" : GlobalConstants.ADD_ADDRESSES
        request.method = .post
        
        request.parameters = [
            "name": self.txtTitle.text ?? "",
            "address": self.txtAddress.text ?? "",
            "lat": self.marker.position.latitude,
            "lng": self.marker.position.longitude,
        ]
        
        RequestBuilder.requestWithSuccessfullRespnose(for: AddressModel.self, request: request) { (result) in
            
            if result.status ?? false {
                let title = self.typePage == TypePage.edit ? "The address has been modified successfully".localize_ : "The address has been added successfully".localize_
                self.showSnackbarMessage(message: title, isError: false)
                self.callback?()
                self.dismiss(animated: true, completion: nil)
            } else {
                self.showSnackbarMessage(message: "Something happened! Please try again later".localize_, isError: true)
            }
            
        }
        
    }
    
}

extension AddOrEditAddressViewController {
    
    func setupView() {

        self.map.delegate = self

        self.marker.map = self.map
        
        locationManager.delegate = self

        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
            self.map.isMyLocationEnabled = true
            self.map.settings.myLocationButton = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        
        if let obj = object {
            self.typePage = .edit
            self.txtTitle.text = obj.name
            self.txtAddress.text = obj.address
            
            let lat = CLLocationDegrees(floatLiteral: Double(obj.lat ?? 0))
            let lng = CLLocationDegrees(floatLiteral: Double(obj.lng ?? 0))
            
            marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            
            map.camera = GMSCameraPosition(
            target: CLLocationCoordinate2D(latitude: lat, longitude: lng),
            zoom: 15,
            bearing: 0,
            viewingAngle: 0)
        }
        
        switch self.typePage {
        case .add:
            self.lblTitle.text = "Add New Address".localize_
            self.btnAddOrEdit.setTitle("Add Address".localize_, for: .normal)
            break
        case .edit:
            self.lblTitle.text = "Edit Address".localize_
            self.btnAddOrEdit.setTitle("Edit Address".localize_, for: .normal)
            break
        }
        
        self.txtAddress.isEnabled = false
    }
    
    func localized() {
        
    }
    
    func setupData() {
        
    }
    
    func fetchData() {
        
    }

}

extension AddOrEditAddressViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.reverseGeocode(coordinate: coordinate)
        marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
}

extension AddOrEditAddressViewController: CLLocationManagerDelegate {

      func locationManager(
        _ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus
      ) {
        
        guard status == .authorizedWhenInUse else {
          return
        }
     
        locationManager.requestLocation()
        map.isMyLocationEnabled = true
        map.settings.myLocationButton = true
      }


      func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
          return
        }


        if self.object == nil {
            map.camera = GMSCameraPosition(
            target: location.coordinate,
            zoom: 15,
            bearing: 0,
            viewingAngle: 0)
        }
        
      }


      func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
      ) {
        print(error)
      }
    
}


extension AddOrEditAddressViewController {
    
    func reverseGeocode(coordinate: CLLocationCoordinate2D) {
      let geocoder = GMSGeocoder()

      geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
        guard
          let address = response?.firstResult(),
          let lines = address.lines
          else {
            return
        }

        self.txtAddress.text = lines.joined(separator: "\n")

        UIView.animate(withDuration: 0.25) {
          self.view.layoutIfNeeded()
        }
      }
    }
    
    func validation() -> Bool {
        
        guard self.marker.position.longitude != -180 else {
            self.showSnackbarMessage(message: "Please select the location on the map".localize_, isError: true)
            return false
        }
        
        guard let _ = self.txtTitle.text, self.txtTitle.isValidValue else {
            self.showSnackbarMessage(message: "Title field is required".localize_, isError: true)
            return false
        }
        
        guard let _ = self.txtAddress.text, self.txtAddress.isValidValue else {
            self.showSnackbarMessage(message: "Address field is required".localize_, isError: true)
            return false
        }
        
        return true
    }
    
}
