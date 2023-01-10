//
//  SocketAdd.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/09.
//

import Foundation
import RxSwift
protocol ProductListRepositoryTransferInterface{
    var inputDataObservable:Observable<Result<[StreamPrice],Error>>{get}
    var controlSocketState:AnyObserver<isConnecting>{get}
    var isSocketState:Observable<SocketConnectState>{get}
    func sendData(data:Encodable,completion:@escaping(Error?)->Void)->Observable<Error?>
}
