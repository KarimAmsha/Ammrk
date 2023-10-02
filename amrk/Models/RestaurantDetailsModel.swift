//
//  RestaurantDetailsModel.swift
//  amrk
//
//  Created by yousef on 01/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import Foundation

// MARK: - RestaurantDetailsModel
struct RestaurantDetailsModel: Codable {
    let status: Bool?
    let data: RestaurantDetailsData?
}

// MARK: - RestaurantDetailsData
struct RestaurantDetailsData: Codable {
    var restaurant: RestaurantDetails?
    let items: [RestaurantCategory]?
    let message: String?
}

// MARK: - RestaurantCategory
struct RestaurantCategory: Codable {
    let id: Int?
    let name: String?
    let items: [RestaurantMenuItem]?
}

// MARK: - ItemItem
struct RestaurantMenuItem: Codable {
    let id, userID: Int?
    let name, itemDescription: String?
    var quantity, price: Int?
    let image: String?
    let type: Int?
    let createdAt, updatedAt: String?
    let additions, removes: [Addition]?
    let nameTrans, descriptionTrans: Trans?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case name
        case itemDescription = "description"
        case price, quantity, image, type
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case additions, removes
        case nameTrans = "name_trans"
        case descriptionTrans = "description_trans"
    }
}

// MARK: - Addition
struct Addition: Codable {
    let id, price, productID: Int?
    let name, createdAt, updatedAt: String?
    let nameTrans: Trans?

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case name, price
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case nameTrans = "name_trans"
    }
}

// MARK: - Trans
struct Trans: Codable {
    let ar, en: String?
}

// MARK: - RestaurantDetails
struct RestaurantDetails: Codable {
    let id, phoneCode, mobile: Int?
    let name, email, emailVerifiedAt: String?
    let apiToken: String?
    let image: String?
    var type, kitchenID, active, isFav, favId: Int?
    let mobileToken: Int?
    let createdAt, updatedAt: String?
    let userInfo: UserInfo?
    let branches: [Branch]?
    let kitchen: Kitchen?
    let reservedTimes: [ReservedTimes]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, email
        case emailVerifiedAt = "email_verified_at"
        case phoneCode = "phone_code"
        case mobile
        case apiToken = "api_token"
        case image, type
        case kitchenID = "kitchen_id"
        case active
        case mobileToken = "mobile_token"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case userInfo = "user_info"
        case branches, kitchen
        case reservedTimes = "reserved_times"
        case isFav = "is_fav"
        case favId = "fav_id"
    }
}

struct ReservedTimes: Codable {
    let date: String?
    let times: [String]?
}

// MARK: - Branch
struct Branch: Codable {
    let id, userID, cityID: Int?
    let state: String?
    let address: String?
    let createdAt, updatedAt: String?
    let distance: Double?
    let lat, lng: Double?
    let city: Kitchen?
    let stateTrans: Trans?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case cityID = "city_id"
        case state, address, lat, lng
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case distance, city
        case stateTrans = "state_trans"
    }
}

// MARK: - Kitchen
struct Kitchen: Codable {
    let id: Int?
    let name, createdAt, updatedAt: String?
    let nameTrans: Trans?

    enum CodingKeys: String, CodingKey {
        case id, name
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case nameTrans = "name_trans"
    }
}

// MARK: - UserInfo
struct UserInfo: Codable {
    let id: Int?
    let providerID: Int?
    let tradePhoto, ibanPhoto: String?
    let address: String?
    let lat, lng: Double?
    let location, policy: String?
    let about, features: String?
    let cityID: Int?
    let timeSection, reasonTxt: String?
    let womenMen, women, men: PersonData?
    let review: Double?
    let open, isOpen: Int?
    let createdAt, updatedAt: String?
    let distance, discount: Double?
    let isAd: Int?
    let openFrom, openTo: String?
    let reserveCost: Double?
    
    enum CodingKeys: String, CodingKey {
        case id, discount
        case openFrom = "open_from"
        case openTo = "open_to"
        case providerID = "provider_id"
        case tradePhoto = "trade_photo"
        case ibanPhoto = "iban_photo"
        case address, location, lat, lng, about, features, policy
        case timeSection = "time_section"
        case cityID = "city_id"
        case women, men
        case reserveCost = "reserve_cost"
        case womenMen = "women_men"
        case reasonTxt = "reason_txt"
        case review
        case open
        case isOpen = "is_open"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case distance
        case isAd = "is_ad"
    }
}

// MARK: - PersonData
struct PersonData: Codable {
    let max: Int?
    let price: Int?
}

