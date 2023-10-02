//
//  Logger.swift
//  amrk
//
//  Created by Yousef El-Madhoun on 28/12/2022.
//  Copyright © 2022 yousef. All rights reserved.
//

import Foundation

enum LoggerType: String {
    case success = "🟩"
    case info = "🟪"
    case warning = "🟨"
    case error = "🟥"
    case none
}

class Logger {
    static let shared = Logger()
    
    private init(){}
    
    func debugPrint(
        _ message: Any,
        extra1: String = #file,
        extra2: String = #function,
        extra3: Int = #line,
        remoteLog: Bool = false,
        plain: Bool = false,
        loggerType: LoggerType = .none
    ) {
        
        var prefix: String = ""
        
        if loggerType != .none {
            prefix = "\(loggerType.rawValue) "
        }
                
        if plain {
            Swift.debugPrint("\(prefix)\(message)")
        } else {
            let filename = (extra1 as NSString).lastPathComponent
            Swift.debugPrint("\(prefix)\(message)", "[\(filename) \(extra3) line]")
        }
        
        // if remoteLog is true record the log in server
        if remoteLog {
//            if let msg = message as? String {
//                logEvent(msg, event: .error, param: nil)
//            }
        }
    }
    
    /// pretty print
    func prettyPrint(_ message: Any) {
        dump(message)
    }
    
    func printDocumentsDirectory() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        Swift.print("Document Path: \(documentsPath)")
    }
    
    /// Track event to firebse
    func logEvent(_ name: String? = nil, event: String? = nil, param: [String: Any]? = nil) {
       
        // Analytics.logEvent(name, parameters: param)
    }
}
