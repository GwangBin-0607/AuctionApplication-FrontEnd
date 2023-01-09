//
//  SocketAdd.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/09.
//

import Foundation
import RxSwift
protocol SocketAddInterface{
    associatedtype DataType
    var inputDataObservable:Observable<Result<[DataType],Error>>!{get set}
    var controlSocketState:AnyObserver<isConnecting>{get}
    var isSocketState:Observable<SocketConnectState>{get}
    func sendData(data:Encodable,completion:@escaping(Error?)->Void)->Observable<Error?>
}

class SocketAdd<DecodeDataType:Decodable>:SocketAddInterface{
    var inputDataObservable: Observable<Result<[DataType], Error>>!
    
    let controlSocketState: AnyObserver<isConnecting>
    
    let isSocketState: Observable<SocketConnectState>
    
    typealias DataType = DecodeDataType
    
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
    
    private func decode(result:Result<Data,Error>)->Result<[DataType],Error>{
        switch result{
        case .success(let data):
            var returnArray:[DataType]=[]
            let inputData = try? socketInput.decodeInputStreamDataType(data: data)
            inputData?.forEach { inputStreamData in
                switch inputStreamData.dataType{
                case .InputStreamProductPrice:
                    if let inputStream = inputStreamData.data as? DataType{
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

        }
    }
    func sendData(data:Encodable,completion:@escaping(Error?)->Void)->Observable<Error?>{
        encode(dataType: .OutputStreamReaded, data: data, completion: completion)
    }
    
}
