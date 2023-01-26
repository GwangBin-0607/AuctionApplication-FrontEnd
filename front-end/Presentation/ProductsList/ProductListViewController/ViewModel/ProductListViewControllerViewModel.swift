//
//  ProductListViewControllerViewModel+Interface.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/13.
//

import Foundation
import RxSwift

class ProductListViewControllerViewModel:Pr_ProductListViewControllerViewModel{
    private let collectionViewModel:Pr_ProductListCollectionViewModel
    private let errorAlterViewModel:Pr_ErrorAlterViewModel
    private let disposeBag:DisposeBag
    init(collectionViewModel:Pr_ProductListCollectionViewModel,ErrorAlterViewModel:Pr_ErrorAlterViewModel) {
        self.collectionViewModel = collectionViewModel
        self.errorAlterViewModel = ErrorAlterViewModel
        disposeBag = DisposeBag()
        self.collectionViewModel.errorMessage.subscribe(onNext: {
            [weak self] err in
            if err == HTTPError.EndProductList{
                self?.errorAlterViewModel.errorMessageObserver.onNext("마지막 상품입니다")
            }
        }).disposed(by:disposeBag )
        print("\(String(describing: self)) INIT")
    }
    deinit {
        print("\(String(describing: self)) DEINIT")
    }
}
