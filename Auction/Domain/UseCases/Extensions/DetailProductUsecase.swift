//
//  DetailProductUsecase.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/17.
//

import Foundation
import RxSwift
final class DetailProductUsecase{
    private let detailProductRepository:Pr_DetailProductRepository
    init(detailProductRepository:Pr_DetailProductRepository) {
        self.detailProductRepository = detailProductRepository
    }
}
extension DetailProductUsecase:Pr_DetailProductUsecase{
    func returnDetailProduct(productId: Int) -> Observable<Result<DetailProduct, HTTPError>> {
        detailProductRepository.httpDetailProduct(productId: productId)
    }
}
