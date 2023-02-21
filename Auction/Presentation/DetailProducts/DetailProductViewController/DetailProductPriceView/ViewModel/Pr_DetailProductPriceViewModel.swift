//
//  Pr_DetailProductPriceViewModel.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/21.
//

import Foundation
import RxSwift
protocol Pr_DetailProductPriceViewModel{
    var updownObservable:Observable<Bool?>{get}
    var updownObserver:AnyObserver<Bool?>{get}
    var priceObservable:Observable<Int>{get}
    var priceObserver:AnyObserver<Int>{get}
    var beforePriceObservable:Observable<Int>{get}
    var beforePriceObserver:AnyObserver<Int>{get}
}
