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
    func toCodableModel<ObjectType: Decodable>(key: String? = nil) -> PrimitiveSequence<Trait, NetworkerResponse<ObjectType>> {
        return map { data -> NetworkerResponse<ObjectType> in
            if let key = key {
                let json = try data.value.attempToJSON() as? Parameters ?? [:]
                if let dict = json[key] {
                    let objJSON = try JSONSerialization.data(withJSONObject: dict)
                    return data.update(data: try objJSON.toModel() as ObjectType)
                } else {
                    throw "Mapping to \(ObjectType.self) failed"
                }
            } else {
                return data.update(data: try data.value.toModel() as ObjectType)
            }
        }
    }
    
    func toCodableModelsArray<ObjectType: Decodable>(key: String? = nil) -> PrimitiveSequence<Trait, NetworkerResponse<[ObjectType]>> {
        return map { data -> NetworkerResponse<[ObjectType]> in
            if let key = key {
                let json = try data.value.attempToJSON() as? Parameters ?? [:]
                if let dict = json[key] {
                    let objJSON = try JSONSerialization.data(withJSONObject: dict)
                    return data.update(data: try objJSON.toModel() as [ObjectType])
                } else {
                    throw "Mapping to \(ObjectType.self) failed"
                }
            } else {
                return data.update(data: try data.value.toModel() as [ObjectType])
            }
        }
    }
    
    func toString() -> PrimitiveSequence<Trait, NetworkerResponse<String>> {
        return map { data -> NetworkerResponse<String> in
            return data.update(data: String(bytes: data.value, encoding: .utf8) ?? "")
        }
    }
    
    func toJSON() -> PrimitiveSequence<Trait, NetworkerResponse<Parameters>> {
        return map { data -> NetworkerResponse<Parameters> in
            return data.update(data: (data.value.toJSON() as? Parameters) ?? [:])
        }
    }
}

public extension PrimitiveSequenceType where Trait == SingleTrait {
    func toVoid() -> PrimitiveSequence<Trait, Void> {
        return map { _ in Void() }
    }
}

public extension PrimitiveSequenceType where Trait == SingleTrait, Element: ValueContainer {
    func toValue() -> PrimitiveSequence<Trait, Element.ValueType> {
        return map { data in
            return data.value
        }
    }
}
