/*********************		Yousef El-Madhoun		*********************/
//
//  SearchViewController.swift
//  amrk
//
//  Created by yousef on 15/08/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class SearchViewController: UIViewController {
    
    @IBOutlet weak var txtSearch: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    var headerItems: [String] = []
    
    var result: [[SearchItem]] = []
    
    var isSearch = false
    
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

extension SearchViewController {
    
    func setupView() {
        self.txtSearch.delegate = self
        
        self.tableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
    }
    
    func localized() {
        
    }
    
    func setupData() {
        
    }
    
    func fetchData() {
        
    }

}

extension SearchViewController {
    
    func search() {
        
        self.headerItems.removeAll()
        self.result.removeAll()
        
        let request = BaseRequest()
        request.url = GlobalConstants.SEARCH
        request.method = .get
        
        request.parameters = ["search" : self.txtSearch.text ?? ""]
        
        RequestBuilder.requestWithSuccessfullRespnose(for: SearchModel.self, request: request) { (result) in
            
            if result.status ?? false {
                
                if result.data?.restaurants?.count ?? 0 > 0 {
                    self.headerItems.append("Restaurants".localize_)
                    self.result.append(result.data?.restaurants ?? [])
                }
                
                if result.data?.halas?.count ?? 0 > 0 {
                    self.headerItems.append("Halas".localize_)
                    self.result.append(result.data?.halas ?? [])
                }
                
                if result.data?.trainingRooms?.count ?? 0 > 0 {
                    self.headerItems.append("Training Rooms".localize_)
                    self.result.append(result.data?.trainingRooms ?? [])
                }
                
                if result.data?.weddingRooms?.count ?? 0 > 0 {
                    self.headerItems.append("Wedding Rooms".localize_)
                    self.result.append(result.data?.weddingRooms ?? [])
                }
                
                self.tableView.reloadData()
            }
            
        }
        
    }
    
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return result.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            if section < headerItems.count {
            return headerItems[section]
        }

        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionCell = SearchHeader()
        sectionCell.title = headerItems[section]
        return sectionCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        cell.object = result[indexPath.section][indexPath.row]
        cell.configureCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = self.result[indexPath.section][indexPath.row]
        
        guard let user = UserProfile.shared.currentUser, user.type != 2 else {
            return
        }
        
        switch object.type {
        case 2: // restaurants
            let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "ResturantDetailsViewController") as! ResturantDetailsViewController
            vc.id = object.id
            vc.lat = self.lat
            vc.lng = self.lng
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 3: // halas
            let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "HalaDetailsViewController") as! HalaDetailsViewController
            vc.id = object.id
            vc.lat = self.lat
            vc.lng = self.lng
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 4: // training_rooms
            let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "HallDetailsViewController") as! HallDetailsViewController
            vc.pageType = .trainingHall
            vc.id = object.id
            vc.lat = self.lat
            vc.lng = self.lng
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 5: // wedding rooms"
            let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "HallDetailsViewController") as! HallDetailsViewController
            vc.pageType = .weddingHall
            vc.id = object.id
            vc.lat = self.lat
            vc.lng = self.lng
            self.navigationController?.pushViewController(vc, animated: true)
            break
        default:
            break
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard !(self.txtSearch.text?.isEmpty ?? true) else {
            return true
        }
        
        self.isSearch = true
        self.view.endEditing(true)
        self.search()
        
        return true
    }
    
}

extension SearchViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return "icEmptySearch".image_
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let emptyTitle = !isSearch ? "Search for any restaurant, hala or hall".localize_ : "No result".localize_
        
        return NSAttributedString.init(string: emptyTitle, attributes: [NSAttributedString.Key.font : UIFont(name: "NeoSansArabic", size: 16) ?? UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.opaqueSeparator])
    }
    
    func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 20
    }
    
}
