//
//  Pr_UserPageTableView.swift
//  Auction
//
//  Created by 안광빈 on 2023/03/08.
//

import Foundation
import RxSwift
protocol Pr_UserPageTableViewModel{
    var loginPresentObservable:Observable<Void>{get}
    var loginPresentObserver:AnyObserver<Void>{get}
    var tableViewContent:Observable<[String]>{get}
    var reloadTableView:AnyObserver<Void>{get}
}
