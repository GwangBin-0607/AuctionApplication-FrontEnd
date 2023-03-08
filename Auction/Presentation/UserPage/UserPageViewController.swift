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
    private let profileImageView:UIImageView = {
       let r = UIImageView()
        r.layer.cornerRadius = 10
        r.clipsToBounds = true
        return r
    }()
    private let usernameLabel:UILabel
    private let settingTableView:UserPageTableView
    init(viewModel:Pr_UserPageViewControllerViewModel,settingTableView:UserPageTableView) {
        self.settingTableView = settingTableView
        usernameLabel = UILabel()
        disposeBag = DisposeBag()
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
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
        view.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: profileImageView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 0.1, constant: 0.0).isActive = true
        NSLayoutConstraint(item: profileImageView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 0.1, constant: 0.0).isActive = true
        NSLayoutConstraint(item: profileImageView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.25, constant: 0.0).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor).isActive = true
        view.addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5.0).isActive = true
        usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5.0).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10.0).isActive = true
        usernameLabel.font = UIFont.systemFont(ofSize: 40.0, weight: .heavy)
        profileImageView.backgroundColor = .green
        usernameLabel.backgroundColor = .yellow
        usernameLabel.text = "Nickname"
        usernameLabel.adjustsFontSizeToFitWidth = true
        usernameLabel.minimumScaleFactor = 0.1
        view.addSubview(settingTableView)
        settingTableView.translatesAutoresizingMaskIntoConstraints = false
        settingTableView.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 10.0).isActive = true
        settingTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        settingTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        settingTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        settingTableView.backgroundColor = .blue
        return view
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

