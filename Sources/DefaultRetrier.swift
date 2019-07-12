//
//  DefaultRetrier.swift
//  Networker
//
//  Created by Alex Antonyuk on 7/12/19.
//  Copyright © 2019 Alex Antonyuk. All rights reserved.
//

import Foundation
import Alamofire

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

