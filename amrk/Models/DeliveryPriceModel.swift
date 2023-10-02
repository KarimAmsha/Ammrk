//
//  DeliveryPriceModel.swift
//  amrk
//
//  Created by yousef on 11/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import Foundation

// MARK: - DeliveryPriceModel
struct DeliveryPriceModel: Codable {
    let status: Bool?
    let data: DeliveryPriceData?
}

// MARK: - DeliveryPriceData
struct DeliveryPriceData: Codable {
    let message: String?
    let order: DeliveryPriceDataOrder?
}

// MARK: - Order
struct DeliveryPriceDataOrder: Codable {
    let deliveryPrice: Int?

    enum CodingKeys: String, CodingKey {
        case deliveryPrice = "delivery_price"
    }
}

