//
//  LoginViewControllerViewModel.swift
//  Auction
//
//  Created by 안광빈 on 2023/03/08.
//

import Foundation
import RxSwift
final class LoginViewControllerViewModel:Pr_LoginViewControllerViewModel{
    weak var transition:TransitionLoginViewController?
    let backObserver: AnyObserver<Void>
    private let disposeBag:DisposeBag
    init(transition:TransitionLoginViewController?) {
        disposeBag = DisposeBag()
        self.transition = transition
        let backSubject = PublishSubject<Void>()
        backObserver = backSubject.asObserver()
        backSubject.withUnretained(self).subscribe(onNext: {
            owner,_ in
            owner.transition?.dismiss()
        }).disposed(by: disposeBag)
    }
}
