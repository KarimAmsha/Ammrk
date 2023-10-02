//
//  CouponModel.swift
//  amrk
//
//  Created by Mohammed Awad on 13/02/2022.
//  Copyright © 2022 yousef. All rights reserved.
//

import Foundation

// MARK: - CouponResponse
struct CouponResponse: Codable {
    let status: Bool?
    let data: couponModel?
}

// MARK: - DataClass
struct couponModel: Codable {
    let message: String?
    let order: CouponData?
}

// MARK: - Order
struct CouponData: Codable {
    let id, amount: Int?
    let code, type: String?
    let limits: String?
    let useCount: Int?
    let updatedAt: String?
    let createdAt: String?
    let deletedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, code, amount, type, limits
        case useCount = "use_count"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case deletedAt = "deleted_at"
    }
}
