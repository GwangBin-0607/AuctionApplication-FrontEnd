//
//  LoginViewController.swift
//  Auction
//
//  Created by 안광빈 on 2023/03/07.
//

import Foundation
import UIKit
final class LoginViewController:UIViewController{
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("DISAPPEAR")
    }
}
