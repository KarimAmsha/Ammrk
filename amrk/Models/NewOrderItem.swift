//
//  NewOrderItem.swift
//  amrk
//
//  Created by yousef on 09/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import Foundation

struct NewOrderItem {
    var order: RestaurantMenuItem?
    var orderHala: HalaMenuItem?
    var removes: [Int]?
    var additions: [Int]?
    var quantity: Int?
    var additionsPrice: Double?
}
