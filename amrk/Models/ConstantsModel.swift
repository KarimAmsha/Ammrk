//
//  ConstantsModel.swift
//  amrk
//
//  Created by yousef on 02/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import Foundation

// MARK: - ConstantsModel
struct ConstantsModel: Codable {
    let status: Bool?
    let data: ConstantsData?
}

// MARK: - ConstantsData
struct ConstantsData: Codable {
    let usersTypes: [String: String]?
    let orderTypes: OrderTypes?
    let orderStatus: OrderStatus?
    let mealsCats, halaCats: [String: String]?
    let cities, kitchens: [City]?
    let androidAppURL, iosAppURL: String?
    let message: String?

    enum CodingKeys: String, CodingKey {
        case usersTypes = "users_types"
        case orderTypes = "order_types"
        case orderStatus = "order_status"
        case mealsCats = "meals_cats"
        case halaCats = "hala_cats"
        case cities, kitchens
        case androidAppURL = "android_app_url"
        case iosAppURL = "ios_app_url"
        case message
    }
}

// MARK: - OrderTypes
struct OrderTypes: Codable {
    let order, reserve, hala, room: String?
    let wedding: String?
}

struct OrderStatus: Codable {
    let the0, the1, the2, the3: String?
    let the4, the5, the31, the32: String?

    enum CodingKeys: String, CodingKey {
        case the0 = "0"
        case the1 = "1"
        case the2 = "2"
        case the3 = "3"
        case the4 = "4"
        case the5 = "5"
        case the31 = "3.1"
        case the32 = "3.2"
    }
}
