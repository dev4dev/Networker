//
//  Rx+Additions.swift
//  Networker
//
//  Created by Alex Antonyuk on 7/12/19.
//  Copyright © 2019 Alex Antonyuk. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper

public extension PrimitiveSequenceType where Trait == SingleTrait, Element == NetworkerResponse<Data> {
    
    /// Use for mapping data to models which adopts Codable protocol. Can be mapped to single object or array of objects
    ///
    /// - Parameter key: Optional. Subkey of data
    /// - Returns: NetworkResponse with mapped object
    func toCodableModel<ObjectType: Decodable>(key: String? = nil) -> PrimitiveSequence<Trait, NetworkerResponse<ObjectType>> {
        return map { data -> NetworkerResponse<ObjectType> in
            if let key = key {
                let json = try data.value.attempToJSON() as? Parameters ?? [:]
                if let dict = json[keyPath: KeyPath(key)] {
                    let objJSON = try JSONSerialization.data(withJSONObject: dict)
                    return data.update(data: try objJSON.attemptToModel() as ObjectType)
                } else {
                    throw "Mapping to \(ObjectType.self) failed"
                }
            } else {
                return data.update(data: try data.value.attemptToModel() as ObjectType)
            }
        }
    }
    
//    func toCodableModelsArray<ObjectType: Decodable>(key: String? = nil) -> PrimitiveSequence<Trait, NetworkerResponse<[ObjectType]>> {
//        return map { data -> NetworkerResponse<[ObjectType]> in
//            if let key = key {
//                let json = try data.value.attempToJSON() as? Parameters ?? [:]
//                if let dict = json[key] {
//                    let objJSON = try JSONSerialization.data(withJSONObject: dict)
//                    return data.update(data: try objJSON.toModel() as [ObjectType])
//                } else {
//                    throw "Mapping to \(ObjectType.self) failed"
//                }
//            } else {
//                return data.update(data: try data.value.toModel() as [ObjectType])
//            }
//        }
//    }
    
    /// Converts data into string
    ///
    /// - Returns: NetworkResponse with data in string representation
    func toString() -> PrimitiveSequence<Trait, NetworkerResponse<String>> {
        return map { data -> NetworkerResponse<String> in
            return data.update(data: String(bytes: data.value, encoding: .utf8) ?? "")
        }
    }
    
    /// Converts data into JSON Dictionary
    ///
    /// - Returns: NetworkResponse with data in JSON representation
    func toJSONDict() -> PrimitiveSequence<Trait, NetworkerResponse<JSONDict>> {
        return map { data -> NetworkerResponse<JSONDict> in
            return data.update(data: (data.value.toJSON() as? JSONDict) ?? [:])
        }
    }
    
    /// Converts data into JSON Array
    ///
    /// - Returns: NetworkResponse with data in JSON representation
    func toJSONArray() -> PrimitiveSequence<Trait, NetworkerResponse<[JSONDict]>> {
        return map { data -> NetworkerResponse<[JSONDict]> in
            return data.update(data: (data.value.toJSON() as? [JSONDict]) ?? [])
        }
    }
    
    func toJSONValue<Type>(key: String) -> PrimitiveSequence<Trait, Type> {
        return map { data -> Type in
            let jsonDict = (data.value.toJSON() as? JSONDict) ?? [:]
            if let value = jsonDict[keyPath: KeyPath(key)] as? Type {
                return value
            } else {
                throw "Value at key \(key) not found"
            }
        }
    }
}

public extension PrimitiveSequenceType where Trait == SingleTrait {
    
    /// Converts response data into void
    /// Handy when response is not important or doesn't exist
    ///
    /// - Returns: Void
    func toVoid() -> PrimitiveSequence<Trait, Void> {
        return map { _ in Void() }
    }
}

public extension PrimitiveSequenceType where Trait == SingleTrait, Element: ValueContainer {
    /// Extracts value from NetworkResponse
    ///
    /// - Returns: Response value
    func toValue() -> PrimitiveSequence<Trait, Element.ValueType> {
        return map { data in
            return data.value
        }
    }
}
