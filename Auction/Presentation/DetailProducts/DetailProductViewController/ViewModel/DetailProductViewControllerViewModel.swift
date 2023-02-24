//
//  DetailProductViewControllerViewModel.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/21.
//

import Foundation
import RxSwift

final class DetailProductViewControllerViewModel:Pr_DetailProductViewControllerViewModel,SetCoordinatorViewController{
    weak var delegate:TransitionDetailProductViewController?
    private let detailProductPriceViewModel:Pr_DetailProductPriceViewModel
    private let detailProductCollectionViewModel:Pr_DetailProductCollectionViewModel
    let requestDetailProduct: AnyObserver<Int8>
    let backAction: AnyObserver<Void>
    private let disposeBag:DisposeBag
    init(transitioning:TransitionDetailProductViewController?=nil,detailProductPriceViewModel: Pr_DetailProductPriceViewModel,detailProductCollectionViewModel:Pr_DetailProductCollectionViewModel) {
        disposeBag = DisposeBag()
        self.detailProductPriceViewModel = detailProductPriceViewModel
        self.delegate = transitioning
        self.detailProductCollectionViewModel = detailProductCollectionViewModel
        requestDetailProduct = detailProductCollectionViewModel.requestDetailProductObserver
        let buttonSubject = PublishSubject<Void>()
        backAction = buttonSubject.asObserver()
        buttonSubject.subscribe(onNext: {
            [weak self] in
            self?.delegate?.dismissToProductListViewController()
        }).disposed(by: disposeBag)
    }
}
