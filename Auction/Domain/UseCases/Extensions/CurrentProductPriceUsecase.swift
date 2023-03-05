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
    func returnCurrentProductPrice(productId: Int) -> Observable<Result<CurrentProductPrice, HTTPError>> {
        currentProductPriceRepository.httpDetailProduct(productId: productId)
    }
    func returnStreamCurrentProductPrice() -> Observable<Result<[StreamPrice], StreamError>> {
        currentProductPriceRepository.streamingCurrentProduct
    }
    func returnUpdateProductPrice(user_id:Int,product_id:Int,product_price:Int) -> Observable<Result<Bool, StreamError>> {
        currentProductPriceRepository.updateProductPrice(user_id: user_id, product_id: product_id, product_price: product_price)
    }
}
