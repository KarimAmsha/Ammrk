//
//  ReviewOrderModel.swift
//  amrk
//
//  Created by yousef on 13/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import Foundation

// MARK: - ReviewOrderModel
struct ReviewOrderModel: Codable {
    let status: Bool?
    let data: ReviewOrderData?
}

// MARK: - ReviewOrderData
struct ReviewOrderData: Codable {
    let message: String?
}
