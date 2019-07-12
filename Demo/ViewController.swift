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

class ViewController: UIViewController {
    
    private let trash = DisposeBag()
    
    let networker = Networker(config: NetworkConfiguration())
    lazy var api = APIClient(network: networker)
    let url = URL(string: "https://api.cryptonator.com/api/ticker/btc-usd")!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var output: UILabel!

    @IBAction private func doRequest(_ sender: UIButton) {
        networker.requestData(url: url, method: .get).toModel().subscribe(onSuccess: { (model: NetworkerResponse<Model>) in
            print("🍀", model)
        }).disposed(by: trash)
        
        networker.requestData(url: url, method: .get).toString().toModel().subscribe(onSuccess: { (model: NetworkerResponse<MappableModel>) in
            print("🦠", model)
        }).disposed(by: trash)
        
        networker.requestData(url: url, method: .get).toString().toModel(key: "ticker").subscribe(onSuccess: { (model: NetworkerResponse<MappableSubModel>) in
            print("🔥", model)
        }).disposed(by: trash)
        
        api.bitcoinData().map { $0.price }.asDriver(onErrorJustReturn: "0.0").drive(output.rx.text).disposed(by: trash)
    }

}

