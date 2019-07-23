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
    func toMappableModel<ObjectType: BaseMappable>(key: String? = nil, context: MapContext? = nil) -> PrimitiveSequence<Trait, NetworkerResponse<ObjectType>> {
        return toString().toMappableModel(key: key, context: context)
    }
    
    func toMappableModelsArray<ObjectType: BaseMappable>(key: String? = nil, context: MapContext? = nil) -> PrimitiveSequence<Trait, NetworkerResponse<[ObjectType]>> {
        return toString().toMappableModelsArray(key: key, context: context)
    }
}

public extension PrimitiveSequenceType where Trait == SingleTrait, Element == NetworkerResponse<String> {
    func toMappableModel<ObjectType: BaseMappable>(key: String? = nil, context: MapContext? = nil) -> PrimitiveSequence<Trait, NetworkerResponse<ObjectType>> {
        return map { data -> NetworkerResponse<ObjectType> in
            if let key = key, let dict = data.value.toJSONDict(), let json = dict[keyPath: KeyPath(key)] as? JSONDict {
                if let model = Mapper<ObjectType>(context: context).map(JSON: json) {
                    return data.update(data: model)
                }
            } else {
                if let model = Mapper<ObjectType>(context: context).map(JSONString: data.value) {
                    return data.update(data: model)
                }
            }

            throw "Mapping to \(ObjectType.self) failed"
        }
    }
    
    func toMappableModelsArray<ObjectType: BaseMappable>(key: String? = nil, context: MapContext? = nil) -> PrimitiveSequence<Trait, NetworkerResponse<[ObjectType]>> {
        return map { data -> NetworkerResponse<[ObjectType]> in
            if let key = key {
                if let dict = data.value.toJSONDict(), let arr = dict[keyPath: KeyPath(key)] as? [JSONDict] {
                    let models = arr.compactMap { Mapper<ObjectType>(context: context).map(JSON: $0) }
                    return data.update(data: models)
                }
            } else if let arr = data.value.toJSONArray() {
                let models = arr.compactMap { Mapper<ObjectType>(context: context).map(JSON: $0) }
                return data.update(data: models)
            }
            throw "Mapping to [\([ObjectType].self)] failed"
        }
    }
}
