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
    let requestDataObserver: AnyObserver<Int>
    private let usecase:Pr_CurrentProductPriceUsecase
    private let disposeBag:DisposeBag
    init(usecase:Pr_CurrentProductPriceUsecase) {
        disposeBag = DisposeBag()
        self.usecase = usecase
        let requestData = PublishSubject<Int>()
        requestDataObserver = requestData.asObserver()
        let updownSubject = PublishSubject<ProductUpDown>()
        let priceSubject = PublishSubject<Int>()
        let beforePriceSubject = PublishSubject<Int>()
        updownObservable = updownSubject.asObservable()
        let updownObserver = updownSubject.asObserver()
        beforePriceObservable = beforePriceSubject.asObservable().map({
            price in
            return "전일대비 : +"+String(price)+"₩"
        })
        let beforePriceObserver = beforePriceSubject.asObserver()
        priceObservable = priceSubject.asObservable().map({
            price in
            return "현재가격 : "+String(price)+"₩"
        })
        let priceObserver = priceSubject.asObserver()
        requestData.asObservable().flatMap(usecase.returnCurrentProductPrice(productId:)).subscribe(onNext: {
            result in
            switch result {
            case .success(let current):
                updownObserver.onNext(current.checkUpDown)
                beforePriceObserver.onNext(current.before_price)
                priceObserver.onNext(current.price)
            case .failure(let error):
                print(error)
            }
        }).disposed(by: disposeBag)
        usecase.returnStreamCurrentProductPrice().subscribe(onNext: {
            result in
            switch result {
            case .success(let buffer):
                if let updateData = buffer.last{
                    print(updateData)
                }
            case .failure(let err):
                print(err)
            }
        }).disposed(by: disposeBag)
        
    }
}
