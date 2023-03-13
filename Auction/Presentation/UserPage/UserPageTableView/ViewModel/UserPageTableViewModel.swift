//
//  UserPageTableViewModel.swift
//  Auction
//
//  Created by 안광빈 on 2023/03/08.
//

import Foundation
import RxSwift
final class UserPageTableViewModel:Pr_UserPageTableViewModel{
    let tableViewContent: Observable<[String]>
    let reloadTableView: AnyObserver<Void>
    let loginPresentObserver: AnyObserver<Void>
    let loginPresentObservable: Observable<Void>
    private let disposeBag:DisposeBag
    init() {
        disposeBag = DisposeBag()
        let reloadSubject = PublishSubject<Void>()
        reloadTableView = reloadSubject.asObserver()
        let tableViewContentSubject = PublishSubject<[String]>()
        tableViewContent = tableViewContentSubject.asObservable()
        let tableViewContentObserver = tableViewContentSubject.asObserver()
        reloadSubject.asObservable().subscribe(onNext: {
            tableViewContentObserver.onNext(["로그인","설정","기타"])
        }).disposed(by: disposeBag)
        let loginSubject = PublishSubject<Void>()
        loginPresentObserver = loginSubject.asObserver()
        loginPresentObservable = loginSubject.asObservable()
    }
}
