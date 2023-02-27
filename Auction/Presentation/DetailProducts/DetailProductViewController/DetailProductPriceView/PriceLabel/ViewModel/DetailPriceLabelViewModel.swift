//
//  DetailPriceLabelViewModel.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/26.
//

import Foundation
import RxSwift

final class DetailProductLabelViewModel:Pr_DetailPriceLabelViewModel{
    let priceObservable: Observable<String>!
    let priceObserver: AnyObserver<Int>
    init() {
        let subject = PublishSubject<Int>()
        priceObservable = subject.asObservable().map({
            price in
            return "현재가격 : "+String(price)+"₩"
        }).observe(on: MainScheduler.asyncInstance)
        priceObserver = subject.asObserver()
    }
}
final class DetailEnableProductLabelViewModel:Pr_DetailPriceLabelViewModel{
    var priceObservable: Observable<String>!
    let priceObserver: AnyObserver<Int>
    private let upPrice = 500
    init() {
        let subject = PublishSubject<Int>()
        priceObserver = subject.asObserver()
        priceObservable = subject.asObservable().withUnretained(self).map({
            owner,price in
            return "구매 가능 가격\n"+String(price+owner.upPrice)+"₩"
        }).observe(on: MainScheduler.asyncInstance)
    }
}
