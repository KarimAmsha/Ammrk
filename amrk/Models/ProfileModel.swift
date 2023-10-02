//
//  ProfileModel.swift
//  amrk
//
//  Created by yousef on 03/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import Foundation

// MARK: - ProfileModel
struct ProfileModel: Codable {
    let status: Bool?
    let data: ProfileData?
}

// MARK: - ProfileData
struct ProfileData: Codable {
    let user: UserModel?
    let message: String?
}
