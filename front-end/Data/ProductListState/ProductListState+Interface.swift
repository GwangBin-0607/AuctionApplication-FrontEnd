//
//  ProductListState+Interface.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/11.
//

import Foundation
import RxSwift
final class ProductListState:ProductListStateInterface{
    func updateState(sendObservable:Observable<Result<ResultData,Error>>)->Observable<Result<ResultData,Error>> {
        httpServiceState += 1
        return sendObservable
    }
    func returnHttpState() -> Int {
        httpServiceState
    }
    private let disposeBag:DisposeBag
    private var httpServiceState:Int = 0
    private var streamServiceState:Int = 0
    init() {
        disposeBag = DisposeBag()
    }
}
