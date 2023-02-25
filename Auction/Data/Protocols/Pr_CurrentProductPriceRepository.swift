//
//  pr_DetailProductRepository.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/17.
//

import Foundation
import RxSwift
protocol Pr_CurrentProductPriceRepository{
    func httpDetailProduct(productId:Int8)->Observable<Result<CurrentProductPrice,HTTPError>>
    var streamingCurrentProduct:Observable<Result<[StreamPrice],StreamError>>{get}
}
