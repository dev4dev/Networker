//
//  Networker+Rx.swift
//  Networker
//
//  Created by Alex Antonyuk on 7/11/19.
//  Copyright © 2019 Alex Antonyuk. All rights reserved.
//

import Foundation
import RxSwift

public extension Reactive where Base == Networker {
    func requestData(url: URL, method: HTTPMethod, parameters: [String: Any] = [:], options: [Option] = []) -> Single<Data> {
        return Single.create { s in
            let request = self.base.requestData(url: url, method: method, parameters: parameters, options: options, completion: { result in
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
    
    @discardableResult
    func requestJSON(url: URL, method: HTTPMethod, parameters: [String: Any] = [:], options: [Option] = []) -> Single<JSONType> {
        return Single.create { s in
            let request = self.base.requestJSON(url: url, method: method, parameters: parameters, options: options, completion: { result in
                switch result {
                case .success(let json):
                    s(.success(json))
                case .failure(let error):
                    s(.error(error))
                }
            })
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    @discardableResult
    func requestData(request: URLRequest) -> Single<Data> {
        return Single.create { s in
            let request = self.base.requestData(request: request, completion: { result in
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
    
    @discardableResult
    func requestJSON(request: URLRequest) -> Single<JSONType> {
        return Single.create { s in
            let request = self.base.requestJSON(request: request, completion: { result in
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

extension Networker: ReactiveCompatible {}
