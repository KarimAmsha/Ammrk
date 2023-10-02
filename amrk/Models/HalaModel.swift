//
//  HalaModel.swift
//  amrk
//
//  Created by yousef on 01/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import Foundation

// MARK: - HalaModel
struct HalaModel: Codable {
    let status: Bool?
    let data: HalaData?
}

// MARK: - HalaData
struct HalaData: Codable {
    let items: HalaItems?
    let message: String?
}

// MARK: - HalaItems
struct HalaItems: Codable {
    let currentPage: Int?
    let data: [HalaItemData]?
    let from: Int?
    let path: String?
    let perPage: Int?
    let to, total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case from
        case path
        case perPage = "per_page"
        case to, total
    }
}

// MARK: - Datum
struct HalaItemData: Codable {
    let id, phoneCode: Int?
    let name, email, emailVerifiedAt: String?
    let mobile: Int?
    let image: String?
    let type: Int?
    let kitchenID: Int?
    let active: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name, email
        case emailVerifiedAt = "email_verified_at"
        case phoneCode = "phone_code"
        case mobile
        case image, type
        case kitchenID = "kitchen_id"
        case active
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
