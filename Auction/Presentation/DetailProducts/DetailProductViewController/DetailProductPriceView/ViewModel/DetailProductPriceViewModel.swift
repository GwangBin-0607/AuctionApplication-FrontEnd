//
//  DetailProductPriceViewModel.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/21.
//

import Foundation
import RxSwift

final class DetailProductPriceViewModel:Pr_DetailProductPriceViewModel{
    let updownObservable: Observable<UIImage?>
    let beforePriceObservable: Observable<String>
    let requestDataObserver: AnyObserver<Int>
    private let usecase:Pr_CurrentProductPriceUsecase
    private let disposeBag:DisposeBag
    private let priceLabelViewModel:Pr_DetailPriceLabelViewModel
    private let enablePriceLabelViewModel:Pr_DetailPriceLabelViewModel
    init(usecase:Pr_CurrentProductPriceUsecase,priceLabelViewModel:Pr_DetailPriceLabelViewModel,enableLabelViewModel:Pr_DetailPriceLabelViewModel) {
        disposeBag = DisposeBag()
        self.enablePriceLabelViewModel = enableLabelViewModel
        self.usecase = usecase
        self.priceLabelViewModel = priceLabelViewModel
        let requestData = PublishSubject<Int>()
        requestDataObserver = requestData.asObserver()
        let updownSubject = PublishSubject<UIImage?>()
        let beforePriceSubject = PublishSubject<Int>()
        updownObservable = updownSubject.asObservable().distinctUntilChanged()
        let updownObserver = updownSubject.asObserver()
        beforePriceObservable = beforePriceSubject.asObservable().map({
            price in
            return "전일대비 : +"+String(price)+"₩"
        })
        let beforePriceObserver = beforePriceSubject.asObserver()
        let priceObserver = priceLabelViewModel.priceObserver
        let enableObserver = enablePriceLabelViewModel.priceObserver
        requestData.asObservable().flatMap(usecase.returnCurrentProductPrice(productId:)).subscribe(onNext: {
            result in
            switch result {
            case .success(let current):
                if current.checkUpDown.state{
                    updownObserver.onNext(UIImage(named: "upState"))
                }else{
                    updownObserver.onNext(UIImage(named: "nothing"))
                }
                beforePriceObserver.onNext(current.before_price)
                priceObserver.onNext(current.price)
                enableObserver.onNext(current.price)
            case .failure(let error):
                print(error)
            }
        }).disposed(by: disposeBag)
        usecase.returnStreamCurrentProductPrice().subscribe(onNext: {
            result in
            switch result {
            case .success(let buffer):
                if let updateData = buffer.last{
                    if updateData.state{
                        updownObserver.onNext(UIImage(named: "upState"))
                    }else{
                        updownObserver.onNext(UIImage(named: "nothing"))
                    }
                    beforePriceObserver.onNext(updateData.beforePrice)
                    priceObserver.onNext(updateData.product_price)
                    enableObserver.onNext(updateData.product_price)
                }
            case .failure(let err):
                print(err)
            }
        }).disposed(by: disposeBag)
        
    }
}
