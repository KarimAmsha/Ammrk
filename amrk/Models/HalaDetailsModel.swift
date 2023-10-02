//
//  HalaDetailsModel.swift
//  amrk
//
//  Created by yousef on 02/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import Foundation

// MARK: - HalaDetailsModel
struct HalaDetailsModel: Codable {
    let status: Bool?
    let data: HalaDetailsData?
}

// MARK: - HalaDetailsData
struct HalaDetailsData: Codable {
    var hala: Hala?
    let items: [HalaCategory]?
    let message: String?
}

// MARK: - Hala
struct Hala: Codable {
    let id, phoneCode: Int?
    let name, email, emailVerifiedAt: String?
    let mobile: Int?
    let apiToken: String?
    let image: String?
    var type, isFav, favId: Int?
    let kitchenID: Int?
    let active, mobileToken: Int?
    let createdAt, updatedAt: String?
    let userInfo: UserInfo?
    let branches: [Branch]?

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
        case branches
        case isFav = "is_fav"
        case favId = "fav_id"
    }
}

// MARK: - City
struct City: Codable {
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

// MARK: - HalaCategories
struct HalaCategory: Codable {
    let id: Int?
    let name: String?
    let items: [HalaMenuItem]?
}

// MARK: - ItemItem
struct HalaMenuItem: Codable {
    let id, userID, price: Int?
    let name, itemDescription: String?
    let quantity: Int?
    let image: String?
    let type: Int?
    let createdAt, updatedAt: String?
    let nameTrans, descriptionTrans: Trans?
    let additions, removes: [Addition]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case name
        case itemDescription = "description"
        case price, quantity, image, type
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case nameTrans = "name_trans"
        case additions, removes
        case descriptionTrans = "description_trans"
    }
}
