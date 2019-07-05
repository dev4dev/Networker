//
//  Networker+Rx.swift
//  Networker
//
//  Created by Alex Antonyuk on 7/5/19.
//  Copyright © 2019 Alex Antonyuk. All rights reserved.
//

import Foundation
import RxSwift

public extension Reactive where Base: Networker {
    func requestData(method: Base.MethodsType, url: URL, parameters: Base.ParametersType, options: [Option] = []) -> Single<Data> {
        return Single.create { single in
            let request = self.base.requestData(method: method, url: url, parameters: parameters, options: options, completion: { result in
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
    
    func requestJSON(method: Base.MethodsType, url: URL, parameters: Base.ParametersType, options: [Option] = []) -> Single<Base.JSONType> {
        return Single.create { single in
            let request = self.base.requestJSON(method: method, url: url, parameters: parameters, options: options, completion: { result in
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
}

//public extension Networker where Self: ReactiveCompatible {
//    func requestData(method: Self.MethodsType, url: URL, parameters: Self.ParametersType, options: [Option] = []) -> Single<Data> {
//        return Single.create { single in
//            let request = self.requestData(method: method, url: url, parameters: parameters, options: options, completion: { result in
//                switch result {
//                case .success(let value):
//                    single(.success(value))
//                case .failure(let error):
//                    single(.error(error))
//                }
//            })
//            
//            return Disposables.create {
//                request.cancel()
//            }
//        }
//    }
//    
//    func requestJSON(method: Self.MethodsType, url: URL, parameters: Self.ParametersType, options: [Option] = []) -> Single<Self.JSONType> {
//        return Single.create { single in
//            let request = self.requestJSON(method: method, url: url, parameters: parameters, options: options, completion: { result in
//                switch result {
//                case .success(let value):
//                    single(.success(value))
//                case .failure(let error):
//                    single(.error(error))
//                }
//            })
//            
//            return Disposables.create {
//                request.cancel()
//            }
//        }
//    }
//}

extension AlamofireNetworker: ReactiveCompatible {}
