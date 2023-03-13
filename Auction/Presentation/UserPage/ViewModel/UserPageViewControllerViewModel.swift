//
//  UserPageViewControllerViewModel.swift
//  Auction
//
//  Created by 안광빈 on 2023/03/05.
//

import Foundation
import RxSwift
final class UserPageViewControllerViewModel:Pr_UserPageViewControllerViewModel,SetCoordinatorViewModel{
    weak var delegate: TransitionUserPageViewController?
    private let disposeBag:DisposeBag
    private let tableViewModel:Pr_UserPageTableViewModel
    init(delegate:TransitionUserPageViewController?,tableViewModel:Pr_UserPageTableViewModel) {
        self.tableViewModel = tableViewModel
        self.delegate = delegate
        disposeBag = DisposeBag()
        tableViewModel.loginPresentObservable.withUnretained(self).subscribe(onNext: {
            owner,_ in
            owner.delegate?.presentLogin()
        }).disposed(by: disposeBag)
    }
}
