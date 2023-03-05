//
//  UserPageViewController.swift
//  Auction
//
//  Created by 안광빈 on 2023/03/05.
//

import Foundation
import UIKit

final class UserPageViewController:UIViewController{
    private let viewModel:Pr_UserPageViewControllerViewModel
    init(viewModel:Pr_UserPageViewControllerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    override func loadView() {
        super.loadView()
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
