//
//  LogoutModel.swift
//  amrk
//
//  Created by yousef on 03/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import Foundation

// MARK: - LogoutModel
struct LogoutModel: Codable {
    let status: Bool?
    let data: LogoutData?
}

// MARK: - DataClass
struct LogoutData: Codable {
    let message: String?
}
