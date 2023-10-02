//
//  Constant.swift
//  amrk
//
//  Created by yousef on 13/08/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import Foundation
import UIKit

enum Language {
    
    case english
    case arabic
    
    var code: String {
        switch self {
        case .english:
            return "en"
        case .arabic:
            return "ar"
        }
    }
    
}

enum ReceivingMethod {
    case delivery
    case receiptFromBranch
}

enum HomeItem {
    
    case bookingTable
    case restaurantDelivers
    case sweets
    case courseHills
    case weddingBase
    case help
    
    var image: String {
        switch self {
        case .bookingTable:
            return "bgResturant"
        case .restaurantDelivers:
            return "bgDelevery"
        case .sweets:
            return "bgSweets"
        case .courseHills:
            return "bgCourseHill"
        case .weddingBase:
            return "bgWeddingHall"
        case .help:
            return "bgHelp"
        }
    }
    
    var title: String {
        switch self {
        case .bookingTable:
            return "Reserve a table".localize_
        case .restaurantDelivers:
            return "Order from the restaurant".localize_
        case .sweets:
            return "Choose your hall".localize_
        case .courseHills:
            return "Book a room".localize_
        case .weddingBase:
            return "Book a hall".localize_
        case .help:
            return "Special orders".localize_
        }
    }
    
    var viewController: String {
        switch self {
        case .bookingTable:
            return "BookingTableViewController"
        case .restaurantDelivers:
            return "DeliversViewController"
        case .sweets:
            return "SweetsViewController"
        case .courseHills:
            return "TrainingRoomsViewController"
        case .weddingBase:
            return "WeddingHallViewController"
        case .help:
            return "HelpOrContactUsViewController"
        }
    }
    
}

enum Menu {
    
    case login
    case serviceProvider
    case orders
    case shareTheApp
    case editProfile
    case email
    case editPassword
    case favorite
    case myAddresses
    case changeLanguage
    case termsOfService
    case privacyPolicy
    case rateApp
    case aboutApp
    case contactUs
    case chargeWallet
    case logout
    
    var image: String {
        switch self {
        case .orders:
            return ""
        case .shareTheApp:
            return "icShare-1"
        case .editProfile:
            return "icEditProfile"
        case .email:
            return "icEditProfile"
        case .favorite:
            return "icFavoriteMenu"
        case .editPassword:
            return "icUpdatePassword"
        case .myAddresses:
            return "icAddresses"
        case .changeLanguage:
            return "icLanguage"
        case .termsOfService:
            return "icTerm"
        case .privacyPolicy:
            return "icPrivacy"
        case .rateApp:
            return "icRatting"
        case .aboutApp:
            return "icAbout"
        case .contactUs:
            return "icContact"
        case .chargeWallet:
            return "icWallet"
        case .logout:
            return "icLogout"
        case .login:
            return "icLogin"
        case .serviceProvider:
            return "icJoinServiceProvieder"
        }
    }
    
    var title: String {
        switch self {
        case .orders:
            return "Orders".localize_
        case .shareTheApp:
            return "Share the app".localize_
        case .editProfile:
            return "Edit Profile".localize_
        case .email:
            return "Email".localize_
        case .editPassword:
            return "Edit Password".localize_
        case .favorite:
            return "Favorite".localize_
        case .myAddresses:
            return "My Addresses".localize_
        case .changeLanguage:
            return "Change Language".localize_
        case .termsOfService:
            return "Terms of Service".localize_
        case .privacyPolicy:
            return "Privacy Policy".localize_
        case .rateApp:
            return "Rate This App".localize_
        case .aboutApp:
            return "About App".localize_
        case .contactUs:
            return "Contact Us".localize_
        case .chargeWallet:
            return "Payment Methods".localize_
        case .logout:
            return "Logout".localize_
        case .login:
            return "Login".localize_
        case .serviceProvider:
            return "Join as a service provider".localize_
        }
    }
    
}

enum HallType {
    case trainingHall
    case weddingHall
}
