//
//  PageModel.swift
//  amrk
//
//  Created by yousef on 02/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import Foundation

// MARK: - PageModel
struct PageModel: Codable {
    let status: Bool?
    let data: PageData?
}

// MARK: - DataClass
struct PageData: Codable {
    let page: Page?
    let whatsapp: String?
    let facebook, twitter, instagram, youtube: String?
    let address, email, message: String?
}

// MARK: - Page
struct Page: Codable {
    let id: Int?
    let slug, title, content, createdAt: String?
    let updatedAt: String?
    let titleTrans, contentTrans: Trans?

    enum CodingKeys: String, CodingKey {
        case id, slug, title, content
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case titleTrans = "title_trans"
        case contentTrans = "content_trans"
    }
}
