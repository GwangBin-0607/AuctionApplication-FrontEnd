//
//  BuyProductButtonViewModel.swift
//  Auction
//
//  Created by 안광빈 on 2023/03/04.
//

import Foundation
import RxSwift

final class BuyProductButtonViewModel:Pr_BuyProductButtonViewModel{
    let tapObserver: AnyObserver<Void>
    let tapObservable: Observable<Void>
    init() {
        let tapSubject = PublishSubject<Void>()
        tapObserver = tapSubject.asObserver()
        tapObservable = tapSubject.asObservable()
    }
}
