//
//  UserPageViewController.swift
//  Auction
//
//  Created by 안광빈 on 2023/03/05.
//

import Foundation
import UIKit
import RxSwift
final class UserPageViewController:UIViewController{
    
    private let viewModel:Pr_UserPageViewControllerViewModel
    private let disposeBag:DisposeBag
    private let mockButton:UIButton
    init(viewModel:Pr_UserPageViewControllerViewModel,transtioning:TransitionUserPageViewController) {
        mockButton = UIButton()
        disposeBag = DisposeBag()
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
        self.viewModel.setTransitioning(delegate: transtioning)
    }
    override func loadView() {
        super.loadView()
        self.view = layout()
    }
    private func bind(){
    }
    private func layout()->UIView{
        let view = UIView()
        view.backgroundColor = .white
        view.addSubview(mockButton)
        mockButton.frame = CGRect(x: 50, y: 50, width:100, height: 100)
        mockButton.backgroundColor = .yellow
        mockButton.rx.tap.bind(to: viewModel.mock)
        return view
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

