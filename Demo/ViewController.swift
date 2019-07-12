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
import RxCocoa

//extension HTTPMethod: CustomStringConvertible {
//    public var description: String {
//        return rawValue
//    }
//}

class ViewController: UIViewController {
    
    private let trash = DisposeBag()
    
//    let network: NetworkerType = AlamofireNetworker(config: NetworkConfiguration())
//    let alamo = AlamofireNetworker(config: NetworkConfiguration())
//    let networker = Networker(config: NetworkConfiguration())
    let simple = SimpleNetworker(config: NetworkConfiguration())

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    let url = URL(string: "https://api.cryptonator.com/api/ticker/btc-usd")!
    lazy var api = APIClient(network: simple)
    
    @IBOutlet weak var output: UILabel!

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
        
//        networker.requestData(url: url, method: .get).asObservable().toModel().subscribe(onNext: { (model: Model) in
//            print("1", model)
//            print(model.toJSONData()?.toJSON())
//        }, onError: { error in
//            print(error)
//        }).disposed(by: trash)
//
//        simple.requestData(url: url, method: .get).toModel().subscribe(onSuccess: { (model: Model) in
//            print("2", model)
//        }).disposed(by: trash)
        
        api.bitcoinData().map { $0.price }.asDriver(onErrorJustReturn: "0.0").drive(output.rx.text).disposed(by: trash)
    }

}

