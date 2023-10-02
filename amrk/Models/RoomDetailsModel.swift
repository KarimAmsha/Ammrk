//
//  RoomDetailsModel.swift
//  amrk
//
//  Created by yousef on 01/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import Foundation

// MARK: - RoomDetailsModel
struct RoomDetailsModel: Codable {
    let status: Bool?
    let data: RoomDetailsData?
}

// MARK: - RoomDetailsData
struct RoomDetailsData: Codable {
    let room: RoomItemData?
    let message: String?
}

// MARK: - Room
struct Room: Codable {
    let id, phoneCode: Int?
    let name, email, emailVerifiedAt: String?
    let mobile: Int?
    let apiToken: String?
    let image: String?
    let type: Int?
    let kitchenID: Int?
    let active, mobileToken: Int?
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
