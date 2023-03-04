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
    var pangestureObserver:AnyObserver<Pangesture>{get}
    var pangestureObservable:Observable<Pangesture>{get}
    var animationSubview:Observable<Void>{get}
    var animationSubviewObserver:AnyObserver<Void>{get}
    var tapGestureObserver:AnyObserver<Void>{get}
    var tapGestureObservable:Observable<Void>{get}
    var productButtonTapObservable:Observable<Void>{get}
}
