//
//  CancelOrderModel.swift
//  amrk
//
//  Created by yousef on 11/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import Foundation

// MARK: - CancelOrderModel
struct CancelOrderModel: Codable {
    let status: Bool?
    let data: CancelOrderData?
}

// MARK: - DataClass
struct CancelOrderData: Codable {
    let message: String?
}
