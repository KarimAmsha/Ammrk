/*********************		Yousef El-Madhoun		*********************/
//
//  FilterViewController.swift
//  amrk
//
//  Created by yousef on 02/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit
import BEMCheckBox
import Cosmos
import SwiftLocation

class FilterViewController: UIViewController {
    
    @IBOutlet weak var chByLocation: BEMCheckBox!
    
    @IBOutlet weak var lblNearest: UILabel!
    @IBOutlet weak var chnearest: BEMCheckBox!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var chCity: BEMCheckBox!
    @IBOutlet weak var lblByLocation: UILabel!
    
    @IBOutlet weak var chByRating: BEMCheckBox!
    
    @IBOutlet weak var lblByRating: UILabel!
    
    var type = 3
    
    // 1: city, 2: nearest, 3: location, 4: review
    var callback: ((_ lat: Double?, _ lng: Double?, _ isReview: Bool?,  _ type: Int?) -> Void)?
    
    var isReview: Bool?
    
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
    
    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nearestAction(_ sender: Any) {
        if self.chnearest.on {
            self.chnearest.on = false
            self.lblNearest.textColor = .opaqueSeparator
        } else {
            self.lblNearest.textColor = "#219CD8".color_
            self.chnearest.on = true
            self.type = 2
        }
    }
    
    @IBAction func cityAction(_ sender: Any) {
        if self.chCity.on {
            self.chCity.on = false
            self.cityLbl.textColor = .opaqueSeparator
        } else {
            self.cityLbl.textColor = "#219CD8".color_
            self.chCity.on = true
            self.type = 1
        }
    }
    
    @IBAction func btnByLocation(_ sender: Any) {
        
        if self.chByLocation.on {
            self.chByLocation.on = false
            self.lblByLocation.textColor = .opaqueSeparator
            self.lat = nil
            self.lng = nil
        } else {
            
            LocationManager.shared.locateFromGPS(.continous, accuracy: .city) { result in
              switch result {
                case .failure(_):
                    self.showSnackbarMessage(message: "We couldn't locate you".localize_, isError: true)
                case .success(let location):
                self.chByLocation.on = true
                self.type = 3
                self.lblByLocation.textColor = "#219CD8".color_
                  self.lat = location.coordinate.latitude
                  self.lng = location.coordinate.longitude
              }
            }
            
        }
        
    }
    
    @IBAction func btnByRating(_ sender: Any) {
        if self.chByRating.on {
            self.chByRating.on = false
            self.lblByRating.textColor = .opaqueSeparator
            self.isReview = nil
        } else {
            self.chByRating.on = true
            self.lblByRating.textColor = "#219CD8".color_
            self.isReview = true
            self.type = 4
        }
    }
    
    @IBAction func btnFilter(_ sender: Any) {
        self.callback?(lat, lng, self.isReview ,type)
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension FilterViewController {
    
    func setupView() {
        
        cityLbl.text = "My City".localize_
        lblNearest.text = "Nearest".localize_
        
        if self.lat != nil && self.lng != nil {
            self.chByLocation.on = true
            self.lblByLocation.textColor = "#219CD8".color_
        }
        
        if self.isReview != nil {
            self.chByRating.on = true
        }
        
    }
    
    func localized() {
        
    }
    
    func setupData() {
        
    }
    
    func fetchData() {
        
    }

}
