//
//  SliderModel.swift
//  amrk
//
//  Created by yousef on 27/08/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import Foundation

// MARK: - SliderModel
struct SliderModel: Codable {
    let status: Bool?
    let data: SliderData?
}

// MARK: - SliderData
struct SliderData: Codable {
    let items: [SliderItem]?
    let message: String?
}

// MARK: - Item
struct SliderItem: Codable {
    let id: Int?
    let name: String?
    let image: String?
    let createdAt, updatedAt: String?
    let imageTrans: ImageTrans?

    enum CodingKeys: String, CodingKey {
        case id, name, image
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case imageTrans = "image_trans"
    }
}
