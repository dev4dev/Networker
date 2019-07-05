//
//  Networker.swift
//  Networker
//
//  Created by Alex Antonyuk on 7/5/19.
//  Copyright © 2019 Alex Antonyuk. All rights reserved.
//

import Foundation

protocol Networker {
    associatedtype MethodsType
    associatedtype ParametersType
    associatedtype ErrorType: Error
    
    func request(method: MethodsType, url: URL, parameters: ParametersType, completion: (Result<Data, ErrorType>) -> Void)
    
}
