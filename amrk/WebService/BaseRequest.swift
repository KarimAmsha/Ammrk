import Foundation
import UIKit
import Alamofire

class BaseRequest {
    
    var url: String = ""
    
    var parameters: [String : Any] = [:]
    
    var method: HTTPMethod = .get
    
    var files: [BaseFile] = []
}

