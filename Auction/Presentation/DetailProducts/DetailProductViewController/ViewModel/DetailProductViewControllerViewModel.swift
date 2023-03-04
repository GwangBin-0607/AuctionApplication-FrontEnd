//
//  DetailProductViewControllerViewModel.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/21.
//

import Foundation
import RxSwift

final class DetailProductViewControllerViewModel:Pr_DetailProductViewControllerViewModel,SetCoordinatorViewModel{
    weak var delegate:TransitionDetailProductViewController?
    private let detailProductPriceViewModel:Pr_DetailProductPriceViewModel
    private let detailProductCollectionViewModel:Pr_DetailProductCollectionViewModel
    let requestDetailProduct: AnyObserver<Void>
    let backAction: AnyObserver<Void>
    private let disposeBag:DisposeBag
    private let product_id:Int
    let completionReloadData: Observable<CGRect>
    let pangesture: Observable<Pangesture>
    let tapGesture: Observable<Void>
    let priceViewAnimationSubview: AnyObserver<Void>
    let buyProductBottonTapObservable: Observable<Void>
    init(transitioning:TransitionDetailProductViewController?=nil,detailProductPriceViewModel: Pr_DetailProductPriceViewModel,detailProductCollectionViewModel:Pr_DetailProductCollectionViewModel,product_id:Int) {
        buyProductBottonTapObservable = detailProductPriceViewModel.productButtonTapObservable
        disposeBag = DisposeBag()
        pangesture = detailProductPriceViewModel.pangestureObservable
        tapGesture = detailProductPriceViewModel.tapGestureObservable
        priceViewAnimationSubview = detailProductPriceViewModel.animationSubviewObserver
        self.product_id = product_id
        let requestData = PublishSubject<Void>()
        requestDetailProduct = requestData.asObserver()
        self.detailProductPriceViewModel = detailProductPriceViewModel
        self.delegate = transitioning
        self.detailProductCollectionViewModel = detailProductCollectionViewModel
        let buttonSubject = PublishSubject<Void>()
        backAction = buttonSubject.asObserver()
        completionReloadData = self.detailProductCollectionViewModel.completionReloadDataObservable
        requestData.withUnretained(self).subscribe(onNext: {
            owner,_ in
            owner.detailProductCollectionViewModel.requestDetailProductObserver.onNext(owner.product_id)
            owner.detailProductPriceViewModel.requestDataObserver.onNext(owner.product_id)
        }).disposed(by: disposeBag)
        buttonSubject.subscribe(onNext: {
            [weak self] in
            self?.delegate?.dismissToProductListViewController()
        }).disposed(by: disposeBag)
    }
}
