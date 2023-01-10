//
//  ProductsListRepository.swift
//  front-end
//
//  Created by 안광빈 on 2022/12/21.
//

import Foundation
import RxSwift
extension ProductListRepository{
    func streamState(state: isConnecting) {
        streamingProductPrice.controlSocketState.onNext(state)
    }
    
    func observableSteamState() -> Observable<SocketConnectState> {
        return streamingProductPrice.isSocketState
    }
}
final class ProductListRepository:ProductListRepositoryInterface{
    private enum TransferError:Error{
        case DecodeError
        case EncodeError
    }
    //MARK: OUTPUT
    let productListObservable:Observable<Result<[Product],Error>>
    let requestObserver:AnyObserver<Void>
    private let apiService:GetProductsList
    private let streamingProductPrice:ProductListRepositoryTransferInterface
    private let disposeBag:DisposeBag
    init(ApiService:GetProductsList,StreamingServiceTransfer:ProductListRepositoryTransferInterface) {
        print("Repo Init")
        disposeBag = DisposeBag()
        apiService = ApiService
        streamingProductPrice = StreamingServiceTransfer
        let queue = DispatchQueue(label: "testQueue")
        let resultProductSubject = PublishSubject<Result<[Product],Error>>()
        let resultProductObserver = resultProductSubject.asObserver()
        productListObservable = resultProductSubject.asObservable().observe(on: SerialDispatchQueueScheduler(queue: queue, internalSerialQueueName: "a"))
        let requestSubject = PublishSubject<Void>()
        let requestObservable = requestSubject.asObservable()
        requestObserver = requestSubject.asObserver()
        requestObservable
            .withUnretained(self)
            .flatMap({
                owner,_ in
                owner.transferDataToProductList()
                
            })
            .withUnretained(self)
            .scan(Result<[Product],Error>.success([]), accumulator: {
                seed,arg1 in
                let (owner,newValue) = arg1
                let re = owner.addResult(before: seed, after: newValue)
                return re
            })
            .subscribe(onNext:resultProductObserver.onNext).disposed(by: disposeBag)
        streamingProductPrice.inputDataObservable.withUnretained(self).withLatestFrom(resultProductSubject, resultSelector: {
            (arg1,list) in
            print("===&&&&&&&&&&&&&&&&&====")
            let (owner,result) = arg1
            let sumResult = owner.sumResult(before: list, after: result)
            return sumResult
        }).subscribe(onNext:resultProductObserver.onNext)
            .disposed(by: disposeBag)
    }
    deinit {
        print("REPO DEINIT")
    }
    private func addResult(before:Result<[Product],Error>,after:Result<[Product],Error>)->Result<[Product],Error>{
        switch (before,after){
        case (.success(var beforeArray),.success(let afterArray)):
            addArray(array: &beforeArray, addArray: afterArray)
            return .success(beforeArray)
        case (.failure(_),.success(let array)):
            return .success(array)
        case (.failure(let err),.failure(_)):
            return .failure(err)
        case (_, .failure(let err)):
            return .failure(err)
        }
    }
    
    private func sumResult(before:Result<[Product],Error>,after:Result<[StreamPrice],Error>)->Result<[Product],Error>{
        
        switch (before,after){
        case (.success(var productList),.success(let streamList)):
            changeProductPrice(before: &productList, after: streamList)
            return .success(productList)
        case (.failure(let err), _):
            return .failure(err)
        case (_, .failure(let err)):
            return .failure(err)
        }
    }
    private func decodeProductPriceData(data:Data)->Result<[StreamPrice],Error>{
        guard let response = try? JSONDecoder().decode([StreamPrice].self, from: data) else{
            return .failure(ProductListRepository.TransferError.DecodeError)
        }
        return .success(response)
    }
    private func changeProductPrice(before:inout [Product],after:[StreamPrice]){
        
        for i in 0..<after.count{
            for j in 0..<before.count{
                
                if(after[i].product_id == before[j].product_id && after[i].product_price != before[j].product_price){
                    before[j].product_price = after[i].product_price
                }
            }
            
        }
    }
}
extension ProductListRepository{
    private func returnData() -> Observable<Data> {
        return Observable.create { [weak self] observer in
            
            self?.apiService.getProductData() { result in
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
    
    private func addArray(array:inout [Product],addArray:[Product]){
        array.append(contentsOf:addArray)
    }
    
    private func transferDataToProductList() -> Observable<Result<[Product],Error>>{
        returnData().map { Data in
            guard let response = try? JSONDecoder().decode([Product].self, from: Data)else{
                throw NSError(domain: "Decoding Error", code: -1, userInfo: nil)
            }
            return .success(response)
        }.catch{.just(.failure($0))}
    }
}
extension ProductListRepository{
    func sendData(output data:Encodable,completion:@escaping(Error?)->Void)->Observable<Error?>{
        return streamingProductPrice.sendData(data: data, completion: completion)
    }
}
