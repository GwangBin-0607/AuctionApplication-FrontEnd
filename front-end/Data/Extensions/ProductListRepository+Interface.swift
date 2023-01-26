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
    //MARK: OUTPUT
    private let httpService:GetProductsList
    private let streamingProductPrice:SocketNetworkInterface
    private let socketDataTransfer:TCPStreamDataTransferInterface
    private let productListState:ProductListStateInterface
    private let disposeBag:DisposeBag
    
    private let updateStreamStateObserver:AnyObserver<Void>
    let streamingList:Observable<Result<[StreamPrice],Error>>
    init(ApiService:GetProductsList,StreamingService:SocketNetworkInterface,TCPStreamDataTransfer:TCPStreamDataTransferInterface,
         ProductListState:ProductListStateInterface) {
        productListState = ProductListState
        socketDataTransfer = TCPStreamDataTransfer
        disposeBag = DisposeBag()
        httpService = ApiService
        streamingProductPrice = StreamingService
        let updateStreamState = PublishSubject<Void>()
        updateStreamStateObserver = updateStreamState.asObserver()
        streamingList = streamingProductPrice.inputDataObservable.map(socketDataTransfer.decode(result:))
        
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
            switch result {
            case .success(let checkStatus):
                if checkStatus {
                    owner.productListState.updateTCPState()
                }
            case .failure(_):
                break;
            }
        }).disposed(by: disposeBag)

        print("\(String(describing: self)) INIT")
    }
    deinit {
        print("\(String(describing: self)) DEINIT")
    }

}
extension ProductListRepository{
    private func returnData(requestNum:Int8) -> Observable<Data> {
        return Observable.create { [weak self] observer in
            print(Thread.current)
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
    func httpList()->Observable<Result<[Product],Error>>{
        let requestNum = productListState.returnHttpState()
        return returnData(requestNum: requestNum).map { Data in
            guard let response = try? JSONDecoder().decode([Product].self, from: Data)else{
                throw NSError(domain: "Decoding Error", code: -1, userInfo: nil)
            }
            return .success(response)
        }.catch{.just(.failure($0))}.do(onNext: {
            [weak self] result in
            switch result{
            case .success(_):
                self?.productListState.updateHTTPState()
                self?.updateStreamStateObserver.onNext(())
            case .failure(_):
                break;
            }
        })
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
        }.subscribe(on: SerialDispatchQueueScheduler(internalSerialQueueName: "sendThread"))
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
