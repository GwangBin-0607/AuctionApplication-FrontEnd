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
    init() {
        let mockSubject = PublishSubject<Void>()
        mock = mockSubject.asObserver()
        mockSubject.asObservable().subscribe(onNext: {
            print(self.delegate)
            self.delegate?.presentLogin()
        })
    }
    func setTransitioning(delegate: TransitionUserPageViewController) {
        self.delegate = delegate
    }
}
