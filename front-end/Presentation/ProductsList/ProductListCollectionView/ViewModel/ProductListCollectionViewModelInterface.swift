//
//  ProductListViewModelProtocol.swift
//  front-end
//
//  Created by 안광빈 on 2022/10/26.
//

import Foundation
import RxSwift

protocol Out_ProductListCollectionViewModelInterface{
    var productsList:Observable<[ProductSection]> {get}
    var socketState:Observable<SocketConnectState>{get}
    var scrollScrollView:AnyObserver<[Int]> {get}
    func returnPrice(index:IndexPath)->Int
}
protocol In_ProductListCollectionViewModelInterface{
    var requestProductsList:AnyObserver<Void> {get}
    func controlSocketState(state:isConnecting)
}
typealias ProductListCollectionViewModelInterface = In_ProductListCollectionViewModelInterface&Out_ProductListCollectionViewModelInterface
