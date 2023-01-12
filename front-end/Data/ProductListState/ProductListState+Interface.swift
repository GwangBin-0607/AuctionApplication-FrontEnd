//
//  ProductListState+Interface.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/11.
//

import Foundation
import RxSwift
final class ProductListState:ProductListStateInterface{
    func updateState(repository:ProductListRepositoryInterface) {
        repository.sendData(output: StreamStateData(result: streamServiceState)).withUnretained(self).subscribe(onNext: {
            owner,result in
            switch result {
            case .success(let resultData):
                if resultData.result{
                    owner.streamServiceState += 1
                }
            case .failure( _):
                break;
            }
        }).disposed(by: disposeBag)
        httpServiceState += 1 
    }
    private let disposeBag:DisposeBag
    private var httpServiceState:Int = 0
    private var streamServiceState:Int = 0
    init() {
        disposeBag = DisposeBag()
    }
}
