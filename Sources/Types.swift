//
//  Types.swift
//  Networker
//
//  Created by Alex Antonyuk on 7/12/19.
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

public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

public struct NetworkerResponse<ResponseType> {
    public let response: HTTPURLResponse
    public let value: ResponseType
    
    public func update<NewType>(data: NewType) -> NetworkerResponse<NewType> {
        return NetworkerResponse<NewType>(response: response, value: data)
    }
    
    func validate() -> Bool {
        return (200..<300).contains(response.statusCode)
    }
}
