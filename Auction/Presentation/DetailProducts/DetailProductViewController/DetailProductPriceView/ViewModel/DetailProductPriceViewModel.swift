//
//  DetailProductPriceViewModel.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/21.
//

import Foundation
import RxSwift

final class DetailProductPriceViewModel:Pr_DetailProductPriceViewModel{
    let updownObservable: Observable<Bool?>
    let priceObservable: Observable<Int>
    let beforePriceObservable: Observable<Int>
    let updownObserver: AnyObserver<Bool?>
    let priceObserver: AnyObserver<Int>
    let beforePriceObserver: AnyObserver<Int>
    init() {
        let updownSubject = PublishSubject<Bool?>()
        let priceSubject = PublishSubject<Int>()
        let beforePriceSubject = PublishSubject<Int>()
        updownObservable = updownSubject.asObservable()
        updownObserver = updownSubject.asObserver()
        beforePriceObservable = beforePriceSubject.asObservable()
        beforePriceObserver = beforePriceSubject.asObserver()
        priceObservable = priceSubject.asObservable()
        priceObserver = priceSubject.asObserver()
    }
}
