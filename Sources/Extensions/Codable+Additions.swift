//
//  Codable+Additions.swift
//  Demo
//
//  Created by Alex Antonyuk on 7/11/19.
//  Copyright © 2019 Alex Antonyuk. All rights reserved.
//

import Foundation

public extension Data {
    
    /// Converts data to Decodable model
    ///
    /// - Returns: Optional. Mapped Model
    func toModel<ObjectType: Decodable>() -> ObjectType? {
        return try? JSONDecoder().decode(ObjectType.self, from: self)
    }
    
    /// Converts data to Decodable model
    ///
    /// - Returns: Mapped Model
    /// - Throws: Mapping error
    func attemptToModel<ObjectType: Decodable>() throws -> ObjectType {
        return try JSONDecoder().decode(ObjectType.self, from: self)
    }
}

public extension Encodable {
    
    /// Converts Encodable model to Data
    ///
    /// - Returns: Optional. Data
    func toJSONData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
    
    /// Converts Encodable model to Data
    ///
    /// - Returns: Data
    /// - Throws: Conversion error
    func attempToJSONData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
}

public extension Data {
    
    /// Converts Data to JSON
    ///
    /// - Returns: Optional. JSON
    func toJSON() -> Any? {
        return try? JSONSerialization.jsonObject(with: self, options: [])
    }
    
    /// Converts Data to JSON
    ///
    /// - Returns: JSON
    /// - Throws: JSON Conversion error
    func attempToJSON() throws -> Any {
        return try JSONSerialization.jsonObject(with: self, options: [])
    }
}
