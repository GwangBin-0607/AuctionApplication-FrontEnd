//
//  DetailProductRepository+Interface.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/17.
//

import Foundation
import RxSwift
final class CurrentProductPriceRepository{
    private let httpService:GetCurrentProductPrice
    private let httpCurrentProductPriceTransfer:Pr_HTTPDataTransferCurrentProductPrice
    private let streamService:SocketNetworkInterface
    private let streamTransferData:TCPStreamDataTransferInterface
    let streamingCurrentProduct: Observable<Result<[StreamPrice], StreamError>>
    init(httpService:GetCurrentProductPrice,httpCurrentProductPriceTransfer:Pr_HTTPDataTransferCurrentProductPrice,streamTransferData:TCPStreamDataTransferInterface,streamService:SocketNetworkInterface,product_id:Int) {
        self.streamTransferData = streamTransferData
        self.httpService = httpService
        self.httpCurrentProductPriceTransfer = httpCurrentProductPriceTransfer
        self.streamService = streamService
        streamingCurrentProduct = self.streamService.inputDataObservable.map(streamTransferData.decode(result:)).map({
            result in
            switch result {
            case .success(let streamProduct):
                let productPrice = streamProduct.filter{$0.product_id == product_id}
                return .success(productPrice)
            case .failure(let error):
                return .failure(error)
            }
        })
        
    }
}
extension CurrentProductPriceRepository:Pr_CurrentProductPriceRepository{
    func httpDetailProduct(productId: Int) -> Observable<Result<CurrentProductPrice, HTTPError>> {
        guard let data = try? httpCurrentProductPriceTransfer.requestDetailProduct(requestData: RequestCurrentProductPriceData(product_id: productId)) else{
            return Observable<Result<CurrentProductPrice,HTTPError>>.create { ob in
                ob.onNext(.failure(HTTPError.DataError))
                ob.onCompleted()
                return Disposables.create()
            }
        }
        return Observable<Result<CurrentProductPrice,HTTPError>>.create {
            [weak self] ob in
            self?.httpService.getCurrentProductPrice(requestData: data, onComplete: {
                result in
                switch result {
                case .success(let data):
                    do{
                        let product = try self!.httpCurrentProductPriceTransfer.responseDetailProduct(data: data)
                        ob.onNext(.success(product))
                    }catch{
                        ob.onNext(.failure(.DecodeError))
                    }
                    ob.onCompleted()
                case .failure(let error):
                    ob.onNext(.failure(error))
                    ob.onCompleted()
                    
                }
            })
            return Disposables.create()
        }
    }
    func sendData(output data:Encodable,dataType:OutputStreamDataType)->Observable<Result<Bool,StreamError>>{
        return encodeAndSend(data: data,dataType: dataType)
    }
    private func encodeAndSend(data:Encodable,dataType:OutputStreamDataType)->Observable<Result<Bool,StreamError>>{
        return Observable<Result<Bool,StreamError>>.create { [weak self] observer in
            guard let self = self,
                  let (completionId,data) = try? self.streamTransferData.encodeOutputStreamState(dataType: dataType, output: data)
            else{
                observer.onNext(.failure(StreamError.EncodeError))
                observer.onCompleted()
                return Disposables.create()
            }
            self.streamTransferData.register(completion:  {
                result in
                observer.onNext(result)
                observer.onCompleted()
            })
            self.streamService.sendData(data: data, completion: {
                error in
                if let error = error{
                    self.streamTransferData.executeIfSendError(completionId: completionId, error: error)
                }
            })
            return Disposables.create()
        }.subscribe(on: SerialDispatchQueueScheduler(internalSerialQueueName: "sendThread"))
    }
    func updateProductPrice(user_id: Int, product_id: Int, product_price: Int) -> Observable<Result<Bool, StreamError>> {
        sendData(output: UpdateStreamProductPriceData(product_id: product_id, product_price: product_price, user_id: user_id),dataType: .StreamProductPriceUpdate)
    }
}
