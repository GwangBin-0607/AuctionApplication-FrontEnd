//
//  ProductListViewModelProtocol.swift
//  front-end
//
//  Created by 안광빈 on 2022/10/26.
//

import Foundation
import RxSwift

protocol ProductListViewControllerViewModelInterface{
    var requestProductsList:AnyObserver<Void> {get}
    var productsList:Observable<[ProductSection]> {get}
    var socketState:Observable<SocketConnectState>{get}
    func controlSocketState(state:isConnecting)
    var scrollScrollView:AnyObserver<[Int]> {get}
}
