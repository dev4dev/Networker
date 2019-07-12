//
//  Rx+Additions.swift
//  Networker
//
//  Created by Alex Antonyuk on 7/12/19.
//  Copyright © 2019 Alex Antonyuk. All rights reserved.
//

import Foundation
import RxSwift

public extension PrimitiveSequenceType where Trait == SingleTrait, Element == NetworkerResponse<Data> {
    func toModel<ObjectType: Decodable>() -> PrimitiveSequence<Trait, NetworkerResponse<ObjectType>> {
        return map { data -> NetworkerResponse<ObjectType> in
            return data.update(data: try data.value.toModel() as ObjectType)
        }
    }
    
    func toModelsArray<ObjectType: Decodable>() -> PrimitiveSequence<Trait, NetworkerResponse<[ObjectType]>> {
        return map { data -> NetworkerResponse<[ObjectType]> in
            return data.update(data: try data.value.toModelsArray() as [ObjectType])
        }
    }
    
    func toString() -> PrimitiveSequence<Trait, NetworkerResponse<String>> {
        return map { data -> NetworkerResponse<String> in
            return data.update(data: String(bytes: data.value, encoding: .utf8) ?? "")
        }
    }
}
