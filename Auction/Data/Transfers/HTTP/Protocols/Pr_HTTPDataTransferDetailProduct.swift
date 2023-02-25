//
//  Pr_HTTPDataTransferDetailProduct.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/17.
//

import Foundation
struct RequestDetailProductData:Encodable{
    let product_id:Int8
}
protocol Pr_HTTPDataTransferDetailProduct{
    func requestDetailProduct(requestData:RequestDetailProductData)throws->Data
    func responseDetailProduct(data:Data) throws -> DetailProduct
}
