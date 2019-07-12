//
//  MappableSubModel.swift
//  Demo
//
//  Created by Alex Antonyuk on 7/12/19.
//  Copyright © 2019 Alex Antonyuk. All rights reserved.
//

import Foundation
import ObjectMapper

struct MappableSubModel: ImmutableMappable {
    let base: String
    let change: String
    let price: String
    let target: String
    let volume: String
    
    init(map: Map) throws {
        base = try map.value("base")
        change = try map.value("change")
        price = try map.value("price")
        target = try map.value("target")
        volume = try map.value("volume")
    }
    
    mutating func mapping(map: Map) {
        base >>> map["base"]
        change >>> map["change"]
        price >>> map["price"]
        target >>> map["target"]
        volume >>> map["volume"]
    }
}
