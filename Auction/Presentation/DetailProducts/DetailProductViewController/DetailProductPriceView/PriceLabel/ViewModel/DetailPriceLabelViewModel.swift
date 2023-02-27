//
//  DetailPriceLabelViewModel.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/26.
//

import Foundation
import RxSwift

final class DetailProductLabelViewModel:Pr_DetailPriceLabelViewModel{
    let priceObservable: Observable<String>
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
