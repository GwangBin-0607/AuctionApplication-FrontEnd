//
//  Pr_DetailProductCollectionViewCommentCellViewModel.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/26.
//

import Foundation
import RxSwift

protocol Pr_DetailProductCollectionViewCommentCellViewModel {
    var originalPriceObservable:Observable<String>{get}
    var priceNameObservable:Observable<String>{get}
    var registerObservable:Observable<String>{get}
    var commentObservable:Observable<String>{get}
    var detailProductObserver:AnyObserver<DetailProductComment?>{get}
}
