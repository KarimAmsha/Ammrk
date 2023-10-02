
import Foundation
import Alamofire

class ResponseHandler {
    static let shared = ResponseHandler()
    
    static func responseHandler(response: AFDataResponse<Data>, showLoader: Bool = true, request: BaseRequest, url: URL ,success: @escaping (([String : Any]) -> Void), failure: @escaping ((_ error: Error) -> Void)) {
        debugPrint("************************* Request *************************")
        debugPrint("The url: \(url.absoluteString)")
        RequestBuilder.showLoader(isShowLoader: false)
        switch response.result {
            case .success(let data):
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    debugPrint("Methods: \(request.method.rawValue)")
                    debugPrint("************************* Request *************************")
                    success(json as! [String : Any])
                } catch(let error) {
                    debugPrint(error.localizedDescription)
                    failure(error)
                }
                break
            case .failure(let error):
                debugPrint(error.localizedDescription)
                failure(error)
                break
        }
    }
}
