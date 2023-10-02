//
//  DeleteAccountModel.swift
//  amrk
//
//  Created by Yousef El-Madhoun on 21/08/2022.
//  Copyright © 2022 yousef. All rights reserved.
//

import Foundation

// MARK: - DeleteAccountModel
struct DeleteAccountModel: Codable {
    let status: Bool?
    let data: DeleteAccountData?
}

// MARK: - DeleteAccountData
struct DeleteAccountData: Codable {
    let message: String?
}
