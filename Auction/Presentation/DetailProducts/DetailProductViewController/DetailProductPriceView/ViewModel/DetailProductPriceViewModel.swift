//
//  DetailProductPriceViewModel.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/21.
//

import Foundation
import RxSwift

final class DetailProductPriceViewModel:Pr_DetailProductPriceViewModel{
    let updownObservable: Observable<ProductUpDown>
    let priceObservable: Observable<String>
    let beforePriceObservable: Observable<String>
    let updownObserver: AnyObserver<ProductUpDown>
    let priceObserver: AnyObserver<Int>
    let beforePriceObserver: AnyObserver<Int>
    init() {
        let updownSubject = PublishSubject<ProductUpDown>()
        let priceSubject = PublishSubject<Int>()
        let beforePriceSubject = PublishSubject<Int>()
        updownObservable = updownSubject.asObservable()
        updownObserver = updownSubject.asObserver()
        beforePriceObservable = beforePriceSubject.asObservable().map({
            price in
            return "전일대비 : +"+String(price)+"₩"
        })
        beforePriceObserver = beforePriceSubject.asObserver()
        priceObservable = priceSubject.asObservable().map({
            price in
            return "현재가격 : "+String(price)+"₩"
        })
        priceObserver = priceSubject.asObserver()
    }
}
