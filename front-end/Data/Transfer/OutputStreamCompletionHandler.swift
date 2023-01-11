//
//  SocketNetworkUtils.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/03.
//

import Foundation
protocol OutputStreamCompletionHandlerInterface{
    func registerCompletion(completion:@escaping(Error?)->Void)
    func executeCompletion(completionId:Int16)
    func removeAllWhenEncounter()
    func removeCompleted(completionId:Int16)
    func returnCurrentCompletionId()->Int16
}
class OutputStreamCompletionHandler{
    let threadLock:NSLock
    init() {
        self.threadLock = NSLock()
    }
    private var completionId:Int16=0
    private var completionHandler:Dictionary<Int16,(Error?)->Void>=[:]
}
extension OutputStreamCompletionHandler:OutputStreamCompletionHandlerInterface{
    func removeAllWhenEncounter() {
        completionHandler.removeAll()
    }
    func registerCompletion(completion: @escaping (Error?) -> Void) {
        threadLock.lock()
        defer{
            threadLock.unlock()
        }
        completionHandler[completionId] = completion
        updateCompletionId()
    }
    private func updateCompletionId(){
        completionId += 1
    }
    func executeCompletion(completionId: Int16) {
        threadLock.lock()
        defer{
            threadLock.unlock()
        }
        guard let completionHandler = completionHandler[completionId]else{
            return
        }
        completionHandler(nil)
        removeCompleted(completionId: completionId)
    }
    func removeCompleted(completionId:Int16){
        completionHandler.removeValue(forKey: completionId)
    }
    func returnCurrentCompletionId() -> Int16 {
        completionId
    }
}
