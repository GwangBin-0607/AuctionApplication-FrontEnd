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
    var buyProduct:AnyObserver<Void>{get}
    var userObserver:AnyObserver<Int>{get}
}
