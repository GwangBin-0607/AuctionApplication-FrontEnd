//
//  ProductListRepo.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/10.
//

import Foundation
import RxSwift
final class TCPStreamDataTransfer:TCPStreamDataTransferInterface{
    let socketInput:InputStreamDataTransferInterface
    let socketOutput:OutputStreamDataTransferInterface
    let socketCompletionHandler:OutputStreamCompletionHandlerInterface
    init() {
        self.socketInput = InputStreamDataTransfer()
        self.socketOutput = OutputStreamDataTransfer()
        self.socketCompletionHandler = OutputStreamCompletionHandler()
        print("\(String(describing: self)) INIT")
    }
    deinit {
        print("\(String(describing: self)) DEINIT")
    }
    
    func decode(result:Result<Data,Error>)->Result<[StreamPrice],Error>{
        switch result{
        case .success(let data):
            return socketInput.decode(completioHandler: socketCompletionHandler, data: data)
        case .failure(let error):
            socketCompletionHandler.removeAllWhenEncounter()
            return .failure(error)
            
        }
    }
    func encodeAndSend(socketNetwork:SocketNetworkInterface,dataType:StreamDataType,data:Encodable)->Observable<Result<Decodable,Error>>{
        return Observable<Result<Decodable,Error>>.create { [weak self,weak socketNetwork] observer in
            if let completionId = self?.socketCompletionHandler.returnCurrentCompletionId(),
               let outputDataType = data as? StreamStateData,
               let outputData = try? self?.socketOutput.encodeOutputStreamState(dataType: dataType, completionId: completionId, output: outputDataType){
                self?.socketCompletionHandler.registerCompletion(completion: {
                    result in
                    observer.onNext(result)
                    observer.onCompleted()
                },setTimeOut: 10)
                socketNetwork?.sendData(data: outputData, completion: {
                    error in
                    if let error = error{
                        observer.onNext(.failure(error))
                        observer.onCompleted()
                    }
                })
                return Disposables.create()
            }else{
                observer.onNext(.failure(SocketOutputError.EncodeError))
                observer.onCompleted()
                return Disposables.create()
            }

        }
    }
}
