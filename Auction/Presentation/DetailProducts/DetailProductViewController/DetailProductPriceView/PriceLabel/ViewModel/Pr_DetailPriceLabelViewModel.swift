//
//  Pr_DetailPriceLabelViewModel.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/26.
//

import Foundation
import RxSwift
protocol Pr_DetailPriceLabelViewModel{
    var priceObservable:Observable<String>{get}
    var priceObserver:AnyObserver<Int>{get}
}
