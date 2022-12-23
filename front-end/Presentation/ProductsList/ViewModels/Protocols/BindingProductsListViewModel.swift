////
////  ProductListViewModelProtocol.swift
////  front-end
////
////  Created by 안광빈 on 2022/10/26.
////
//
//import Foundation
//import RxSwift
//
//protocol ProductsListViewModelInPut{
//    var requestProductsList:AnyObserver<Int> {get}
//    var requestSteamConnect:AnyObserver<isConnecting> {get}
//}
//protocol ProductsListViewModelOutPut{
//    var isConnecting:Observable<isConnecting>{get}
//    var productsList:Observable<[ProductSection]> {get}
//}
//protocol ProductImageLoadViewModel{
//    var responseImage:Observable<ResponseImage>{get}
//    var requestImage:AnyObserver<RequestImage>{get}
//
//}
//protocol ProductPriceViewModel{
//    func testFunction()
//    func returnPrice(index:IndexPath)->Int
//}
//typealias BindingProductsListViewModel = ProductPriceViewModel&ProductsListViewModelInPut&ProductsListViewModelOutPut&ProductImageLoadViewModel&ReturnImageHeightDelegate
//
