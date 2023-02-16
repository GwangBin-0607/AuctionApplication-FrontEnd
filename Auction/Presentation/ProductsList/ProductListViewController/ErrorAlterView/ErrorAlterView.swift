//
//  ErrorAlterView.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/26.
//

import Foundation
import UIKit
import RxSwift
class ErrorAlterView:UIView{
    let label:UILabel
    let viewModel:Pr_ErrorAlterViewModel
    let disposeBag:DisposeBag
    init(viewModel:Pr_ErrorAlterViewModel) {
        label = UILabel()
        disposeBag = DisposeBag()
        self.viewModel = viewModel
        super.init(frame: .zero)
        bind()
        initProperty()
        layoutContentView()
    }
    private func executeAnimation(){
        UIView.animateKeyframes(withDuration: 1.0, delay: 0.0,options: .beginFromCurrentState, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.1, animations: {
                self.alpha = 1.0
                self.transform = CGAffineTransform.identity
            })
            UIView.addKeyframe(withRelativeStartTime: 0.9, relativeDuration: 0.1, animations: {
                self.alpha = 0.0
                self.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
            })
        })
    }
    private func initProperty(){
        self.layer.cornerRadius = 15
        self.alpha = 0.0
        self.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
        self.backgroundColor = .systemYellow
    }
    private func layoutContentView(){
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 12.0)
    }
    private func bind(){
        viewModel.errorMessage.subscribe(onNext: {
            [weak self] message in
            self?.label.text = message
            self?.executeAnimation()
        }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
