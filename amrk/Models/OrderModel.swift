//
//  OrderModel.swift
//  amrk
//
//  Created by yousef on 08/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import Foundation

// MARK: - OrderModel
struct OrderModel: Codable {
    let status: Bool?
    let data: OrderData?
}

// MARK: - DataClass
struct OrderData: Codable {
    let items: OrderItems?
    let message: String?
}

struct OrderDetailsModel: Codable {
    let status: Bool?
    let data: OrderDetails?
}

struct OrderDetails: Codable {
    let order: OrderItem?
    let message: String?
}

// MARK: - Items
struct OrderItems: Codable {
    let currentPage: Int?
    let data: [OrderItem]?
    let firstPageURL: String?
    let from, lastPage: Int?
    let lastPageURL: String?
    let nextPageURL, path: String?
    let perPage: Int?
    let to, total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case firstPageURL = "first_page_url"
        case from
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case nextPageURL = "next_page_url"
        case path
        case perPage = "per_page"
        case to, total
    }
}

// MARK: - Datum
struct OrderItem: Codable {
    let id, userID: Int?
    let providerID: ProviderID?
    let type: String?
    let mobile: Mobile?
    let price: Int?
    let branchID, discountCode: Int?
    let persons: ProviderID?
    let districtID: ProviderID?
    let ownerName: String?
    let ownerCompanyName, ownerEmail: String?
    let time: String?
    let details: String?
    let status: ProviderID?
    let rejectReason, payType: String?
    let paid, delivery: ProviderID?
    let coffeeBreak: ProviderID?
    let address: String?
    let timeSection: String?
    let orderData: [OrderItemData]?
    let personsType: String?
    let kosha, screens, videoAndPhoto: ProviderID?
    let review: ProviderID?
    let createdAt, updatedAt: String?
    let statusName: String?
    let typeName: String?
    let products: [ProductOrder]?
    let provider: OrderProvider?
    let branch: Branch?
    let coupon: Coupon?
    let userAddress: OrderUserAddress?
    let paymentInfo: PaymentInfo?
    let user: OrderUser?
    
    enum CodingKeys: String, CodingKey {
        case id
        case providerID = "provider_id"
        case userID = "user_id"
        case type, price
        case branchID = "branch_id"
        case districtID = "district_id"
        case persons, coupon
        case ownerName = "owner_name"
        case ownerCompanyName = "owner_company_name"
        case ownerEmail = "owner_email"
        case time, mobile, user
        case discountCode = "discount_code"
        case details, status
        case rejectReason = "reject_reason"
        case payType = "pay_type"
        case paid, delivery
        case coffeeBreak = "coffee_break"
        case address
        case timeSection = "time_section"
        case orderData = "order_data"
        case personsType = "persons_type"
        case kosha, screens
        case videoAndPhoto = "video_and_photo"
        case review
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case statusName = "status_name"
        case typeName = "type_name"
        case products, provider, branch
        case userAddress = "user_address"
        case paymentInfo = "payment_info"
    }
}

struct OrderUser: Codable {
    let id: Int?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
    }
}

// MARK: - CouponData
struct Coupon: Codable {
    let id, code, amount: Int?
    let type: String?
    let limits: String?
    let useCount: Int?
    let updatedAt, createdAt: String?
    let deletedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, code, amount, type, limits
        case useCount = "use_count"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case deletedAt = "deleted_at"
    }
}

enum Mobile: Codable {
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

// MARK: - PaymentInfo
struct PaymentInfo: Codable {
    let productsPrice, deliveryPrice, servicePrice, total, discountPrice: Double?

    enum CodingKeys: String, CodingKey {
        case productsPrice = "products_price"
        case deliveryPrice = "delivery_price"
        case servicePrice = "service_price"
        case discountPrice = "discount_price"
        case total
    }
}

struct OrderUserAddress: Codable {
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

enum ProviderID: Codable {
    case double(Double)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Double.self) {
            self = .double(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(ProviderID.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ProviderID"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .double(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}
// MARK: - OrderDatum
struct OrderItemData: Codable {
    let id, qnt: Int?
}

// MARK: - Product
struct ProductOrder: Codable {
    let id, userID: Int?
    let name, productDescription: String?
    let price: Int?
    let quantity: Int?
    let image: String?
    let type: Int?
    let createdAt: String?
    let updatedAt: String?
    let nameTrans, descriptionTrans: Trans?
    let orderData: OrderProductData?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case name
        case productDescription = "description"
        case price, quantity, image, type
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case nameTrans = "name_trans"
        case descriptionTrans = "description_trans"
        case orderData = "order_data"
    }
}

struct OrderProductData: Codable {
    let id, qnt: Int
}

// MARK: - Provider
struct OrderProvider: Codable {
    let id: Int?
    let name: String?
    let email: String?
    let emailVerifiedAt: String?
    let phoneCode, mobile: Int?
    let image: String?
    let type, kitchenID, active: Int?
    let mobileToken: Int?
    let createdAt: String?
    let updatedAt: String?
    let userInfo: UserInfo?

    enum CodingKeys: String, CodingKey {
        case id, name, email
        case emailVerifiedAt = "email_verified_at"
        case phoneCode = "phone_code"
        case mobile, image, type
        case kitchenID = "kitchen_id"
        case active
        case mobileToken = "mobile_token"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case userInfo = "user_info"
    }
}
