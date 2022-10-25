//
//  ViewController.swift
//  front-end
//
//  Created by 안광빈 on 2022/09/29.
//

import UIKit
class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "URLL") as? String else {
            fatalError("ApiKey must noasdasdadasdadasdasdasdasdadt be emptaay in plist")
        }
    }


}

