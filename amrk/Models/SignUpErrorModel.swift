//
//  SignUpErrorModel.swift
//  amrk
//
//  Created by Yousef El-Madhoun on 21/08/2022.
//  Copyright © 2022 yousef. All rights reserved.
//

import Foundation

// MARK: - SignUpErrorModel
struct SignUpErrorModel: Codable {
    let status: Bool?
    let data: SignUpErrorData?
}

// MARK: - ReviewOrderData
struct SignUpErrorData: Codable {
    let message: [String]?
}
