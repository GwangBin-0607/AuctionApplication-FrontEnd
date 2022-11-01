//
//  ProductListViewModel.swift
//  front-end
//
//  Created by 안광빈 on 2022/10/26.
//

import Foundation
import RxSwift

final class ProductsListViewModel:BindingProductsListViewModel{
    private let usecase:ShowProductsList
    private let disposeBag=DisposeBag()
    let products: Observable<[Product]>
    let requestProductsList: AnyObserver<Int>
    init(UseCase:ShowProductsList) {
        self.usecase = UseCase
        let requesting = PublishSubject<Int>()
        requestProductsList = requesting.asObserver()
        products = requesting.flatMap(usecase.request)
       
    }
}
