//
//  ProductListRepo.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/10.
//

import Foundation
import RxSwift
class ProductListRepositoryTransfer:ProductListRepositoryTransferInterface{
    var inputDataObservable: Observable<Result<[StreamPrice], Error>>
    
    let controlSocketState: AnyObserver<isConnecting>
    
    let isSocketState: Observable<SocketConnectState>
    
    let socketNetwork:SocketNetworkInterface
    let socketInput:InputStreamDataTransferInterface
    let socketOutput:OutputStreamDataTransferInterface
    let socketCompletionHandler:OutputStreamCompletionHandlerInterface
    private let disposeBag:DisposeBag
    init(socketNetwork: SocketNetworkInterface) {
        let subject = PublishSubject<Result<[StreamPrice],Error>>()
        disposeBag = DisposeBag()
        self.socketNetwork = socketNetwork
        self.socketInput = InputStreamDataTransfer()
        self.socketOutput = OutputStreamDataTransfer()
        self.socketCompletionHandler = OutputStreamCompletionHandler()
        isSocketState = socketNetwork.isSocketConnect
        controlSocketState = socketNetwork.controlSocketConnect
        inputDataObservable = subject.asObservable()
        socketNetwork.inputDataObservable.map(decode(result:)).subscribe(onNext: {
            result in
            switch result {
            case .success(let list):
                subject.asObserver().onNext(.success(list))
            case .failure(let error):
                subject.asObserver().onNext(.failure(error))
            }
        }).disposed(by: disposeBag)
    }
    
    private func decode(result:Result<Data,Error>)->Result<[StreamPrice],Error>{
        switch result{
        case .success(let data):
            var returnArray:[StreamPrice]=[]
            let inputData = try? socketInput.decodeInputStreamDataType(data: data)
            inputData?.forEach { inputStreamData in
                switch inputStreamData.dataType{
                case .InputStreamProductPrice:
                    if let inputStream = inputStreamData.data as? StreamPrice{
                        returnArray.append(inputStream)
                    }
                case .OutputStreamReaded:
                    if let resultData = inputStreamData.data as? ResultOutputStreamReaded{
                        socketCompletionHandler.executeCompletion(completionId: resultData.completionId)
                    }
                }
            }
            return .success(returnArray)
        case .failure(let error):
            return .failure(error)
            
        }
    }
    let th = DispatchQueue(label: "level")
    private func encode(dataType:StreamDataType,data:Encodable,completion:@escaping (Error?)->Void)->Observable<Error?>{
        return Observable<Error?>.create { [weak self] observer in
            if let completionId = self?.socketCompletionHandler.returnCurrentCompletionId(),
               let data = try? self?.socketOutput.encodeOutputStream(dataType: dataType, completionId: completionId, output: data){
                self?.socketCompletionHandler.registerCompletion(completion: completion)
                self?.socketNetwork.sendData(data: data, completion: {
                    error in
                    if let error = error{
                        self?.socketCompletionHandler.removeCompleted(completionId: completionId)
                        observer.onNext(error)
                    }
                    observer.onCompleted()
                })
                return Disposables.create()
            }else{
                observer.onNext(SocketOutputError.EncodeError)
                observer.onCompleted()
                return Disposables.create()
            }

        }.subscribe(on: ConcurrentDispatchQueueScheduler(queue: th))
    }
    func sendData(data:Encodable,completion:@escaping(Error?)->Void)->Observable<Error?>{
        encode(dataType: .OutputStreamReaded, data: data, completion: completion)
    }
    
}
