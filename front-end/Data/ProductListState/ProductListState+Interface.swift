//
//  ProductListState+Interface.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/11.
//

import Foundation
import RxSwift
final class ProductListState:ProductListStateInterface{
    func updateTCPState(result:Result<ResultData,Error>) {
        switch result {
        case .success(let resultData):
            if resultData.result{
                streamServiceState += 1
            }
        default:
            break;
        }
    }
    func updateHTTPState() {
        httpServiceState += 1
    }
    func returnTCPState() -> Int {
        streamServiceState
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