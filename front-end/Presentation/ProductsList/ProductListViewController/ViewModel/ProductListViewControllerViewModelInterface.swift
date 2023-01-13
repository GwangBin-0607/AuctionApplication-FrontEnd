//
//  ProductListViewControllerViewModelInterface.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/13.
//

import Foundation
import RxSwift
protocol In_ProductListViewControllerViewModelInterface{
    var requestProductList:AnyObserver<Void>{get}
}
typealias ProductListViewControllerViewModelInterface = In_ProductListViewControllerViewModelInterface
