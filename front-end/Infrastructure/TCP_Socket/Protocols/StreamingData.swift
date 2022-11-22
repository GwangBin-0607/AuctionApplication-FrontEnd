//
//  StreamingProductPrice.swift
//  front-end
//
//  Created by 안광빈 on 2022/11/16.
//

import Foundation
import RxSwift

protocol StreamingData{
    // MARK: INPUT
    var controlSocketConnect:AnyObserver<isConnecting>{get}
    var outputDataObserver:AnyObserver<Data?>{get}
    // MARK: OUTPUT
    var inputDataObservable:Observable<Data>{get}
    var isSocketConnect: Observable<isConnecting>{get}
}
