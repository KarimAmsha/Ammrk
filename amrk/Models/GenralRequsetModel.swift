//
//  GenralRequsetModel.swift
//  amrk
//
//  Created by yousef on 02/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import Foundation

// MARK: - GenralRequsetModel
struct GenralRequsetModel: Codable {
    let status: Bool?
    let data: GenralRequsetData?
}

// MARK: - GenralRequsetData
struct GenralRequsetData: Codable {
    let message: String?
    let type: String?
}
