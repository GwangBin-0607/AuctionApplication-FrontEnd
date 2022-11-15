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
    // MARK: VIEWCONTROLLER OUTPUT
    let productsList: Observable<[Product]>
    // MARK: VIEWCONTROLLER INPUT
    let requestProductsList: AnyObserver<Int>
    init(UseCase:ShowProductsList) {
        self.usecase = UseCase
        let requesting = PublishSubject<Int>()
        let products = BehaviorSubject<[Product]>(value: [])
        requestProductsList = requesting.asObserver()
        
        requesting.flatMap(usecase.request)
            .subscribe(onNext: {
                fetchResult in
                switch fetchResult{
                case .success(let productList):
                    if let value = try? products.value(){
                        products.onNext(value+productList)
                    }else{
                        products.onNext(productList)
                    }
                case .failure(let error):
                    print(error)
                }
            }).disposed(by: disposeBag)
        
        
        productsList = products.asObservable()
                
    }
}
