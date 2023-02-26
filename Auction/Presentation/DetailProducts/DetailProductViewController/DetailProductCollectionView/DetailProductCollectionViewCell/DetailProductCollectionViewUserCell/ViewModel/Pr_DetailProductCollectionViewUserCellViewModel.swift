//
//  Pr_DetailProductCollectionViewUserCell.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/24.
//

import Foundation
import RxSwift
protocol Pr_DetailProductCollectionViewUserCellViewModel {
    var userNameObservable:Observable<String?>{get}
    var userImageObservable:Observable<CellImageTag>{get}
    var detailUserObserver:AnyObserver<UserWithTag>{get}
}
