//
//  AlamofireNetworker.swift
//  Networker
//
//  Created by Alex Antonyuk on 7/5/19.
//  Copyright © 2019 Alex Antonyuk. All rights reserved.
//

import Foundation
import Alamofire

extension Request: CancellableRequest {}

extension String: LocalizedError {
    public var errorDescription: String? {
        return self
    }
    
    public var failureReason: String? {
        return self
    }
}

final class DefaultRetrier: RequestRetrier {
    let times: UInt
    private var counter = 0
    
    init(times: UInt) {
        self.times = times
    }
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        counter += 1
        guard counter < times else {
            completion (false, 0.0)
            return
        }
        completion(true, 0.0)
    }
}

public final class AlamofireNetworker: NetworkerType {
    
    public typealias ParametersType = Parameters
    public typealias ErrorType = Error
    public typealias JSONType = [AnyHashable: Any]
    
    private let session: SessionManager
    
    public init(config: NetworkConfiguration) {
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
    
    public func buildRequest<HTTPMethod>(url: URL, method: HTTPMethod, parameters: [String : Any], options: [Option]) -> URLRequest where HTTPMethod : CustomStringConvertible {
        var request = URLRequest(url: url)
        request.httpMethod = method.description
        
        var encoding: ParameterEncoding = JSONEncoding.default
        for option in options {
            switch option {
            case .headers(let h):
                var rh = request.allHTTPHeaderFields ?? [:]
                for (key, value) in h {
                    rh[key] = value
                }
                request.allHTTPHeaderFields = rh

            case.encoding(let enc):
                switch enc {
                case .JSON:
                    encoding = JSONEncoding.default
                case .URL:
                    encoding = URLEncoding.default
                }
            }
        }
        
        if let encoded = try? encoding.encode(request, with: parameters) {
            request = encoded
        }

        return request
    }
    
    @discardableResult
    public func requestData(request: URLRequest, completion: @escaping (Swift.Result<Data, Error>) -> Void) -> CancellableRequest {
        let request = session.request(request)
        request.responseData { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        return request
    }
    
    @discardableResult
    public func requestJSON(request: URLRequest, completion: @escaping (Swift.Result<JSONType, Error>) -> Void) -> CancellableRequest {
        let request = session.request(request)
        request.responseJSON(completionHandler: { response in
            switch response.result {
            case .success(let data):
                if let json = data as? JSONType {
                    completion(.success(json))
                } else {
                    completion(.failure("JSON incopatible type"))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
        
        return request
    }
}
