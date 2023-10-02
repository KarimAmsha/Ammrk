//
//  LoginModel.swift
//  amrk
//
//  Created by yousef on 27/08/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import Foundation

// MARK: - LoginModel
struct LoginModel: Codable {
    let status: Bool?
    let data: UserModel?
}


// MARK: - RegisterModel
struct RegisterModel: Codable {
    let status: Bool?
    let data: RegisterData?
}

// MARK: - RegisterData
struct RegisterData: Codable {
    let message: String?
    let user: UserModel?
}
