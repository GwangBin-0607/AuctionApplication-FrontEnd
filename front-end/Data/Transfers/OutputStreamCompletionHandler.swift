//
//  SocketNetworkUtils.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/03.
//

import Foundation
protocol ExecuteOutputStreamCompletionHandlerInterface:AnyObject{
    func executeCompletion(completionId: Int16,data:ResultData?,error:Error?)
}

extension ExecuteOutputStreamCompletionHandlerInterface{
    func executeCompletionExtension(completionId:Int16,data:ResultData? = nil,error:Error? = nil){
        executeCompletion(completionId: completionId, data: data, error: error)
    }
}

protocol ManageOutputStreamCompletionHandlerInterface{
    typealias completionType = ((Result<ResultData,Error>)->Void)?
    func registerCompletion(completion:completionType)
    func removeAllWhenEncounter()
    func returnCurrentCompletionId()->Int16
}

typealias OutputStreamCompletionHandlerInterface = ManageOutputStreamCompletionHandlerInterface&ExecuteOutputStreamCompletionHandlerInterface

class OutputStreamCompletionHandler{
    private let threadLock:NSLock
    private var completionId:Int16=0
    private var completionHandler:Dictionary<Int16,CustomCompletion>=[:]
    init() {
        self.threadLock = NSLock()
        print("\(String(describing: self)) INIT")
    }
    deinit {
        print("\(String(describing: self)) DEINIT")
    }
}
extension OutputStreamCompletionHandler{
    class CustomCompletion{
        let completion:completionType
        let completionId:Int16
        init(Completion:completionType,CompletionId:Int16) {
            completionId = CompletionId
            completion = Completion
            print("\(String(describing: self)) INIT")
        }
        deinit {
            print("\(String(describing: self)) DEINIT")
        }
    }
}
extension OutputStreamCompletionHandler:OutputStreamCompletionHandlerInterface{
    func executeCompletion(completionId: Int16, data: ResultData?, error: Error?) {
        threadLock.lock()
        defer{
            threadLock.unlock()
        }
        guard let completionHandler = completionHandler[completionId]else{
            return
        }
        if let data = data{
            completionHandler.completion?(.success(data))
        }else if let error = error{
            completionHandler.completion?(.failure(error))
        }
        removeCompleted(completionId: completionId)
    }
    
    func removeAllWhenEncounter() {
        completionHandler.forEach { key,value in
            let error = NSError(domain: "Encounter Server", code: -1)
            executeCompletionExtension(completionId: key,error: error)
        }
    }
    func registerCompletion(completion: completionType) {
        threadLock.lock()
        defer{
            threadLock.unlock()
        }
        let customCompletion = CustomCompletion(Completion: completion, CompletionId: completionId)
        completionHandler[completionId] = customCompletion
        updateCompletionId()
    }
    private func updateCompletionId(){
        completionId += 1
    }
    private func removeCompleted(completionId:Int16){
        completionHandler.removeValue(forKey: completionId)
    }
    func returnCurrentCompletionId() -> Int16 {
        completionId
    }
}
