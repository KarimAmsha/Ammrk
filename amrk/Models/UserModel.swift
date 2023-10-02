//
//  UserModel.swift
//  amrk
//
//  Created by yousef on 27/08/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import Foundation

// MARK: - UserModel
struct UserModel: Codable {
    let id: Int?
    let phoneCode, mobile: PhoneCode?
    let name, email, emailVerifiedAt: String?
    let apiToken: String?
    let image: String?
    let type, kitchenID, active: Int?
    let mobileToken: Int?
    var createdAt, updatedAt: String?
    let userInfo: UserInfo?
    let message, errors: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, email, message, errors
        case emailVerifiedAt = "email_verified_at"
        case phoneCode = "phone_code"
        case mobile
        case userInfo = "user_info"
        case apiToken = "api_token"
        case image, type
        case kitchenID = "kitchen_id"
        case active
        case mobileToken = "mobile_token"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

enum PhoneCode: Codable {
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
        throw DecodingError.typeMismatch(Mobile.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for PhoneCode"))
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
