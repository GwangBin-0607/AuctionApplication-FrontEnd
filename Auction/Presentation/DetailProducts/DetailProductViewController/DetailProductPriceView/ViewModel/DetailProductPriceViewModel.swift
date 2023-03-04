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
    private let buyProductButtonViewModel:Pr_BuyProductButtonViewModel
    let pangestureObserver: AnyObserver<Pangesture>
    let pangestureObservable: Observable<Pangesture>
    let animationSubview:Observable<Void>
    let animationSubviewObserver:AnyObserver<Void>
    let tapGestureObserver: AnyObserver<Void>
    let tapGestureObservable: Observable<Void>
    let productButtonTapObservable: Observable<Void>
    init(usecase:Pr_CurrentProductPriceUsecase,priceLabelViewModel:Pr_DetailPriceLabelViewModel,enableLabelViewModel:Pr_DetailPriceLabelViewModel,buyProductButtonViewModel:Pr_BuyProductButtonViewModel) {
        disposeBag = DisposeBag()
        productButtonTapObservable = buyProductButtonViewModel.tapObservable
        self.buyProductButtonViewModel = buyProductButtonViewModel
        self.enablePriceLabelViewModel = enableLabelViewModel
        self.usecase = usecase
        self.priceLabelViewModel = priceLabelViewModel
        let animationSubViewSubject = PublishSubject<Void>()
        animationSubview = animationSubViewSubject.asObservable()
        animationSubviewObserver = animationSubViewSubject.asObserver()
        let requestData = PublishSubject<Int>()
        requestDataObserver = requestData.asObserver()
        let updownSubject = PublishSubject<UIImage?>()
        let beforePriceSubject = PublishSubject<Int>()
        updownObservable = updownSubject.asObservable().distinctUntilChanged()
        let updownObserver = updownSubject.asObserver()
        let tapSubject = PublishSubject<Void>()
        tapGestureObserver = tapSubject.asObserver()
        tapGestureObservable = tapSubject.asObservable()
        beforePriceObservable = beforePriceSubject.asObservable().map({
            price in
            return "전일대비 : +"+String(price)+"₩"
        })
        let panGesture=PublishSubject<Pangesture>()
        pangestureObserver = panGesture.asObserver()
        pangestureObservable = panGesture.asObservable()
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
