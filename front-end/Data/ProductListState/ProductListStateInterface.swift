//
//  ProductListStateInterface.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/11.
//

import Foundation
import RxSwift
protocol ProductListStateInterface {
    func updateState(sendObservable:Observable<Result<ResultData,Error>>)->Observable<Result<ResultData,Error>>
    func returnHttpState()->Int
}
