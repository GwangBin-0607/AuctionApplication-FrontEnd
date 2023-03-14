//
//  LoginViewController.swift
//  Auction
//
//  Created by 안광빈 on 2023/03/07.
//

import Foundation
import UIKit
import RxSwift
final class LoginViewController:UIViewController{
    private let idTextField:UITextField
    private let loginButton:UIButton
    private let viewModel:Pr_LoginViewControllerViewModel
    private let backButton:UIButton
    private let disposeBag:DisposeBag
    init(customButton:CustomTextButton,viewModel:Pr_LoginViewControllerViewModel) {
        disposeBag = DisposeBag()
        backButton = UIButton()
        self.viewModel = viewModel
        loginButton = customButton
        idTextField = UITextField()
        super.init(nibName: nil, bundle: nil)
        idTextField.backgroundColor = .systemYellow
        idTextField.textColor = .white
        idTextField.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        idTextField.layer.cornerRadius = 10
        idTextField.textAlignment = .center
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = .white
        bind()
    }
    override func loadView() {
        super.loadView()
        self.view = layout()
    }
    private func bind(){
        backButton.rx.tap.bind(to: viewModel.backObserver).disposed(by: disposeBag)
    }
    private func layout()->UIView{
        let view = ShadowView()
        view.backgroundColor = .white
        view.addSubview(idTextField)
        idTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: idTextField, attribute: .top, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 0.5, constant: 0.0).isActive = true
        idTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        NSLayoutConstraint(item: idTextField, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.65, constant: 0.0).isActive = true
        NSLayoutConstraint(item: idTextField, attribute: .height, relatedBy: .equal, toItem: idTextField, attribute: .width, multiplier: 0.3, constant: 0.0).isActive = true
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.topAnchor.constraint(equalTo: idTextField.bottomAnchor, constant: 10.0).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        NSLayoutConstraint(item: loginButton, attribute: .width, relatedBy: .equal, toItem: idTextField, attribute: .width, multiplier: 0.6, constant: 0.0).isActive = true
        NSLayoutConstraint(item: loginButton, attribute: .height, relatedBy: .equal, toItem: loginButton, attribute: .width, multiplier: 0.5, constant: 0.0).isActive = true
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: backButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 0.15, constant: 0.0).isActive = true
        NSLayoutConstraint(item: backButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 0.15, constant: 0.0).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        backButton.clipsToBounds = true
        backButton.tintColor = .systemYellow
        let buttonImage = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
        backButton.setImage(buttonImage, for: .normal)
        return view
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}
