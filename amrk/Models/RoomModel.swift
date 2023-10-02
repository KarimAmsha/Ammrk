//
//  RoomModel.swift
//  amrk
//
//  Created by yousef on 01/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import Foundation

// MARK: - RoomModel
struct RoomModel: Codable {
    let status: Bool?
    let data: RoomData?
}

// MARK: - RoomData
struct RoomData: Codable {
    let items: RoomItems?
    let message: String?
    let slider: [SliderItem]?
}

// MARK: - Items
struct RoomItems: Codable {
    let currentPage: Int?
    let data: [RoomItemData]?
    let firstPageURL: String?
    let from, lastPage: Int?
    let lastPageURL: String?
    let path: String?
    let perPage: Int?
    let to, total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case firstPageURL = "first_page_url"
        case from
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case path
        case perPage = "per_page"
        case to, total
    }
}

// MARK: - RoomItemData
struct RoomItemData: Codable {
    let id, phoneCode: Int?
    let name, email, emailVerifiedAt: String?
    let isFav, favId: Int?
    let userInfo: UserInfo?
    let images: [RoomImages]?
    let offers: [RoomOffers]?
    let mobile: Int?
    let image: String?
    let type: Int?
    let kitchenID: Int?
    let active, mobileToken: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name, email
        case emailVerifiedAt = "email_verified_at"
        case phoneCode = "phone_code"
        case userInfo = "user_info"
        case mobile
        case isFav = "is_fav"
        case favId = "fav_id"
        case image, type
        case kitchenID = "kitchen_id"
        case active
        case mobileToken = "mobile_token"
        case createdAt = "created_at"
        case images, offers
        case updatedAt = "updated_at"
    }
}


// MARK: - Image
struct RoomImages: Codable {
    let id, userID: Int?
    let url: String?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case url
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Offer
struct RoomOffers: Codable {
    let id, userID: Int?
    let name: String?
    let price: Int?
    let createdAt, updatedAt: String?
    let nameTrans: NameTrans?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case name, price
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case nameTrans = "name_trans"
    }
}

// MARK: - NameTrans
struct NameTrans: Codable {
    let ar, en: String?
}
