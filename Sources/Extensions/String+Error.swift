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

extension String {
    func toJSONDict() -> JSONDict? {
        let data = try? JSONSerialization.jsonObject(with: self.data(using: String.Encoding.utf8)!, options: [.allowFragments])
        if let data = data as? [String: Any] {
            return data
        }
        
        return nil
    }
}
