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
    init(inputStreamDataTransfer:InputStreamDataTransferInterface,outputStreamDataTransfer:OutputStreamDataTransferInterface,outputStreamCompletionHandler:OutputStreamCompletionHandlerInterface) {
        self.socketInput = inputStreamDataTransfer
        self.socketOutput = outputStreamDataTransfer
        self.socketCompletionHandler = outputStreamCompletionHandler
        print("\(String(describing: self)) INIT")
    }
    deinit {
        print("\(String(describing: self)) DEINIT")
    }
    
    func decode(result:Result<Data,Error>)->Result<[StreamPrice],Error>{
        switch result{
        case .success(let data):
            var returnArray:[StreamPrice]=[]
            do{
                let inputData = try socketInput.decodeInputStreamDataType(data: data)
                inputData.forEach { inputStreamData in
                    switch inputStreamData.dataType{
                    case .StreamProductPriceUpdate:
                        if let inputStream = inputStreamData.data as? [StreamPrice]{
                            addResultArray(original: &returnArray, added: inputStream)
                        }
                    case .StreamStateUpdate,.InitStreamState:
                        if let resultData = inputStreamData.data as? ResultOutputStreamReaded{
                            socketCompletionHandler.executeCompletionExtension(completionId: resultData.completionId,data: resultData.result)
                        }
                    }
                }
                if returnArray.count == 0{
                    let error = NSError(domain: "No StreamPrice Data", code: -1)
                    return .failure(error)
                }else{
                    return .success(returnArray)
                }
            }catch{
                print(error)
                return .failure(error)
            }
        case .failure(let error):
            socketCompletionHandler.removeAllWhenEncounter()
            return .failure(error)
            
        }
    }
    private func addResultArray(original:inout[StreamPrice],added:[StreamPrice]){
        original = original+added
    }
    func encodeOutputStreamState(dataType:StreamDataType,output:Encodable)throws -> (Int16,Data){
        let completionId = socketCompletionHandler.returnCurrentCompletionId()
        return try (completionId,socketOutput.encodeOutputStreamState(dataType: dataType, completionId: completionId, output: output))
    }
    func register(completion:@escaping(Result<Bool,Error>)->Void){
        socketCompletionHandler.registerCompletion(completion:completion)
    }
    func executeIfSendError(completionId:Int16,error:Error){
        socketCompletionHandler.executeCompletionExtension(completionId: completionId,error: error)
    }
}
