//
//  PaymentWebKitViewController.swift
//  amrk
//
//  Created by Mohammed Awad on 22/12/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit
import WebKit

class PaymentWebKitViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    @IBOutlet weak var webKit: WKWebView!
    var paymentUrl: String?
    var activityIndicator: UIActivityIndicatorView!

    var object: OrderItem?
    var callback:(() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webKit.uiDelegate = self
        webKit.navigationDelegate = self
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray

        view.addSubview(activityIndicator)
        
        if let paymentUrlStr = paymentUrl {
            if let url = URL(string: paymentUrlStr) {
                let request = URLRequest(url: url)
                webKit.load(request)
            }
        }
    }
    
    func showActivityIndicator(show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }


    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showActivityIndicator(show: true)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showActivityIndicator(show: false)
    }
    
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        showActivityIndicator(show: false)
        webView.evaluateJavaScript("document.getElementsByTagName('pre')[0].innerHTML", completionHandler: { (res, error) in
             if let fingerprint = res {
                  // Fingerprint will be a string of JSON. Parse here...
                  print(fingerprint)
                 do {
                     
                     if let json = (fingerprint as! String).data(using: String.Encoding.utf8){
                           if let jsonData = try JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [String:AnyObject]{
                               let status = jsonData["status"] as! Bool
                               let messages = jsonData["message"] as! [String]
                               
                               print(status)
                               print(messages[0])

                               if status {
                                   let vc1 = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "MainTabbarViewController")
                                   let vc2 = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "OrderDetailsViewController") as! OrderDetailsViewController
                                   vc2.object = self.object
                                   vc2.isFromOrders = false
                                   self.navigationController?.setViewControllers([vc1, vc2], animated: true)
                               } else {
                                   if messages.count > 0 {
                                       self.showSnackbarMessage(message: messages[0] , isError: true)
                                       self.navigationController?.popViewController(animated: true)
                                       self.callback?()

                                   }
                               }
                           }
                       }

                 } catch  {
                     print("having trouble converting it to a dictionary" , error)
                 }
             }
        })
            
    }
    

    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.callback?()

    }
    
}


struct WebKitResponse : Codable {

    let status: Bool?
    let message: [String]?
}
