//
//  ProductListViewModelProtocol.swift
//  front-end
//
//  Created by 안광빈 on 2022/10/26.
//

import Foundation
import RxSwift

protocol ProductsListViewModelInterface:ReturnImageHeightDelegate{
    var requestProductsList:AnyObserver<Int> {get}
    var productsList:Observable<[ProductSection]> {get}
    func returnPrice(index:IndexPath)->Int
    var responseImage:Observable<ResponseImage>{get}
    var requestImage:AnyObserver<RequestImage>{get}
}


