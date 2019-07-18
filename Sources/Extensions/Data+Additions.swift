//
//  Data+Additions.swift
//  Networker
//
//  Created by Alex Antonyuk on 7/18/19.
//  Copyright © 2019 Alex Antonyuk. All rights reserved.
//

import Foundation

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
    
    /// Converts Data to JSON Dict
    ///
    /// - Returns: Optional. JSON Dict
    func toJSONDict() -> JSONDict? {
        return try? JSONSerialization.jsonObject(with: self, options: []) as? JSONDict
    }
    
    /// Converts Data to JSON Dict
    ///
    /// - Returns: JSON Dict
    /// - Throws: JSON Conversion error
    func attempToJSONDict() throws -> JSONDict {
        if let json = try JSONSerialization.jsonObject(with: self, options: []) as? JSONDict {
            return json
        } else {
            throw "JSON is not of a dictionary type"
        }
    }
    
    /// Converts Data to JSON Array
    ///
    /// - Returns: Optional. JSON Array
    func toJSONArray() -> [JSONDict]? {
        return try? JSONSerialization.jsonObject(with: self, options: []) as? [JSONDict]
    }
    
    /// Converts Data to JSON Array
    ///
    /// - Returns: JSON Array
    /// - Throws: JSON Conversion error
    func attempToJSONArray() throws -> [JSONDict] {
        if let json = try JSONSerialization.jsonObject(with: self, options: []) as? [JSONDict] {
            return json
        } else {
            throw "JSON is not of an array type"
        }
    }
}
