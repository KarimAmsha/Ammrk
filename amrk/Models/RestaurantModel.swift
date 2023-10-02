//
//  RestaurantModel.swift
//  amrk
//
//  Created by yousef on 01/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import Foundation

// MARK: - RestaurantModel
struct RestaurantModel: Codable {
    let status: Bool?
    let data: RestaurantData?
}

// MARK: - DataClass
struct RestaurantData: Codable {
    let items: RestaurantItems?
    let message: String?
    let slider: [SliderItem]?
}

// MARK: - Items
struct RestaurantItems: Codable {
//    let currentPage: Int?
    let data: [RestaurantItem]?
//    let firstPageURL: String?
//    let from, lastPage: Int?
//    let lastPageURL: String?
    let to, total: Int?

    enum CodingKeys: String, CodingKey {
//        case currentPage = "current_page"
        case data
//        case firstPageURL = "first_page_url"
//        case from
//        case lastPage = "last_page"
//        case lastPageURL = "last_page_url"
//        case perPage = "per_page"
        case to, total
    }
}

enum MobileCast: Codable {
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Mobile.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Mobile"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

// MARK: - Datum
struct RestaurantItem: Codable {
    let id, phoneCode: Int?
    let name, email, emailVerifiedAt: String?
    let mobile: MobileCast?
    let apiToken: String?
    let image: String?
    let type, kitchenID, active, mobileToken: Int?
    let createdAt, updatedAt: String?
    let userInfo: UserInfo?
    
    
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
    }
}
