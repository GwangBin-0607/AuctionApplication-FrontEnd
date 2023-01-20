//
//  ProductListViewControllerViewModel+Interface.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/13.
//

import Foundation
import RxSwift

class ProductListViewControllerViewModel:Pr_ProductListViewControllerViewModel{
    var requestProductList: AnyObserver<Void>
    private let collectionViewModel:Pr_In_ProductListCollectionViewModel
    init(collectionViewModel:Pr_In_ProductListCollectionViewModel) {
        self.collectionViewModel = collectionViewModel
        requestProductList = self.collectionViewModel.requestProductsList
        print("\(String(describing: self)) INIT")
    }
    deinit {
        print("\(String(describing: self)) DEINIT")
    }
}
