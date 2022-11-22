//
//  FetchProductRepository+FetchingProducts.swift
//  front-end
//
//  Created by 안광빈 on 2022/10/26.
//

import Foundation
import RxSwift


extension ProductsListRepository:FetchingProductsListData{
    
    func returnData(lastNumber:Int) -> Observable<Data> {
        return Observable.create { [weak self] observer in
            self?.apiService.getProductData(lastNumber:lastNumber) { result in
                switch result {
                case let .success(data):
                    observer.onNext(data)
                    observer.onCompleted()
                case let .failure(error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }.subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        
    }

    
}
