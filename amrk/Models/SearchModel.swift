//
//  SearchModel.swift
//  amrk
//
//  Created by yousef on 02/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import Foundation

// MARK: - SearchModel
struct SearchModel: Codable {
    let status: Bool?
    let data: SearchData?
}

// MARK: - DataClass
struct SearchData: Codable {
    let restaurants, halas, trainingRooms, weddingRooms: [SearchItem]?
    let message: String?

    enum CodingKeys: String, CodingKey {
        case restaurants, halas
        case trainingRooms = "training_rooms"
        case weddingRooms = "wedding_rooms"
        case message
    }
}

// MARK: - Hala
struct SearchItem: Codable {
    let id, phoneCode: Int?
    let name, email, emailVerifiedAt: String?
    let mobile: Int?
    let apiToken: String?
    let image: String?
    let type: Int?
    let kitchenID: Int?
    let active: Int?
    let mobileToken: Int?
    let createdAt, updatedAt: String?

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
    }
}
