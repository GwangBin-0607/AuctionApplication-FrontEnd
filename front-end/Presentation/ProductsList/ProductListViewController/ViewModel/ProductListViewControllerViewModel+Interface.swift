//
//  ProductListViewControllerViewModel+Interface.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/13.
//

import Foundation
import RxSwift

class ProductListViewControllerViewModel:ProductListViewControllerViewModelInterface{
    var requestProductList: AnyObserver<Void>
    private let collectionViewModel:In_ProductListCollectionViewModelInterface
    init(collectionViewModel:In_ProductListCollectionViewModelInterface) {
        self.collectionViewModel = collectionViewModel
        requestProductList = self.collectionViewModel.requestProductsList
    }
}
