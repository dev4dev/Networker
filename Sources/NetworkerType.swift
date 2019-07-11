//
//  Networker.swift
//  Networker
//
//  Created by Alex Antonyuk on 7/5/19.
//  Copyright © 2019 Alex Antonyuk. All rights reserved.
//

import Foundation

public enum Encoding {
    case JSON
    case URL
}

public typealias JSONType = [AnyHashable: Any]

public enum Option {
    case headers([String: String])
    case encoding(Encoding)
}

public struct NetworkConfiguration {
    public let requestTimeout: TimeInterval
    public let resourceTimeout: TimeInterval
    public let requestCachePolicy: NSURLRequest.CachePolicy
    public let isURLCacheEnabled: Bool
    public let retries: UInt
    
    public init(requestTimeout: TimeInterval = 60.0, resourceTimeout: TimeInterval = 60.0, requestCachePolicy: NSURLRequest.CachePolicy = .useProtocolCachePolicy, isURLCacheEnabled: Bool = false, retries: UInt = 0) {
        self.requestTimeout = requestTimeout
        self.resourceTimeout = resourceTimeout
        self.requestCachePolicy = requestCachePolicy
        self.isURLCacheEnabled = isURLCacheEnabled
        self.retries = retries
    }
}

public protocol NetworkerType {
    init(config: NetworkConfiguration)
    func buildRequest<HTTPMethod: CustomStringConvertible>(url: URL, method: HTTPMethod, parameters: [String: Any], options: [Option]) -> URLRequest
    @discardableResult
    func requestData(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> CancellableRequest
    @discardableResult
    func requestJSON(request: URLRequest, completion: @escaping (Result<JSONType, Error>) -> Void) -> CancellableRequest
    @discardableResult
    func requestData<HTTPMethod: CustomStringConvertible>(url: URL, method: HTTPMethod, parameters: [String: Any], options: [Option], completion: @escaping (Result<Data, Error>) -> Void) -> CancellableRequest
    @discardableResult
    func requestJSON<HTTPMethod: CustomStringConvertible>(url: URL, method: HTTPMethod, parameters: [String: Any], options: [Option], completion: @escaping (Result<JSONType, Error>) -> Void) -> CancellableRequest
}

public protocol CancellableRequest {
    func cancel()
}

public extension NetworkerType {
    @discardableResult
    func requestData<HTTPMethod: CustomStringConvertible>(url: URL, method: HTTPMethod, parameters: [String: Any], options: [Option], completion: @escaping (Result<Data, Error>) -> Void) -> CancellableRequest {
        return requestData(request: buildRequest(url: url, method: method, parameters: parameters, options: options), completion: completion)
    }
    @discardableResult
    func requestJSON<HTTPMethod: CustomStringConvertible>(url: URL, method: HTTPMethod, parameters: [String: Any], options: [Option], completion: @escaping (Result<JSONType, Error>) -> Void) -> CancellableRequest {
        return requestJSON(request: buildRequest(url: url, method: method, parameters: parameters, options: options), completion: completion)
    }
}
