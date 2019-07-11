//
//  Networker+Rx.swift
//  Networker
//
//  Created by Alex Antonyuk on 7/5/19.
//  Copyright © 2019 Alex Antonyuk. All rights reserved.
//

import Foundation
import RxSwift

public extension Reactive where Base: NetworkerType {
    func requestData(request: URLRequest) -> Single<Data> {
        return Single.create { single in
            let request = self.base.requestData(request: request, completion: { result in
                switch result {
                case .success(let value):
                    single(.success(value))
                case .failure(let error):
                    single(.error(error))
                }
            })
            
            return Disposables.create {
                request.cancel()
            }
        }
    }

    func requestJSON(request: URLRequest) -> Single<JSONType> {
        return Single.create { single in
            let request = self.base.requestJSON(request: request, completion: { result in
                switch result {
                case .success(let value):
                    single(.success(value))
                case .failure(let error):
                    single(.error(error))
                }
            })
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func requestData<HTTPMethod: CustomStringConvertible>(url: URL, method: HTTPMethod, parameters: [String: Any], options: [Option]) -> Single<Data> {
        return requestData(request: self.base.buildRequest(url: url, method: method, parameters: parameters, options: options))
    }
    
    func requestJSON<HTTPMethod: CustomStringConvertible>(url: URL, method: HTTPMethod, parameters: [String: Any], options: [Option]) -> Single<JSONType> {
        return requestJSON(request: self.base.buildRequest(url: url, method: method, parameters: parameters, options: options))
    }
}

public extension NetworkerType {
    func rx_requestData(request: URLRequest) -> Single<Data> {
        return Single.create { single in
            let request = self.requestData(request: request, completion: { result in
                switch result {
                case .success(let value):
                    single(.success(value))
                case .failure(let error):
                    single(.error(error))
                }
            })
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func rx_requestJSON(request: URLRequest) -> Single<JSONType> {
        return Single.create { single in
            let request = self.requestJSON(request: request, completion: { result in
                switch result {
                case .success(let value):
                    single(.success(value))
                case .failure(let error):
                    single(.error(error))
                }
            })
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func rx_requestData<HTTPMethod: CustomStringConvertible>(url: URL, method: HTTPMethod, parameters: [String: Any], options: [Option]) -> Single<Data> {
        return rx_requestData(request: buildRequest(url: url, method: method, parameters: parameters, options: options))
    }
    
    func rx_requestJSON<HTTPMethod: CustomStringConvertible>(url: URL, method: HTTPMethod, parameters: [String: Any], options: [Option]) -> Single<JSONType> {
        return rx_requestJSON(request: buildRequest(url: url, method: method, parameters: parameters, options: options))
    }
}

extension AlamofireNetworker: ReactiveCompatible {}
