//
//  FetchProductRepository+FetchingProducts.swift
//  front-end
//
//  Created by 안광빈 on 2022/10/26.
//

import Foundation
import RxSwift


extension ProductsListRepository:TransferProductsListData{
    private func returnData(lastNumber:Int) -> Observable<Data> {
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
    func transferDataToProductList(lastNumber: Int) -> Observable<Result<[Product],Error>>{
        returnData(lastNumber: 1).map { Data in
            guard let response = try? JSONDecoder().decode([Product].self, from: Data)else{
                throw NSError(domain: "Decoding Error", code: -1, userInfo: nil)
            }
                return .success(response)
            }.catch{.just(.failure($0))}
    }

    
}
