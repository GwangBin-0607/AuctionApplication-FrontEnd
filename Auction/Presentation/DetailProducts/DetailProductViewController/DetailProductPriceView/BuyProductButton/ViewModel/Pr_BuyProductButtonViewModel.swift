//
//  Pr_BuyProductButtonViewModel.swift
//  Auction
//
//  Created by 안광빈 on 2023/03/04.
//

import Foundation
import RxSwift
protocol Pr_BuyProductButtonViewModel {
    var tapObserver:AnyObserver<Void>{get}
    var tapObservable:Observable<Void>{get}
}
