//
//  ProductListViewModelProtocol.swift
//  front-end
//
//  Created by 안광빈 on 2022/10/26.
//

import Foundation
import RxSwift
protocol Pr_Common_ProductListCollectionViewModel{
    var requestProductsList:AnyObserver<Void> {get}
}
protocol Pr_Out_ProductListCollectionViewModel:Pr_Common_ProductListCollectionViewModel{
    var productsList:Observable<[ProductSection]> {get}
    var socketState:Observable<isConnecting>{get}
    var scrollScrollView:AnyObserver<[Int]> {get}
    func returnPrice(index:IndexPath)->Int
    func returnCellViewModel()->Pr_ProductListCollectionViewCellViewModel
}
protocol Pr_In_ProductListCollectionViewModel:Pr_Common_ProductListCollectionViewModel{
    func controlSocketState(state:isConnecting)
}
typealias Pr_ProductListCollectionViewModel = Pr_In_ProductListCollectionViewModel&Pr_Out_ProductListCollectionViewModel
