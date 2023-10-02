//
//  GenralModel.swift
//  amrk
//
//  Created by yousef on 27/08/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import Foundation

// MARK: - GenralModel
struct GenralModel: Codable {
    let status: Bool?
    let data: GenralData?
}

// MARK: - GenralData
struct GenralData: Codable {
    let message: [String]?
}


// MARK: - StatusModel
struct StatusModel: Codable {
    let status: Bool?
    let data: StatusStruct?
}

// MARK: - DataClass
struct StatusStruct: Codable {
    let message: String?
}
