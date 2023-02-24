//
//  Pr_DetailProductPriceViewModel.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/21.
//

import Foundation
import RxSwift
protocol Pr_DetailProductPriceViewModel{
    var updownObservable:Observable<ProductUpDown>{get}
    var updownObserver:AnyObserver<ProductUpDown>{get}
    var priceObservable:Observable<String>{get}
    var priceObserver:AnyObserver<Int>{get}
    var beforePriceObservable:Observable<String>{get}
    var beforePriceObserver:AnyObserver<Int>{get}
}
