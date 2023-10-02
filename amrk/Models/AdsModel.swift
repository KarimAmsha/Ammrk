//
//  AdsModel.swift
//  amrk
//
//  Created by yousef on 26/08/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import Foundation

// MARK: - AdsModel
struct AdsModel: Codable {
    let status: Bool?
    let data: AdsData?
//    let message: [String]?
}

// MARK: - DataClass
struct AdsData: Codable {
    let items: [AdsItem]?
    let message: MessageUnion?
}

enum MessageUnion: Codable {
    case messageElementArray([String])
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([String].self) {
            self = .messageElementArray(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(MessageUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for MessageUnion"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .messageElementArray(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

// MARK: - MessageElement
struct MessageElement: Codable {
    let message: String?
}

// MARK: - Item
struct AdsItem: Codable {
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

// MARK: - ImageTrans
struct ImageTrans: Codable {
    let ar: String?
    let en: String?
}
