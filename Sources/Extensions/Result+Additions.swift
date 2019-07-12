//
//  Result+Additions.swift
//  Networker
//
//  Created by Alex Antonyuk on 7/5/19.
//  Copyright © 2019 Alex Antonyuk. All rights reserved.
//

import Foundation

public extension Result {
    var value: Success? {
        if case let .success(value) = self {
            return value
        }
        
        return nil
    }
    
    var error: Error? {
        if case let .failure(error) = self {
            return error
        }
        
        return nil
    }
}
