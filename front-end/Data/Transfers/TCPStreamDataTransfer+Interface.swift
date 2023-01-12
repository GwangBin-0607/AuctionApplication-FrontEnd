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
            var returnArray:[StreamPrice]=[]
            do{
                let inputData = try socketInput.decodeInputStreamDataType(data: data)
                inputData.forEach { inputStreamData in
                    switch inputStreamData.dataType{
                    case .InputStreamProductPrice:
                        if let inputStream = inputStreamData.data as? StreamPrice{
                            returnArray.append(inputStream)
                        }
                    case .OutputStreamReaded:
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
                return .failure(error)
            }
        case .failure(let error):
            socketCompletionHandler.removeAllWhenEncounter()
            return .failure(error)
            
        }
    }
    func encodeOutputStreamState(dataType:StreamDataType,output:Encodable)throws -> Data{
        let completionId = socketCompletionHandler.returnCurrentCompletionId()
        return try socketOutput.encodeOutputStreamState(dataType: dataType, completionId: completionId, output: output)
    }
    func register(completion:@escaping(Result<ResultData,Error>)->Void,timeOut:Int){
        socketCompletionHandler.registerCompletion(completion:completion,setTimeOut: timeOut)
    }
}
