//
//  ViewController.swift
//  Demo
//
//  Created by Alex Antonyuk on 7/5/19.
//  Copyright © 2019 Alex Antonyuk. All rights reserved.
//

import UIKit
import Networker
import RxSwift
import Alamofire

//extension HTTPMethod: CustomStringConvertible {
//    public var description: String {
//        return rawValue
//    }
//}

class ViewController: UIViewController {
    
    private let trash = DisposeBag()
    
//    let network: NetworkerType = AlamofireNetworker(config: NetworkConfiguration())
//    let alamo = AlamofireNetworker(config: NetworkConfiguration())
    let networker = Networker(config: NetworkConfiguration())

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    let url = URL(string: "https://api.cryptonator.com/api/ticker/btc-usd")!

    @IBAction private func doRequest(_ sender: UIButton) {
//        network.requestJSON(method: .get, url: URL(string: "https://api.cryptonator.com/api/ticker/btc-usd")!) { result in
//            guard let json = result.value else { return }
//            print(json)
//        }
        
//        network.rx.requestJSON(url: URL(string: "https://api.cryptonator.com/api/ticker/btc-usd")!, method: .get, parameters: [:]).subscribe(onSuccess: { json in
//            print(json)
//        }) { error in
//            print(error)
//        }.disposed(by: trash)
        
//        network.requestJSON(request: URLRequest(url: URL(string: "https://api.cryptonator.com/api/ticker/btc-usd")!)) { result in
//            print(result)
//        }
//
//        network.rx_requestJSON(url: URL(string: "https://api.cryptonator.com/api/ticker/btc-usd")!, method: HTTPMethod.get, parameters: [:], options: []).subscribe { json in
//            print(json)
//        }.disposed(by: trash)
//
//        alamo.rx.requestJSON(url: URL(string: "https://api.cryptonator.com/api/ticker/btc-usd")!, method: HTTPMethod.get, parameters: [:], options: []).subscribe { json in
//            print(json)
//        }.disposed(by: trash)
        
//        network.rx.requestJSON(url: URL(string: "https://api.cryptonator.com/api/ticker/btc-usd")!, method: HTTPMethod.get, parameters: [:]).subscribe(onSuccess: { json in
//            print(json)
//        }) { error in
//            print(error)
//        }.disposed(by: trash)
        
        networker.rx.requestJSON(url: url, method: .get).subscribe(onSuccess: { json in
            print(json)
        }).disposed(by: trash)
    }

}

