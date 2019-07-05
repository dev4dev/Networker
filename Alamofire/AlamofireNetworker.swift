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

public final class AlamofireNetworker: Networker {
    public typealias MethodsType = HTTPMethod
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
    
    private func request(method: HTTPMethod, url: URL, parameters: Parameters, options: [Option]) -> DataRequest {
        var headers: HTTPHeaders? = nil
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
        
        let request = session.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
        return request
    }
    
    @discardableResult
    public func requestData(method: HTTPMethod, url: URL, parameters: Parameters = [:], options: [Option] = [], completion: @escaping (Swift.Result<Data, ErrorType>) -> Void) -> CancellableRequest {
        let request = self.request(method: method, url: url, parameters: parameters, options: options)
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
    public func requestJSON(method: HTTPMethod, url: URL, parameters: Parameters = [:], options: [Option] = [], completion: @escaping (Swift.Result<[AnyHashable : Any], Error>) -> Void) -> CancellableRequest {
        let request = self.request(method: method, url: url, parameters: parameters, options: options)
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
