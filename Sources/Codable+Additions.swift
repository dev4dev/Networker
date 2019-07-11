//
//  Codable+Additions.swift
//  Demo
//
//  Created by Alex Antonyuk on 7/11/19.
//  Copyright © 2019 Alex Antonyuk. All rights reserved.
//

import Foundation

public extension Data {
    func toModel<ObjectType: Decodable>() -> ObjectType? {
        return try? JSONDecoder().decode(ObjectType.self, from: self)
    }
    
    func toModel<ObjectType: Decodable>() throws -> ObjectType {
        return try JSONDecoder().decode(ObjectType.self, from: self)
    }
}

public extension Encodable {
    func toJSONData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}

public extension Data {
    func toJSON() -> Any? {
        return try? JSONSerialization.jsonObject(with: self, options: [])
    }
}
