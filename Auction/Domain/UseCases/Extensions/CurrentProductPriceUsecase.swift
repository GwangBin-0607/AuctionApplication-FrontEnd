//
//  CurrentProductPriceUsecase.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/25.
//

import Foundation
import RxSwift
final class CurrentProductPriceUsecase{
    private let currentProductPriceRepository:Pr_CurrentProductPriceRepository
    init(currentProductPriceRepository:Pr_CurrentProductPriceRepository) {
        self.currentProductPriceRepository = currentProductPriceRepository
    }
}
extension CurrentProductPriceUsecase:Pr_CurrentProductPriceUsecase{
    func returnCurrentProductPrice(productId: Int8) -> Observable<Result<CurrentProductPrice, HTTPError>> {
        currentProductPriceRepository.httpDetailProduct(productId: productId)
    }
    func returnStreamCurrentProductPrice() -> Observable<Result<[StreamPrice], StreamError>> {
        currentProductPriceRepository.streamingCurrentProduct
    }
}
