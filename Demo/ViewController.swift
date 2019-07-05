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

class ViewController: UIViewController {
    
    private let trash = DisposeBag()
    
    let network = AlamofireNetworker(config: NetworkConfiguration())

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction private func doRequest(_ sender: UIButton) {
//        network.requestJSON(method: .get, url: URL(string: "https://api.cryptonator.com/api/ticker/btc-usd")!) { result in
//            guard let json = result.value else { return }
//            print(json)
//        }
        
        network.rx.requestJSON(method: .get, url: URL(string: "https://api.cryptonator.com/api/ticker/btc-usd")!, parameters: [:]).subscribe(onSuccess: { json in
            print(json)
        }) { error in
            print(error)
        }.disposed(by: trash)
        
    }

}

