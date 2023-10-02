//
//  ReserveModel.swift
//  amrk
//
//  Created by yousef on 04/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import Foundation

// MARK: - ReserveModel
struct ReserveModel: Codable {
    let status: Bool?
    let data: ReserveData?
}

// MARK: - DataClass
struct ReserveData: Codable {
    let message: String?
    let order: OrderItem?
}
