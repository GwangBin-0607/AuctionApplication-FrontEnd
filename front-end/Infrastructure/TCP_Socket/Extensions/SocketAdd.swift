//
//  SocketAdd.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/09.
//

import Foundation
import RxSwift
class SocketAdd<DecodeDataType:Decodable>{
    var inputDataObservable: Observable<Result<[DecodeDataType], Error>>!
    
    let controlSocketState: AnyObserver<isConnecting>
    
    let isSocketState: Observable<SocketConnectState>
    
    let socketNetwork:SocketNetworkInterface
    let socketInput:InputStreamDataTransferInterface
    let socketOutput:OutputStreamDataTransferInterface
    let socketCompletionHandler:OutputStreamCompletionHandlerInterface
    init(socketNetwork: SocketNetworkInterface, socketInput: InputStreamDataTransferInterface, socketOutput: OutputStreamDataTransferInterface, socketCompletionHandler: OutputStreamCompletionHandlerInterface) {
        self.socketNetwork = socketNetwork
        self.socketInput = socketInput
        self.socketOutput = socketOutput
        self.socketCompletionHandler = socketCompletionHandler
        isSocketState = socketNetwork.isSocketConnect
        controlSocketState = socketNetwork.controlSocketConnect
        inputDataObservable = socketNetwork.inputDataObservable.map(decode(result:))
    }
    
    private func decode(result:Result<Data,Error>)->Result<[DecodeDataType],Error>{
        switch result{
        case .success(let data):
            var returnArray:[DecodeDataType]=[]
            let inputData = try? socketInput.decodeInputStreamDataType(data: data)
            inputData?.forEach { inputStreamData in
                switch inputStreamData.dataType{
                case .InputStreamProductPrice:
                    if let inputStream = inputStreamData.data as? DecodeDataType{
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

        }.observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
    }
    func sendData(data:Encodable,completion:@escaping(Error?)->Void)->Observable<Error?>{
        encode(dataType: .OutputStreamReaded, data: data, completion: completion)
    }
    
}
