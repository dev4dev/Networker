//
//  MappableModel.swift
//  Demo
//
//  Created by Alex Antonyuk on 7/12/19.
//  Copyright © 2019 Alex Antonyuk. All rights reserved.
//

import Foundation
import ObjectMapper

struct MappableModel: ImmutableMappable {
    let base: String
    let change: String
    let price: String
    let target: String
    let volume: String

    init(map: Map) throws {
        base = try map.value("ticker.base")
        change = try map.value("ticker.change")
        price = try map.value("ticker.price")
        target = try map.value("ticker.target")
        volume = try map.value("ticker.volume")
    }
    
    mutating func mapping(map: Map) {
        base >>> map["ticker.base"]
        change >>> map["ticker.change"]
        price >>> map["ticker.price"]
        target >>> map["ticker.target"]
        volume >>> map["ticker.volume"]
    }
}
