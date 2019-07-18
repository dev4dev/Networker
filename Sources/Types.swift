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
public typealias HTTPHeaders = [String: String]

public enum Option {
    case headers(HTTPHeaders)
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

public typealias Parameters = [String: Any]
public typealias JSONDict = [String: Any]

//public protocol ValueContainer {
//    associatedtype ValueType
//
//    var value: ValueType { get }
//}

public protocol NetworkerResponseType {
    var response: HTTPURLResponse { get }

    func validate() -> Bool
}

public protocol NetworkDataResponseType: NetworkerResponseType {
    associatedtype ValueType
    var value: ValueType { get }
}

public extension NetworkerResponseType {
    func validate() -> Bool {
        return (200..<300).contains(response.statusCode)
    }
}

public struct NetworkerResponse<ResponseType>: NetworkDataResponseType {
    public typealias ValueType = ResponseType
    public let response: HTTPURLResponse
    public let value: ResponseType
    
    public func update<NewType>(data: NewType) -> NetworkerResponse<NewType> {
        return NetworkerResponse<NewType>(response: response, value: data)
    }
    
    public func validate() -> Bool {
        return (200..<300).contains(response.statusCode)
    }
}
