//
//  Model.swift
//  Demo
//
//  Created by Alex Antonyuk on 7/5/19.
//  Copyright © 2019 Alex Antonyuk. All rights reserved.
//

import Foundation

struct Model: Codable {
    let base: String
    let change: String
    let price: String
    let target: String
    let volume: String
    
    enum CodingKeys: String, CodingKey {
        case ticker
        case base
        case change
        case price
        case target
        case volume
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let ticker = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .ticker)
        
        base = try ticker.decode(String.self, forKey: .base)
        change = try ticker.decode(String.self, forKey: .change)
        price = try ticker.decode(String.self, forKey: .price)
        target = try ticker.decode(String.self, forKey: .target)
        volume = try ticker.decode(String.self, forKey: .volume)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        var ticker = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .ticker)
        try ticker.encode(base, forKey: .base)
        try ticker.encode(change, forKey: .change)
        try ticker.encode(price, forKey: .price)
        try ticker.encode(target, forKey: .target)
        try ticker.encode(volume, forKey: .volume)
    }
    
}
