//
//  NotificationModel.swift
//  amrk
//
//  Created by yousef on 03/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import Foundation

// MARK: - NotificationModel
struct NotificationModel: Codable {
    let status: Bool?
    let data: NotificationData?
}

// MARK: - DataClass
struct NotificationData: Codable {
    let items: NotificationItems?
    let message: String?
}

// MARK: - NotificationItems
struct NotificationItems: Codable {
    let currentPage: Int?
    let data: [NotificationItem]?
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

// MARK: - NotificationItem
struct NotificationItem: Codable {
    let id, userID, orderID: Int?
    let message: String?
    let createdAt, updatedAt: String?
    let order: OrderItem?
    let messageTrans: MessageTrans?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case orderID = "order_id"
        case message
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case order
        case messageTrans = "message_trans"
    }
}

// MARK: - MessageTrans
struct MessageTrans: Codable {
    let ar, en: String?
}

// MARK: - Order
struct Order: Codable {
    let id, providerID, userID: Int?
    let type, price: String?
    let branchID: Int?
    let districtID: Int?
    let persons: Int?
    let ownerName: String?
    let ownerCompanyName, ownerEmail: String?
    let time, mobile: String?
    let discountCode, details: String?
    let status: Int?
    let rejectReason: String?
    let payType, paid, delivery, coffeeBreak: String?
    let address: String?
    let timeSection: String?
    let orderData, personsType, kosha, screens: String?
    let createdAt, updatedAt, statusName: String?

    enum CodingKeys: String, CodingKey {
        case id
        case providerID = "provider_id"
        case userID = "user_id"
        case type, price
        case branchID = "branch_id"
        case districtID = "district_id"
        case persons
        case ownerName = "owner_name"
        case ownerCompanyName = "owner_company_name"
        case ownerEmail = "owner_email"
        case time, mobile
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
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case statusName = "status_name"
    }
}
