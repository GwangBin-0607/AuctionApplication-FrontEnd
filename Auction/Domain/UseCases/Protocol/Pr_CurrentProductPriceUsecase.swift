//
//  Pr_DetailProductUsecase.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/17.
//

import Foundation
import RxSwift
protocol Pr_CurrentProductPriceUsecase{
    func returnCurrentProductPrice(productId:Int) -> Observable<Result<CurrentProductPrice,HTTPError>>
    func returnStreamCurrentProductPrice() -> Observable<Result<[StreamPrice],StreamError>>
    func returnUpdateProductPrice(user_id:Int,product_id:Int,product_price:Int)->Observable<Result<Bool,StreamError>>
}
