//
//  StreamingProductPrice.swift
//  front-end
//
//  Created by 안광빈 on 2022/11/16.
//

import Foundation
import RxSwift

protocol SocketNetworkInterface:AnyObject{
    // MARK: INPUT
    var controlSocketConnect:AnyObserver<isConnecting>{get}
    // MARK: OUTPUT
    var inputDataObservable:Observable<Result<Data,StreamError>>{get}
    var isSocketConnect: Observable<isConnecting>{get}
    func sendData(data:Data,completion:@escaping (StreamError?) -> Void)
}
