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

public protocol Networker {
    associatedtype MethodsType
    associatedtype ParametersType
    associatedtype ErrorType: Error
    associatedtype JSONType
    
    init(config: NetworkConfiguration)
    func requestData(method: MethodsType, url: URL, parameters: ParametersType, options: [Option], completion: @escaping (Result<Data, ErrorType>) -> Void) -> CancellableRequest
    func requestJSON(method: MethodsType, url: URL, parameters: ParametersType, options: [Option], completion: @escaping (Result<JSONType, ErrorType>) -> Void) -> CancellableRequest    
}

public protocol CancellableRequest {
    func cancel()
}
