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
    }
    
    func decode(result:Result<Data,Error>)->Result<[StreamPrice],Error>{
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
            if returnArray.count == 0{
                let error = NSError(domain: "No StreamPrice Data", code: -1)
                return .failure(error)
            }else{
                return .success(returnArray)
            }
        case .failure(let error):
            return .failure(error)
            
        }
    }
    func encodeAndSend(socketNetwork:SocketNetworkInterface,dataType:StreamDataType,data:Encodable,completion:@escaping (Error?)->Void)->Observable<Error?>{
        return Observable<Error?>.create { [weak self,weak socketNetwork] observer in
            if let completionId = self?.socketCompletionHandler.returnCurrentCompletionId(),
               let outputDataType = data as? StreamStateData,
               let data = try? self?.socketOutput.encodeOutputStreamState(dataType: dataType, completionId: completionId, output: outputDataType){
                self?.socketCompletionHandler.registerCompletion(completion: completion)
                socketNetwork?.sendData(data: data, completion: {
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
}
