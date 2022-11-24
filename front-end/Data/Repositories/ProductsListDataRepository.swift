//
//  FetchProductRepository.swift
//  front-end
//
//  Created by 안광빈 on 2022/10/26.
//

import Foundation

final class ProductsListRepository{
    let apiService:GetProductsList
    init(ApiService:GetProductsList) {
        apiService = MockProductsListAPI()
    }
}