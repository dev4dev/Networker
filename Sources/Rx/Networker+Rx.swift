//
//  Networker+Rx.swift
//  Networker
//
//  Created by Alex Antonyuk on 7/11/19.
//  Copyright © 2019 Alex Antonyuk. All rights reserved.
//

import Foundation
import RxSwift

public extension Networker {
    func requestData(url: URL, method: HTTPMethod, parameters: [String: Any] = [:], options: [Option] = []) -> Single<Data> {
        return Single.create { s in
            let request = self.requestData(url: url, method: method, parameters: parameters, options: options, completion: { result in
                switch result {
                case .success(let data):
                    s(.success(data))
                case .failure(let error):
                    s(.error(error))
                }
            })
            return Disposables.create {
                request.cancel()
            }
        }
    }

    func requestData(request: URLRequest) -> Single<Data> {
        return Single.create { s in
            let request = self.requestData(request: request, completion: { result in
                switch result {
                case .success(let data):
                    s(.success(data))
                case .failure(let error):
                    s(.error(error))
                }
            })
            return Disposables.create {
                request.cancel()
            }
        }
    }
}

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
            if let model = data.toModel() as ObjectType? {
                return model
            } else {
                throw "Error during object mapping"
            }
        }
    }
}
