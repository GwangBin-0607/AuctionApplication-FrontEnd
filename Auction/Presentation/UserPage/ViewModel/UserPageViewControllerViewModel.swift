//
//  UserPageViewControllerViewModel.swift
//  Auction
//
//  Created by 안광빈 on 2023/03/05.
//

import Foundation
import RxSwift
final class UserPageViewControllerViewModel:Pr_UserPageViewControllerViewModel,SetCoordinatorViewModel{
    let mock: AnyObserver<Void>
    weak var delegate: TransitionUserPageViewController?
    private let disposeBag:DisposeBag
    init() {
        disposeBag = DisposeBag()
        let mockSubject = PublishSubject<Void>()
        mock = mockSubject.asObserver()
        mockSubject.asObservable().subscribe(onNext: {
            self.delegate?.presentLogin()
        }).disposed(by: disposeBag)
    }
    func setTransitioning(delegate: TransitionUserPageViewController) {
        self.delegate = delegate
    }
}
