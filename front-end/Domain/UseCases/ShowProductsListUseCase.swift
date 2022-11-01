//
//  FetchProductListUseCase.swift
//  front-end
//
//  Created by 안광빈 on 2022/10/26.
//

import Foundation

final class ShowProductsListUseCase{
    let fetchingRepository:FetchingProductsListData
    init(FetchingProductsList:FetchingProductsListData) {
        self.fetchingRepository = FetchingProductsList
        
    }
}
