//
//  ProductListViewModelProtocol.swift
//  front-end
//
//  Created by 안광빈 on 2022/10/26.
//

import Foundation
import RxSwift

protocol ProductsListViewModelInterface{
    var requestProductsList:AnyObserver<Void> {get}
    var productsList:Observable<[ProductSection]> {get}
    func returnPrice(index:IndexPath)->Int
    func returnImageHeightFromViewModel(index:IndexPath)->CGFloat
    var responseImage:Observable<ResponseImage>{get}
    var requestImage:AnyObserver<RequestImage>{get}
    var socketState:Observable<SocketState>{get}
    func controlSocketState(state:isConnecting)
}


