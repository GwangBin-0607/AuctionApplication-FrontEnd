//
//  pr_DetailProductRepository.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/17.
//

import Foundation
import RxSwift
protocol Pr_DetailProductRepository{
    func httpDetailProduct(productId:Int)->Observable<Result<DetailProduct,HTTPError>>
}
