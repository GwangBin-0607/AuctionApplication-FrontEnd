//
//  Pr_HTTPDataTransferDetailProduct.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/17.
//

import Foundation
struct RequestCurrentProductPriceData:Encodable{
    let product_id:Int
}
protocol Pr_HTTPDataTransferCurrentProductPrice{
    func requestDetailProduct(requestData:RequestCurrentProductPriceData)throws->Data
    func responseDetailProduct(data:Data) throws -> CurrentProductPrice
}
