//
//  UpdatePasswordModel.swift
//  amrk
//
//  Created by yousef on 10/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import Foundation

// MARK: - UpdatePasswordModel
struct UpdatePasswordModel: Codable {
    let status: Bool?
    let data: UpdatePasswordData?
}

// MARK: - UpdatePasswordData
struct UpdatePasswordData: Codable {
    let message: [String]?
}
