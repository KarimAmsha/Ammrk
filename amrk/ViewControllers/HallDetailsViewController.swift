/*********************        Yousef El-Madhoun        *********************/
//
//  HallDetailsViewController.swift
//  amrk
//
//  Created by yousef on 31/08/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit

class HallDetailsViewController: UIViewController {
    
    @IBOutlet weak var icFavorite: UIImageView!
    
    @IBOutlet weak var offersTable: UITableView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var icClock: UIImageView!
    
    @IBOutlet weak var imgHall: UIImageView!
    
    @IBOutlet weak var lblRate: UILabel!
    
    @IBOutlet weak var lblRateCount: UILabel!
    
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet weak var lblDistance: UILabel!
    
    @IBOutlet weak var lblDetails: UILabel!
    
    @IBOutlet weak var stMenHall: UIStackView!
    
    @IBOutlet weak var lblMenHall: UILabel!
    
    @IBOutlet weak var stWomenHall: UIStackView!
    
    @IBOutlet weak var lblWomenHall: UILabel!
    
    @IBOutlet weak var coImages: UICollectionView!
    
    @IBOutlet weak var lblMenWomen: UILabel!
    @IBOutlet weak var stMenWomen: UIStackView!
    
    var pageType: HallType?
    
    var id: Int?
    
    var object: RoomItemData?
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
    
    @IBAction func offersAction(_ sender: Any) {
        if UserProfile.shared.language == Language.arabic {
            offersTable.isHidden = true
            coImages.isHidden = false
        } else {
            offersTable.isHidden = false
            coImages.isHidden = true
        }
    }
    
    @IBAction func photosAction(_ sender: Any) {
        if UserProfile.shared.language == Language.arabic {
            offersTable.isHidden = false
            coImages.isHidden = true
        } else {
            offersTable.isHidden = true
            coImages.isHidden = false
        }
    }
    
    
    @IBAction func btnOrderHall(_ sender: Any) {
        
        guard let _ = UserProfile.shared.currentUser else {
            self.showSnackbarMessage(message: "You are not logged in".localize_, isError: true)
            return
        }
        
        switch self.pageType {
        case .weddingHall:
            let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "OrderWeddingHallViewController") as! OrderWeddingHallViewController
            vc.object = self.object
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .trainingHall:
            let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "OrderTrainingHallViewController") as! OrderTrainingHallViewController
            vc.object = self.object
            self.navigationController?.pushViewController(vc, animated: true)
            break
        default:
            break
        }

    }
    
    @IBAction func btnFavorite(_ sender: Any) {
        
        guard let _ = UserProfile.shared.currentUser else {
            self.showSnackbarMessage(message: "You are not logged in".localize_, isError: true)
            return
        }
        
        let request = BaseRequest()
        
        if self.object?.isFav == 1 {
            request.url = "\(GlobalConstants.FAVORITE)/\(self.object?.favId ?? 0)/delete"
            request.method = .get
        } else {
            request.url = GlobalConstants.ADD_FAVORITE
            request.method = .post
            request.parameters = [
                "id": self.object?.id ?? 0,
                "type": "provider"
            ]
        }
        
        RequestBuilder.requestWithSuccessfullRespnose(for: ReviewOrderModel.self, request: request) { (result) in
            
            if result.status ?? false {
                self.fetchData()
            }
            
        }
        
    }
    
    @IBAction func btnShare(_ sender: Any) {
        if let urlStr = NSURL(string: "https://ammrk.com/ar/share/\(self.object?.id ?? 0)?app_id=com.amrk.app") {
            let objectsToShare = [urlStr]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
}

extension HallDetailsViewController {
    
    func setupView() {
        offersTable.delegate = self
        offersTable.dataSource = self
        offersTable.isHidden = true
        offersTable.separatorStyle = .none
        offersTable.register(UINib(nibName: "RoomOffersTableViewCell", bundle: nil), forCellReuseIdentifier: "RoomOffersTableViewCell")
        self.coImages.register(UINib(nibName: "ImageHallCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageHallCollectionViewCell")
        
        if self.pageType == HallType.trainingHall {
            self.stMenHall.isHidden = true
            self.stWomenHall.isHidden = true
            self.stMenWomen.isHidden = true

        }
    }
    
    func localized() {
        
    }
    
    func setupData() {

    }
    
    func fetchData() {
        
        let request = BaseRequest()
        request.url = "\(GlobalConstants.ROOMS)/\(self.id ?? 0)"
        request.method = .get
        
        if let lat = self.lat, let lng = self.lng {
            request.parameters["lat"] = lat
            request.parameters["lng"] = lng
        }
        
        RequestBuilder.requestWithSuccessfullRespnose(for: RoomDetailsModel.self, request: request) { (result) in
            
            if result.status ?? false {
                self.object = result.data?.room
                self.coImages.reloadData()
                self.offersTable.reloadData()
                self.updateData()
            }
            
        }
        
    }

}

extension HallDetailsViewController {
    
    func setTextInLblDetails(text: String) {
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 18
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: NSMakeRange(0, attributedString.length))
        self.lblDetails.attributedText = attributedString
    }
    
    func updateData() {
        
        self.icFavorite.image = self.object?.isFav == 1 ? "icFavorite".image_ : "icUnFavorite".image_
        
        self.lblTitle.text = self.object?.name
        self.imgHall.imageURL(url: self.object?.image ?? "")
        self.lblRate.text = "\(self.object?.userInfo?.review?.rounded(toPlaces: 2) ?? 0)"
        self.lblStatus.text = (self.object?.userInfo?.isOpen == 1 ? "Open".localize_ : "Close".localize_)
        
        self.icClock.imageColor = self.object?.userInfo?.isOpen == 0 ? UIColor.red : UIColor.hexColor(hex: "#008000")
        self.lblStatus.textColor = self.object?.userInfo?.isOpen == 0 ? UIColor.red : UIColor.hexColor(hex: "#008000")
        
        self.lblMenHall.text = "\(self.object?.userInfo?.men?.max ?? 0) \("Person".localize_)"
        self.lblMenWomen.text = "\(self.object?.userInfo?.womenMen?.max ?? 0) \("Person".localize_)"

        self.lblWomenHall.text = "\(self.object?.userInfo?.women?.max ?? 0) \("Person".localize_)"
        self.setTextInLblDetails(text: self.object?.userInfo?.about ?? "")
        self.lblDistance.text = "\((self.object?.userInfo?.distance ?? 0)) \("KM".localize_)"
    }
    
}

extension HallDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.object?.images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = coImages.dequeueReusableCell(withReuseIdentifier: "ImageHallCollectionViewCell", for: indexPath) as! ImageHallCollectionViewCell
        cell.img.sd_setImage(with: URL(string: self.object?.images?[indexPath.row].url ?? ""), completed: nil)
        let pictureTap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        cell.img.addGestureRecognizer(pictureTap)
        cell.img.isUserInteractionEnabled = true
        return cell
    }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (coImages.bounds.size.width / 2) - 20
        return CGSize(width: width, height: width)
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }

    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        sender.view?.removeFromSuperview()
    }
    
}

extension HallDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.object?.offers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RoomOffersTableViewCell", for: indexPath) as? RoomOffersTableViewCell else {
            return UITableViewCell()
        }
        
        cell.titleLbl.text = (self.object?.offers?[indexPath.row].name ?? "") + "               " + "\(self.object?.offers?[indexPath.row].price ?? 0)" + "SAR".localize_
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
