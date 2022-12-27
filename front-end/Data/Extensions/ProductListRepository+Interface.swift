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
        streamingProductPrice.controlSocketConnect.onNext(state)
    }
    
    func observableSteamState() -> Observable<isConnecting> {
        return streamingProductPrice.isSocketConnect
    }
}
class ProductListState{
    var num = 1
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
    private let streamingProductPrice:SocketNetworkInterface
    private let disposeBag:DisposeBag
    private let productListState:ProductListState
    var startTime:CFAbsoluteTime!
    init(ApiService:GetProductsList,StreamingService:SocketNetworkInterface) {
        print("Repo Init")
        productListState = ProductListState()
        disposeBag = DisposeBag()
        apiService = ApiService
        streamingProductPrice = StreamingService
        let resultProductSubject = PublishSubject<Result<[Product],Error>>()
        let resultProductObserver = resultProductSubject.asObserver()
        productListObservable = resultProductSubject.asObservable()
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
                aaa,arg1 in
                let (owner,b) = arg1
                let re = owner.addResult(before: aaa, after: b)
                return re
            })
            .withUnretained(self)
            .subscribe(onNext: {
                Owner,result in
                switch result {
                case .success(_):
                    resultProductObserver.onNext(result)
                case .failure(_):
                    resultProductObserver.onNext(result)
                }
            }).disposed(by: disposeBag)
        
        streamingProductPrice.inputDataObservable.withUnretained(self).withLatestFrom(resultProductSubject, resultSelector: {
            (arg1,list) in
            print("======")
            let (owner, data) = arg1
            let streamProductPrice = owner.decodeProductPriceData(data: data)
            let result = owner.sumResult(before: list, after: streamProductPrice)
            return result
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
        case (.failure(let err), _):
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
    func test_Add(){
        requestObserver.onNext(())
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
            let lastNumber = self?.productListState.num
            
            self?.apiService.getProductData(lastNumber:lastNumber) { result in
                switch result {
                case let .success(data):
                    self?.productListState.num += 1
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
    func buyProduct(output productPrice:StreamPrice) {
        let jsonEncoder = JSONEncoder()
        do{
            let data = try jsonEncoder.encode(productPrice)
            streamingProductPrice.outputDataObserver.onNext(data)
        }catch{
            print(error)
            streamingProductPrice.outputDataObserver.onNext(nil)
        }
    }
}
