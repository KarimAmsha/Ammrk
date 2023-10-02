//
//  UserCityModel.swift
//  amrk
//
//  Created by yousef on 07/10/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import Foundation

// MARK: - UserCityModel
struct UserCityModel: Codable {
    let status: Bool?
    let data: UserCityData?
}

// MARK: - DataClass
struct UserCityData: Codable {
    let city: City?
    let message: String?
}
