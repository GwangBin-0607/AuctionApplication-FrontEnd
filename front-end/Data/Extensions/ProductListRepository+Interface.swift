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
final class ProductListRepository:ProductListRepositoryInterface{
    private enum TransferError:Error{
        case DecodeError
        case EncodeError
    }
    //MARK: OUTPUT
    let productListObservable:Observable<Result<[Product],Error>>
    let requestObserver:AnyObserver<Void>
    private let httpService:GetProductsList
    private let streamingProductPrice:SocketNetworkInterface
    private let socketDataTransfer:TCPStreamDataTransferInterface
    private let productListState:ProductListStateInterface
    private let disposeBag:DisposeBag
    let sendThread = DispatchQueue(label: "sendThread")
    init(ApiService:GetProductsList,StreamingService:SocketNetworkInterface,TCPStreamDataTransfer:TCPStreamDataTransferInterface,
         ProductListState:ProductListStateInterface) {
        productListState = ProductListState
        socketDataTransfer = TCPStreamDataTransfer
        disposeBag = DisposeBag()
        httpService = ApiService
        streamingProductPrice = StreamingService
        let resultProductSubject = BehaviorSubject<Result<[Product],Error>>(value: .success([]))
        let resultProductObserver = resultProductSubject.asObserver()
        productListObservable = resultProductSubject.asObservable()
        let requestSubject = PublishSubject<Void>()
        let requestObservable = requestSubject.asObservable()
        requestObserver = requestSubject.asObserver()
        let updateStreamState = PublishSubject<Void>()
        let updateStreamStateObserver = updateStreamState.asObserver()
        
        Observable.combineLatest(updateStreamState,streamingProductPrice.isSocketConnect.distinctUntilChanged(), resultSelector: {
            [weak self] _,connectState -> StreamStateData? in
            guard let stateNumber = self?.productListState.returnTCPState()else{
                return nil
            }
            if connectState != .connect{
                return nil
            }else{
                let streamState = StreamStateData(stateNumber: stateNumber)
                return streamState
            }
        }).withUnretained(self).flatMap({
            owner,streamState in
            owner.updateStreamState(state: streamState)
        }).withUnretained(self).subscribe(onNext: {
            owner,result in
            owner.productListState.updateTCPState(result: result)
        }).disposed(by: disposeBag)
        
        let listQueue = DispatchQueue(label: "productListSerialQueue")
        
        let httpObservable = requestObservable
            .withUnretained(self)
            .map({ tuple in
                let (owner,_) = tuple
                return owner.productListState.returnHttpState()
            })
            .withUnretained(self)
            .flatMap({
                owner,requestNum in
                return owner.transferDataToProductList(requestNum:requestNum)
                
            })
        
        httpObservable.observe(on: SerialDispatchQueueScheduler(queue: listQueue, internalSerialQueueName: "productListSerialQeue")).withUnretained(self).withLatestFrom(resultProductSubject, resultSelector: {
            arg,beforeList in
            
            let (owner,afterList) = arg
            let re = owner.addResult(before: beforeList, after: afterList)
            return (owner,re)
            
        }).subscribe(onNext: {
            result in
            let (owner,resultList) = result
            owner.productListState.updateHTTPState()
            resultProductSubject.onNext(resultList)
            updateStreamStateObserver.onNext(())
        }).disposed(by: disposeBag)
        streamingProductPrice.inputDataObservable.map(socketDataTransfer.decode(result:)).withUnretained(self).withLatestFrom(resultProductSubject, resultSelector: {
            (arg1,list) in
            let (owner,result) = arg1
            let sumResult = owner.sumResult(before: list, after: result)
            return sumResult
        })
        .observe(on: SerialDispatchQueueScheduler(queue: listQueue, internalSerialQueueName: "productListSerialQeue"))
        .subscribe(onNext:resultProductObserver.onNext)
        .disposed(by: disposeBag)

        print("\(String(describing: self)) INIT")
    }
    deinit {
        print("\(String(describing: self)) DEINIT")
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
        case (.success(let result), .failure(_)):
            return .success(result)
        }
    }
    
    private func sumResult(before:Result<[Product],Error>,after:Result<[StreamPrice],Error>)->Result<[Product],Error>{
        
        switch (before,after){
        case (.success(var productList),.success(let streamList)):
            changeProductPrice(before: &productList, after: streamList)
            return .success(productList)
        case (.success(let productList),.failure(_)):
            return .success(productList)
        case (.failure(let err), _):
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
    private func returnData(requestNum:Int) -> Observable<Data> {
        return Observable.create { [weak self] observer in
            
            self?.httpService.getProductData(requestNum:requestNum) { result in
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
    
    private func transferDataToProductList(requestNum:Int) -> Observable<Result<[Product],Error>>{
        returnData(requestNum: requestNum).map { Data in
            guard let response = try? JSONDecoder().decode([Product].self, from: Data)else{
                throw NSError(domain: "Decoding Error", code: -1, userInfo: nil)
            }
            return .success(response)
        }.catch{.just(.failure($0))}
    }
}
extension ProductListRepository{
    func sendData(output data:Encodable)->Observable<Result<Bool,Error>>{
        return encodeAndSend(data: data)
    }
    private func encodeAndSend(data:Encodable)->Observable<Result<Bool,Error>>{
        return Observable<Result<Bool,Error>>.create { [weak self] observer in
            guard let self = self,
                  let (completionId,data) = try? self.socketDataTransfer.encodeOutputStreamState(dataType: .StreamStateUpdate, output: data)
            else{
                observer.onNext(.failure(SocketOutputError.EncodeError))
                observer.onCompleted()
                return Disposables.create()
            }
            self.socketDataTransfer.register(completion:  {
                result in
                observer.onNext(result)
                observer.onCompleted()
            })
            self.streamingProductPrice.sendData(data: data, completion: {
                error in
                if let error = error{
                    self.socketDataTransfer.executeIfSendError(completionId: completionId, error: error)
                }
            })
            return Disposables.create()

        }.subscribe(on: ConcurrentDispatchQueueScheduler(queue: sendThread))
    }
    private func updateStreamState(state:StreamStateData?)->Observable<Result<Bool,Error>>{
        if let state = state{
           return sendData(output: state)
        }else{
            let error = NSError(domain: "Not Connect", code: -1)
            return Observable<Result<Bool,Error>>.just(.failure(error))
        }
    }
}
