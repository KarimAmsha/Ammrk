//
//  AddressModel.swift
//  amrk
//
//  Created by yousef on 09/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import Foundation

// MARK: - AddressModel
struct AddressModel: Codable {
    let status: Bool?
    let data: AddressData?
}

// MARK: - AddressData
struct AddressData: Codable {
    let items: [AddressItem]?
    let message: String?
}

// MARK: - AddressItem
struct AddressItem: Codable {
    let id, userID: Int?
    let name, address: String?
    let lat, lng: Double?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case name, address, lat, lng
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
