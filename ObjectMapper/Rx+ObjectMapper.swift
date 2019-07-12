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

public extension PrimitiveSequenceType where Trait == SingleTrait, Element == NetworkerResponse<String> {
    func toModel<ObjectType: BaseMappable>(key: String? = nil) -> PrimitiveSequence<Trait, NetworkerResponse<ObjectType>> {
        return map { data -> NetworkerResponse<ObjectType> in
            if let key = key, let dict = data.value.toJSONDict(), let json = dict[key] as? [String: Any] {
                if let model = Mapper<ObjectType>().map(JSON: json) {
                    return data.update(data: model)
                } else {
                    throw "Mapping to \(ObjectType.self) failed"
                }
            } else {
                if let model = Mapper<ObjectType>().map(JSONString: data.value) {
                    return data.update(data: model)
                } else {
                    throw "Mapping to \(ObjectType.self) failed"
                }
            }
        }
    }
    
    func toModelsArray<ObjectType: BaseMappable>(key: String) -> PrimitiveSequence<Trait, NetworkerResponse<[ObjectType]>> {
        return map { data -> NetworkerResponse<[ObjectType]> in
            if let dict = data.value.toJSONDict(), let arr = dict[key] as? [[String: Any]] {
                let models = arr.compactMap { Mapper<ObjectType>().map(JSON: $0) }
                return data.update(data: models)
            } else {
                throw "Mapping to [\([ObjectType].self)] failed"
            }
        }
    }
}
