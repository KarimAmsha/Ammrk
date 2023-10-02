//
//  UpdateProfileModel.swift
//  amrk
//
//  Created by yousef on 10/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import Foundation

// MARK: - UpdateProfileModel
struct UpdateProfileModel: Codable {
    let status: Bool?
    let data: UpdateProfileDate?
}

// MARK: - DataClass
struct UpdateProfileDate: Codable {
    let message, email, mobile: [String]?
}
