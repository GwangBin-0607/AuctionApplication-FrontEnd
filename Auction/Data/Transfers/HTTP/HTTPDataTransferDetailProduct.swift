//
//  HTTPDataTransferDetailProduct.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/17.
//

import Foundation
final class HTTPDataTransferDetailProduct:Pr_HTTPDataTransferDetailProduct{
    func responseDetailProduct(data: Data) throws -> DetailProduct {
        let jsonDecoder = JSONDecoder()
        return try jsonDecoder.decode(DetailProduct.self, from: data)
    }
    init() {
        print("\(String(describing: self)) INIT")
    }
    deinit {
        print("\(String(describing: self)) DEINIT")
    }
    func requestDetailProduct(requestData: RequestDetailProductData) throws -> Data {
        let jsonEncoder = JSONEncoder()
        return try jsonEncoder.encode(requestData)
    }
    
}
