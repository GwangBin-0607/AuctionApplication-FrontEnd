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
    var priceObservable:Observable<String>{get}
    var beforePriceObservable:Observable<String>{get}
    var requestDataObserver:AnyObserver<Int8>{get}
}
