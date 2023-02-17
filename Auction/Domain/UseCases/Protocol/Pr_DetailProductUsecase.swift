//
//  Pr_DetailProductUsecase.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/17.
//

import Foundation
import RxSwift
protocol Pr_DetailProductUsecase{
    func returnDetailProduct(productId:Int8) -> Observable<Result<DetailProduct,HTTPError>>
}
