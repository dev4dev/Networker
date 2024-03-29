//
//  SimpleNetworker.swift
//  Networker
//
//  Created by Alex Antonyuk on 7/11/19.
//  Copyright © 2019 Alex Antonyuk. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

public final class Networker {
    
    private let config: NetworkConfiguration
    private let session: SessionManager
    public init(config: NetworkConfiguration) {
        self.config = config
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.requestCachePolicy = config.requestCachePolicy
        sessionConfig.timeoutIntervalForResource = config.resourceTimeout
        sessionConfig.timeoutIntervalForRequest = config.requestTimeout
        
        let capacity: Int = (5 * 20) * 1024 * 1024 // max response should be less than 5% of cache size
        let urlCache: URLCache? = config.isURLCacheEnabled ? URLCache(memoryCapacity: capacity, diskCapacity: capacity, diskPath: nil) : nil
        sessionConfig.urlCache = urlCache
        
        session = SessionManager(configuration: sessionConfig)
        session.retrier = DefaultRetrier(times: config.retries)
        session.startRequestsImmediately = true
    }
    
    private func request(url: URL, method: HTTPMethod, parameters: [String: Any], options: [Option]) -> DataRequest {
        var headers: HTTPHeaders = [:]
        var encoding: ParameterEncoding = JSONEncoding.default
        for option in options {
            switch option {
            case .headers(let h):
                headers = h
                
            case.encoding(let enc):
                switch enc {
                case .JSON:
                    encoding = JSONEncoding.default
                case .URL:
                    encoding = URLEncoding.default
                }
            }
        }
        
        return session.request(url, method: method.toAlamofire(), parameters: parameters, encoding: encoding, headers: headers)
    }
    
    @discardableResult
    public func requestData(url: URL, method: HTTPMethod, parameters: [String: Any] = [:], options: [Option] = []) -> Single<NetworkerResponse<Data>> {
        return Single.create { s in
            let request = self.request(url: url, method: method, parameters: parameters, options: options)
            request.responseData { response in
                switch response.result {
                case .success(let data):
                    s(.success(NetworkerResponse(response: response.response!, value: data)))
                case .failure(let error):
                    s(.error(error))
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
            
        }
    }
    
    @discardableResult
    public func requestData(request: URLRequest) -> Single<NetworkerResponse<Data>> {
        return Single.create { s in
            let request = self.session.request(request)
            request.responseData { response in
                switch response.result {
                case .success(let data):
                    s(.success(NetworkerResponse(response: response.response!, value: data)))
                case .failure(let error):
                    s(.error(error))
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}

extension HTTPMethod {
    func toAlamofire() -> Alamofire.HTTPMethod {
        switch self {
        case .options:
            return Alamofire.HTTPMethod.options
        case .get:
            return Alamofire.HTTPMethod.get
        case .head:
            return Alamofire.HTTPMethod.head
        case .post:
            return Alamofire.HTTPMethod.post
        case .put:
            return Alamofire.HTTPMethod.put
        case .patch:
            return Alamofire.HTTPMethod.patch
        case .delete:
            return Alamofire.HTTPMethod.delete
        case .trace:
            return Alamofire.HTTPMethod.trace
        case .connect:
            return Alamofire.HTTPMethod.connect
        }
    }
}

