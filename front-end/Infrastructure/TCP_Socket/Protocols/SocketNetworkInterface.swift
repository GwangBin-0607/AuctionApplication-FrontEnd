//
//  StreamingProductPrice.swift
//  front-end
//
//  Created by 안광빈 on 2022/11/16.
//

import Foundation
import RxSwift

protocol SocketNetworkInterface{
    // MARK: INPUT
    var controlSocketConnect:AnyObserver<isConnecting>{get}
    // MARK: OUTPUT
    var inputDataObservable:Observable<Result<Decodable,Error>>{get}
    var isSocketConnect: Observable<SocketConnectState>{get}
    func sendData(data:Encodable,completion:@escaping (Error?) -> Void)
}
