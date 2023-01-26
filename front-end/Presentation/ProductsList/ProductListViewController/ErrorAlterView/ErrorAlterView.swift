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
        layoutContentView()
    }
    private func executeAnimation(){
        UIView.animateKeyframes(withDuration: 2.0, delay: 0.0,options: .calculationModeLinear, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.2, animations: {
                self.alpha = 1.0
            })
            UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.2, animations: {
                self.alpha = 0.0
            })
        })
    }
    
    private func layoutContentView(){
        self.alpha = 0.0
        self.addSubview(label)
        self.backgroundColor = .systemYellow
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 12.0)
    }
    func bind(){
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
