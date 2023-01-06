//
//  SocketNetworkUtils.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/03.
//

import Foundation
protocol OutputStreamCompletionHandlerInterface{
    func registerCompletion(completion:@escaping()->Void)
    func executeCompletion(completionId:Int16)
    func removeAllWhenEncounter()
}
class OutputStreamCompletionHandler{
    private var completionId:Int16=0
    private var completionHandler:Dictionary<Int16,()->Void>=[:]
}
extension OutputStreamCompletionHandler:OutputStreamCompletionHandlerInterface{
    func removeAllWhenEncounter() {
        completionHandler.removeAll()
    }
    func registerCompletion(completion: @escaping () -> Void) {
        completionHandler[completionId] = completion
        updateCompletionId()
    }
    private func updateCompletionId(){
        completionId += 1
    }
    func executeCompletion(completionId: Int16) {
        guard let completionHandler = completionHandler[completionId]else{
            return
        }
        completionHandler()
    }
}
