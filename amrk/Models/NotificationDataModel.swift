//
//  NotificationDataModel.swift
//  amrk
//
//  Created by Yousef El-Madhoun on 07/09/2022.
//  Copyright © 2022 yousef. All rights reserved.
//

import Foundation

// MARK: - NotificationDataModel
struct NotificationDataModel: Codable {
    let message, type, orderID: String?

    enum CodingKeys: String, CodingKey {
        case message, type
        case orderID = "order_id"
    }
}
