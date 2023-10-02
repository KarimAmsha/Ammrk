import Foundation
import UIKit
import Alamofire
import SVProgressHUD

class RequestBuilder {
    static let shared = RequestBuilder()
    
    static var headers: HTTPHeaders = []
    
    func updateHeader() {
        
        let language = UserProfile.shared.language?.code ?? "en"
        
        if let user = UserProfile.shared.currentUser {
            RequestBuilder.headers = ["Accept" : "application/json", "Accept-Language" : language, "authorization": "Bearer \(user.apiToken ?? "")"]
        } else {
            RequestBuilder.headers = ["Accept" : "application/json", "Accept-Language" : language]
        }
        
    }
    
    private var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = nil
           while parentResponder != nil {
               parentResponder = parentResponder!.next
               if let viewController = parentResponder as? UIViewController {
                   return viewController
               }
           }
           return nil
       }
    
    class func request(request: BaseRequest, showLoader: Bool = true, success: @escaping (([String : Any]) -> Void), failure: @escaping ((_ error: Error) -> Void)) {
        guard let url = URL.init(string: "\(GlobalConstants.APIV)\(request.url)?lang=\(UserProfile.shared.language?.code ?? "en")") else { return }
        if showLoader {
            self.showLoader(isShowLoader: true)
        }
        if request.files.count > 0 {
//            AF.upload(multipartFormData: { (multi) in
//                for item in request.files {
//                    if let data = item.data {
//                        multi.append(data, withName: item.name ?? "data", fileName: item.fileName, mimeType: "item.type.rawValue")
//                    }
//                }
//                for (key, value) in request.parameters {
//                    if let data = (value as AnyObject).data(using: String.Encoding.utf8.rawValue) {
//                        multi.append(data, withName: key)
//                    }
//                }
//            }, to: url, method: request.method, headers: self.headers, interceptor: nil).uploadProgress { (progress) in
//                self.showLoader(inProgress: progress.fractionCompleted)
//            }.responseData { response in
//                ResponseHandler.responseHandler(response: response, showLoader: showLoader, request: request, url: url, success: success, failure: failure)
//            }
            AF.upload(multipartFormData: { multiPart in
                for (key, value) in request.parameters {
                    if let temp = value as? String {
                        multiPart.append(temp.data(using: .utf8)!, withName: key)
                    }
                    if let temp = value as? Int {
                        multiPart.append("\(temp)".data(using: .utf8)!, withName: key)
                    }
                    if let temp = value as? NSArray {
                        temp.forEach({ element in
                            let keyObj = key + "[]"
                            if let string = element as? String {
                                multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                            } else
                                if let num = element as? Int {
                                    let value = "\(num)"
                                    multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                            }
                        })
                    }
                }
                
                                for item in request.files {
                                    if let data = item.data {
//                                        multi.append(data, withName: item.name ?? "data", fileName: item.fileName, mimeType: item.type.rawValue)
                                        multiPart.append(data, withName: item.name ?? "data", fileName: "file.png", mimeType: "image/png")

                                    }
                                }
            }, to: url, method: request.method, headers: self.headers, interceptor: nil)
                .uploadProgress(queue: .main, closure: { progress in
                    //Current upload progress of file
                    print("Upload Progress: \(progress.fractionCompleted)")
//                                    self.showLoader(inProgress: progress.fractionCompleted)

                })
                .responseData { response in
                                    ResponseHandler.responseHandler(response: response, showLoader: showLoader, request: request, url: url, success: success, failure: failure)
                                }
        } else {
            AF.request(url, method: request.method, parameters: request.parameters, headers: self.headers, interceptor: nil).responseData { (response) in
                ResponseHandler.responseHandler(response: response, showLoader: showLoader, request: request, url: url, success: success, failure: failure)
            }
        }
    }
    
    class func requestWithSuccessfullRespnose<T: Decodable>(for: T.Type = T.self, request: BaseRequest, showLoader: Bool = true, showErrorMessage: Bool = true, success: @escaping ((T) -> Void)) {
        self.request(request: request, showLoader: showLoader, success: { (json) in
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: json)
                let object = try JSONDecoder().decode(T.self, from: jsonData)
                success(object)
            } catch {
                print(error)
            }
        }) { (error) in
            if showErrorMessage {
                print(error)
                RequestBuilder.shared.parentViewController?.showAlertError(message: error.localizedDescription)
            }
        }
    }
    
    class func showLoader(isShowLoader: Bool) {
        if isShowLoader {
            SVProgressHUD.setDefaultMaskType(.custom)
            SVProgressHUD.setForegroundColor("#219CD8".color_)
            SVProgressHUD.setBackgroundColor(UIColor.white)
            SVProgressHUD.show()
        } else {
            SVProgressHUD.dismiss()
        }
    }
    
    class func showLoader(inProgress: Double) {
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setForegroundColor("#219CD8".color_)
        SVProgressHUD.setBackgroundColor(UIColor.white)
        SVProgressHUD.showProgress(Float(inProgress))
    }
}
