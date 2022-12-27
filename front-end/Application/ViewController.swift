//
//  ViewController.swift
//  front-end
//
//  Created by 안광빈 on 2022/09/29.
//

import UIKit
import RxSwift
class ViewController: UIViewController {
    let btn = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "URLL") as? String else {
            fatalError("ApiKey must noasdasdadasdadasdasdasdasdadt be emptaay in plist")
        }
        self.view.addSubview(btn)
        btn.backgroundColor = .yellow
        btn.frame = CGRect(x: 40, y: 40, width: 120, height: 120)
        btn.addTarget(self, action: #selector(action), for: .touchUpInside)

    
    }
    @objc func action(){
    }
    
    
}

