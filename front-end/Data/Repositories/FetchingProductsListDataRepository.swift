//
//  FetchProductRepository.swift
//  front-end
//
//  Created by 안광빈 on 2022/10/26.
//

import Foundation

final class FetchingProductsListDataRepository{
    let apiService:APIService
    init(ApiService:APIService) {
        apiService = ApiService
    }
}
