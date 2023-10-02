/*********************		Yousef El-Madhoun		*********************/
//
//  OrderDetailsViewController.swift
//  amrk
//
//  Created by yousef on 06/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit
import MapKit
import Cosmos
import MOLH

class OrderDetailsViewController: UIViewController {
    
    @IBOutlet weak var stName: UIStackView!
    
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var lblServiceType: UILabel!
    @IBOutlet weak var resName: UILabel!
    
    @IBOutlet weak var payAlertStack: UIStackView!
    @IBOutlet weak var lblOrderID: UILabel!
    
    @IBOutlet weak var lblOrderDate: UILabel!
    
    @IBOutlet weak var lblOrderStatus: UILabel!
    
    @IBOutlet weak var stReason: UIStackView!
    
    @IBOutlet var lblBtnLocation: UILabel!
    
    @IBOutlet weak var lblReason: UILabel!
    
    @IBOutlet weak var stRate: UIStackView!
    
    @IBOutlet weak var vwRate: CosmosView!
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var btnBottomButton: UIButton!
    
    @IBOutlet weak var payNowBtn: UIButton!
    
    var object: OrderItem?
    
    var orderId: Int?
    
    var isFromOrders = true
    
    var isOpenReview = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if object != nil {
            setupView()
        } else {
            fetchOrderDetails()
        }
        
        localized()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func payNowAction(_ sender: Any) {

        
        let url = "https://ammrk.com/api/payment/\(self.object?.id ?? 0)?api_token=\(UserProfile.shared.currentUser?.apiToken ?? "")"
        print(url)
        let vc =  UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "PaymentWebKitViewController") as! PaymentWebKitViewController
        vc.paymentUrl = url
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    @IBAction func btnOrderDetails(_ sender: Any) {
        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "MoreDetailsOrderViewController") as! MoreDetailsOrderViewController
        vc.object = self.object
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnOpenMap(_ sender: Any) {
        
        var tempLat: Double?
        var tempLng: Double?
        
        if let lat = self.object?.branch?.lat, let lng = self.object?.branch?.lng {
            tempLat = lat
            tempLng = lng
        } else if let lat = self.object?.provider?.userInfo?.lat, let lng = self.object?.provider?.userInfo?.lng {
            tempLat = lat
            tempLng = lng
        } else if let lat = self.object?.userAddress?.lat, let lng = self.object?.userAddress?.lng {
            tempLat = lat
            tempLng = lng
        }
        
        if let lat = tempLat, let lng = tempLng {
            let latitude:CLLocationDegrees =  lat
            let longitude:CLLocationDegrees =  lng
            
            let regionDistance:CLLocationDistance = 10000
            let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
            let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
            ]
            let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = "\(self.object?.provider?.name ?? "")"
            mapItem.openInMaps(launchOptions: options)
        }
        
    }
    
    @IBAction func btnBottomButton(_ sender: Any) {
        if let sts = self.object?.status {
            switch sts {
            case .double(let x):
                if x == 0 {
                    self.cancelOrder()
                    return
                }
            case .string(let x):
                if x == "0" {
                    self.cancelOrder()
                    return
                }
                
            }
            
            let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "RateServiceViewController") as! RateServiceViewController
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .overFullScreen
            vc.idOrder = self.object?.id
            vc.callback = { rate in
                self.stRate.isHidden = false
                self.vwRate.rating = rate
                self.btnBottomButton.isHidden = true
            }
            self.present(vc, animated: true, completion: nil)
            
            
        }
    }
    
}

extension OrderDetailsViewController {
    
    func setupView() {
        self.lblServiceType.text = self.object?.typeName

        if let name = self.object?.provider?.name {
            self.resName.text = name
        } else {
            self.stName.isHidden = true
        }
                
        self.lblOrderID.text = "#\(self.object?.id ?? 0)"
        self.lblOrderDate.text = self.object?.time
        self.statusView.layer.cornerRadius = 8
        self.lblOrderStatus.textColor = .white
        var status: Double = -1
        
        switch self.object?.status {
        case .double(let x):
            status = x
        case .string(let x):
            status = Double(x)!
        case .none:
            status = -1
        }
        
        self.payNowBtn.isHidden = true
        payAlertStack.isHidden = true
        
//        if self.object?.paid == nil {
//            if (object?.type == "room" || object?.type == "wedding") {
//                self.payNowBtn.isHidden = true
//                payAlertStack.isHidden = true
//            } else {
//                self.payNowBtn.isHidden = false
//                payNowBtn.setTitle("Pay Now".localize_, for: .normal)
//                payAlertStack.isHidden = false
//            }
//
//        } else {
//            self.payNowBtn.isHidden = true
//            payAlertStack.isHidden = true
//
//        }
        
        if object?.type == "room" || object?.type == "wedding" {
            self.lblBtnLocation.text = "Hall location".localize_
        } else {
            self.lblBtnLocation.text = "Restaurant location".localize_
        }
        
        var statusTitle = ""
        
        switch status {
        case 0:
            statusTitle = "The request has been sent".localize_
            self.statusView.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
            break
        case 1:
            statusTitle = "Order accepted".localize_
            self.statusView.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)

            break
        case 2:
            statusTitle = "The request is being processed".localize_
            self.statusView.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            break
        case 3:
            statusTitle = "Order ready".localize_
            self.statusView.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            break
        case 3.1:
            statusTitle = "The order is being delivered".localize_
            self.statusView.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            break
        case 3.2:
            
            if object?.type == "room" || object?.type == "wedding" || object?.type == "reserve" {
                statusTitle = "Order accepted".localize_
            } else {
                statusTitle = "The order has been delivered".localize_
            }
            
            self.statusView.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            break
        case 4:
            statusTitle = "The request is rejected".localize_
            self.statusView.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            break
        case 5:
            statusTitle = "Order Canceled".localize_
            self.statusView.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            break
        default:
            break
        }
        
        self.lblOrderStatus.text = statusTitle
        
        if let rejectReason = self.object?.rejectReason, rejectReason != "" {
            self.stReason.isHidden = false
            self.lblReason.text = rejectReason
        } else {
            self.stReason.isHidden = true
        }
        
        if let review = self.object?.review {
            self.stRate.isHidden = false
            switch review {
            case .double(let x):
                self.vwRate.rating = Double(x)
            case .string(let x):
                self.vwRate.rating = Double(x) ?? 0

           
            }
            
        } else {
            self.stRate.isHidden = true
        }
        
        var tempLat: Double?
        var tempLng: Double?
        
        if let lat = self.object?.branch?.lat, let lng = self.object?.branch?.lng {
            tempLat = lat
            tempLng = lng
        } else if let lat = self.object?.provider?.userInfo?.lat, let lng = self.object?.provider?.userInfo?.lng {
            tempLat = lat
            tempLng = lng
        } else if let lat = self.object?.userAddress?.lat, let lng = self.object?.userAddress?.lng {
            tempLat = lat
            tempLng = lng
        }
        
        
        if let lat = tempLat, let lng = tempLng {
            
            let userCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            let eyeCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            let mapCamera = MKMapCamera(lookingAtCenter: userCoordinate, fromEyeCoordinate: eyeCoordinate, eyeAltitude: 400.0)
            map.setCamera(mapCamera, animated: true)
            
            let marker = MKPointAnnotation.init()
            marker.coordinate = CLLocationCoordinate2D.init(latitude: lat, longitude: lng)
            
            marker.title = self.object?.provider?.name
            map.addAnnotation(marker)
        }
        
        if status == 0 {
            self.btnBottomButton.backgroundColor = .red
            self.btnBottomButton.setTitle("Cancel Order".localize_, for: .normal)
            
            let dateOrder = self.object?.createdAt?.toDate(customFormat: "YYYY-MM-dd h:mm a") ?? Date()
            
            let dateAfterThreeMin = Calendar.current.date(byAdding: .minute, value: -3, to: Date()) ?? Date()
            
            if dateAfterThreeMin.compare(dateOrder).rawValue != -1 {
                self.btnBottomButton.isHidden = true
            } else {
                self.btnBottomButton.isHidden = false
            }
            
            
        } else if status == 3 {
            if object?.review == nil {
                self.btnBottomButton.isHidden = false
                self.btnBottomButton.backgroundColor = "#219CD8".color_
                self.btnBottomButton.setTitle("Rate Order".localize_, for: .normal)
            } else {
                self.btnBottomButton.isHidden = true
            }
        } else {
            self.btnBottomButton.isHidden = true
        }
        
    }
    
    func localized() {
        
    }
    
    func setupData() {
        
    }
    
    func fetchOrderDetails() {
                
        let request = BaseRequest()
        
        
        let orderID = orderId != nil ? orderId : object?.id
        
        request.url = "\(GlobalConstants.ORDER)/\(orderID ?? 0)"
        request.method = .get
        
        
        request.parameters["lang"] = MOLHLanguage.currentAppleLanguage()

        
        RequestBuilder.requestWithSuccessfullRespnose(for: OrderDetailsModel.self, request: request) { (result) in
            
            if result.status ?? false {
                self.object = result.data?.order
                self.setupView()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    if self.isOpenReview {
                        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "RateServiceViewController") as! RateServiceViewController
                        vc.modalTransitionStyle = .coverVertical
                        vc.modalPresentationStyle = .overFullScreen
                        vc.idOrder = self.object?.id
                        vc.callback = { rate in
                            self.stRate.isHidden = false
                            self.vwRate.rating = rate
                            self.btnBottomButton.isHidden = true
                        }
                        self.present(vc, animated: true, completion: nil)
                    }
                }
                
            }
            
        }
    }

}

extension OrderDetailsViewController {
    
    func cancelOrder() {
        self.showAlertPopUp(title: "Cancel Order".localize_, message: "Are you sure cancel order?".localize_, buttonTitle1: "Cancel Order".localize_, buttonTitle2: "Cancel".localize_, action1: {
            
            let request = BaseRequest()
            request.url = "\(GlobalConstants.ORDER)/\(self.object?.id ?? 0)/cancel"
            request.method = .get
            
            RequestBuilder.requestWithSuccessfullRespnose(for: CancelOrderModel.self, request: request) { (result) in
                
                if result.status ?? false {
                    self.showSnackbarMessage(message: "Order canceled successfully".localize_, isError: false)
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.showSnackbarMessage(message: "Something happened! Please try again later".localize_, isError: true)
                }
                
            }
            
        }) {
            
        }
    }
    
}
