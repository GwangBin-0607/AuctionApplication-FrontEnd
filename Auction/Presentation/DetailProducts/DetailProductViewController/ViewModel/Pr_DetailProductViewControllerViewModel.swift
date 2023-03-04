//
//  Pr_DetailProductViewControllerViewModel.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/21.
//

import Foundation
import RxSwift

protocol Pr_DetailProductViewControllerViewModel{
    var requestDetailProduct:AnyObserver<Void>{get}
    var backAction:AnyObserver<Void>{get}
    var completionReloadData:Observable<CGRect>{get}
    var pangesture:Observable<Pangesture>{get}
    var tapGesture:Observable<Void>{get}
    var priceViewAnimationSubview:AnyObserver<Void>{get}
    var buyProductBottonTapObservable:Observable<Void>{get}
}
