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
    private let httpTransfer:Pr_HTTPDataTransfer
    let streamingList:Observable<Result<[StreamPrice],StreamError>>
    init(ApiService:GetProductsList,StreamingService:SocketNetworkInterface,TCPStreamDataTransfer:TCPStreamDataTransferInterface,
         ProductListState:ProductListStateInterface,HTTPDataTransfer:Pr_HTTPDataTransfer) {
        productListState = ProductListState
        socketDataTransfer = TCPStreamDataTransfer
        disposeBag = DisposeBag()
        httpService = ApiService
        streamingProductPrice = StreamingService
        let updateStreamState = PublishSubject<Void>()
        updateStreamStateObserver = updateStreamState.asObserver()
        streamingList = streamingProductPrice.inputDataObservable.map(socketDataTransfer.decode(result:))
        httpTransfer = HTTPDataTransfer
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
    private func returnData(requestNum:Int8) -> Observable<Result<Data,HTTPError>> {
        return Observable.create { [weak self] observer in
            let requestProductListData = RequestProductListData(index: requestNum)
            if let data = try? self?.httpTransfer.requestProductList(requestData: requestProductListData){
                self?.httpService.getProductData(requestData:data) { result in
                    observer.onNext(result)
                    observer.onCompleted()
                }
            }else{
                observer.onCompleted()
            }
            return Disposables.create()
        }.subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        
    }
    func httpList()->Observable<Result<[Product],HTTPError>>{
        let requestNum = productListState.returnHttpState()
        return returnData(requestNum: requestNum).withUnretained(self).map {
            owner,result in
            switch result{
            case .success(let data):
                do{
                    let response = try owner.httpTransfer.responseProductList(data: data)
                    return .success(response)
                }catch{
                    return .failure(HTTPError.DecodeError)
                }
            case .failure(let error):
                return .failure(error)
            }
        }.do(onNext: {
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
    func sendData(output data:Encodable)->Observable<Result<Bool,StreamError>>{
        return encodeAndSend(data: data)
    }
    private func encodeAndSend(data:Encodable)->Observable<Result<Bool,StreamError>>{
        return Observable<Result<Bool,StreamError>>.create { [weak self] observer in
            guard let self = self,
                  let (completionId,data) = try? self.socketDataTransfer.encodeOutputStreamState(dataType: .SocketStatusUpdate, output: data)
            else{
                observer.onNext(.failure(StreamError.EncodeError))
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
    private func updateStreamState(state:StreamStateData?)->Observable<Result<Bool,StreamError>>{
        if let state = state{
           return sendData(output: state)
        }else{
            return Observable<Result<Bool,StreamError>>.just(.failure(StreamError.Disconnected))
        }
    }
}
