//
//  ProductListViewModelProtocol.swift
//  front-end
//
//  Created by 안광빈 on 2022/10/26.
//

import Foundation
import RxSwift

protocol ProductsListViewModelInPut{
    var requestProductsList:AnyObserver<Int> {get}
    var requestSteamConnect:AnyObserver<isConnecting> {get}
}
protocol ProductsListViewModelOutPut{
    var isConnecting:Observable<isConnecting>{get}
    var productsList:Observable<[Product]> {get}
}
protocol ProductImageViewModelInPut{
    var requestProductImage:AnyObserver<RequestImage>{get}
}
protocol ProductImageViewModelOutPut{
    var responseProductImage:Observable<ResponseImage>{get}
}
protocol ProductImageHeightInLocationViewModelInput{
    var requestProductImageHeight:AnyObserver<IndexPath>{get}
}
protocol ProductImageHeightInLocationViewModelOutPut{
    var responseProductImageHeight:Observable<RequestImageHeight>{get}
}
typealias BindingProductsListViewModel = ProductsListViewModelInPut&ProductsListViewModelOutPut&ProductImageViewModelInPut&ProductImageViewModelOutPut&ProductImageHeightInLocationViewModelInput&ProductImageHeightInLocationViewModelOutPut
