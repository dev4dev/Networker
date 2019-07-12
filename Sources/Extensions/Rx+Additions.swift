//
//  Rx+Additions.swift
//  Networker
//
//  Created by Alex Antonyuk on 7/12/19.
//  Copyright © 2019 Alex Antonyuk. All rights reserved.
//

import Foundation
import RxSwift

public extension Observable where Element == Data {
    func toJSON() -> Observable<JSONType> {
        return map { data -> JSONType in
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? JSONType {
                return json
            } else {
                throw "Eror while parsing json data"
            }
        }
    }
    
    func toModel<ObjectType: Decodable>() -> Observable<ObjectType> {
        return map { data -> ObjectType in
            return try data.toModel() as ObjectType
        }
    }
}

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
}
