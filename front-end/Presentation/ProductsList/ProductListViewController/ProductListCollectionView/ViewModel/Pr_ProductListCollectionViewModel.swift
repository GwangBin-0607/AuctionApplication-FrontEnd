//
//  ProductListViewModelProtocol.swift
//  front-end
//
//  Created by 안광빈 on 2022/10/26.
//

import Foundation
import RxSwift
protocol Pr_ProductListCollectionViewModel{
    var requestProductsList:AnyObserver<Void> {get}
    var productsList:Observable<[ProductSection]> {get}
    var socketState:Observable<isConnecting>{get}
    var errorMessage:Observable<HTTPError>{get}
    func lastIndex()->IndexPath
    func returnAnimationValue(index:IndexPath)->AnimtionValue?
    func returnCellViewModel()->Pr_ProductListCollectionViewCellViewModel
    func returnFooterViewModel() -> Pr_ProductListCollectionFooterViewModel
    func controlSocketState(state:isConnecting)
    var presentDetailProductObservable:Observable<Int?>!{get}
    var presentDetailProductObserver:AnyObserver<Int>{get}
    var updatingObserver:AnyObserver<Bool>{get}
}

