//
//  APIClient.swift
//  Demo
//
//  Created by Alex Antonyuk on 7/11/19.
//  Copyright © 2019 Alex Antonyuk. All rights reserved.
//

import Foundation
import Networker
import RxSwift

final class APIClient {
    
    let network: Networker
    init(network: Networker) {
        self.network = network
    }
    
    func bitcoinData() -> Single<Model> {
        return network.requestData(url: URL(string: "https://api.cryptonator.com/api/ticker/btc-usd")!, method: .get).toCodableModel().map { $0.value }
    }
    
}
