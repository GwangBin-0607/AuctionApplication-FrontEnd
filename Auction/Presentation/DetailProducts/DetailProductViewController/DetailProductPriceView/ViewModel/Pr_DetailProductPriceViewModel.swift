//
//  Pr_DetailProductPriceViewModel.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/21.
//

import Foundation
import RxSwift
protocol Pr_DetailProductPriceViewModel{
    var updownObservable:Observable<UIImage?>{get}
    var beforePriceObservable:Observable<String>{get}
    var requestDataObserver:AnyObserver<Int>{get}
    var buyProduct:AnyObserver<Void>{get}
    var userObserver:AnyObserver<Int>{get}
    var userObservable:Observable<Int>{get}
}
