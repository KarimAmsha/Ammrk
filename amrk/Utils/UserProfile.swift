//
//  UserProfile.swift
//  amrk
//
//  Created by yousef on 26/08/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import Foundation

class UserProfile {
    
    static let shared = UserProfile()
    
    var tempReceivingMethod: ReceivingMethod?
    
    var language: Language? {
        set {
            UserDefaults.standard.set(newValue?.code, forKey: "language")
        } get {
            let lang = UserDefaults.standard.string(forKey: "language")
            return lang == nil ? nil : lang == "ar" ? Language.arabic : Language.english
        }
    }
    
    var isOpenApp: Bool? {
        set {
            UserDefaults.standard.set(newValue, forKey: "is-open-app")
        } get {
            return UserDefaults.standard.bool(forKey: "is-open-app")
        }
    }
    
    var fcmToken: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: "fcm-token")
        } get {
            return UserDefaults.standard.string(forKey: "fcm-token")
        }
    }
    
    var currentUser: UserModel? {
        set {
            guard newValue != nil else {
                UserDefaults.standard.removeObject(forKey: "current-user")
                return
            }

            let encodedData = try? PropertyListEncoder().encode(newValue)
            UserDefaults.standard.set(encodedData, forKey: "current-user")
            UserDefaults.standard.synchronize()
        } get {
            if let data = UserDefaults.standard.value(forKey: "current-user") as? Data {
                return try? PropertyListDecoder().decode(UserModel.self, from: data)
            }

            return nil
        }
    }
    
    var constantsData: ConstantsData? {
        set {
            guard newValue != nil else {
                UserDefaults.standard.removeObject(forKey: "constants-data")
                return
            }

            let encodedData = try? PropertyListEncoder().encode(newValue)
            UserDefaults.standard.set(encodedData, forKey: "constants-data")
            UserDefaults.standard.synchronize()
        } get {
            if let data = UserDefaults.standard.value(forKey: "constants-data") as? Data {
                return try? PropertyListDecoder().decode(ConstantsData.self, from: data)
            }

            return nil
        }
    }
    
}
