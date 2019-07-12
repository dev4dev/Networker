//
//  String+Error.swift
//  Networker
//
//  Created by Alex Antonyuk on 7/12/19.
//  Copyright © 2019 Alex Antonyuk. All rights reserved.
//

import Foundation

extension String: LocalizedError {
    public var errorDescription: String? {
        return self
    }
    
    public var failureReason: String? {
        return self
    }
}
