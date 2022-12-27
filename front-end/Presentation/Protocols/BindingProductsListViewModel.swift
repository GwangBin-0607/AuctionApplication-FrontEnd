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
}
protocol ProductsListViewModelOutPut{
    var productsList:Observable<[Product]> {get}
}
typealias BindingProductsListViewModel = ProductsListViewModelInPut&ProductsListViewModelOutPut

