//
//  FavoriteModel.swift
//  amrk
//
//  Created by yousef on 26/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import Foundation

// MARK: - FavoriteModel
struct FavoriteModel: Codable {
    let status: Bool?
    let data: FavoriteData?
}

// MARK: - DataClass
struct FavoriteData: Codable {
    let items: [FavoriteItem]?
    let message: String?
}

// MARK: - Item
struct FavoriteItem: Codable {
    let id, userID, accountID: Int?
    let accountType, createdAt, updatedAt: String?
    let account: Account?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case accountID = "account_id"
        case accountType = "account_type"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case account
    }
}

// MARK: - Account
struct Account: Codable {
    let id, phoneCode: Int?
    let name, email, emailVerifiedAt: String?
    let mobile: Int?
    let image: String?
    let type: Int?
//    let kitchenID: Int?
    let active: Int?
//    let mobileToken: String?
    let createdAt, updatedAt: String?
    let isFav: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, email
        case emailVerifiedAt = "email_verified_at"
        case phoneCode = "phone_code"
        case mobile, image, type
//        case kitchenID = "kitchen_id"
        case active
//        case mobileToken = "mobile_token"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case isFav = "is_fav"
    }
}
