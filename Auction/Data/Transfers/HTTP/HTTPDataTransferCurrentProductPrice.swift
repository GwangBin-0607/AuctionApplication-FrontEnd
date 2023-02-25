//
//  HTTPDataTransferDetailProduct.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/17.
//

import Foundation
final class HTTPDataTransferCurrentProductPrice:Pr_HTTPDataTransferCurrentProductPrice{
    func responseDetailProduct(data: Data) throws -> CurrentProductPrice {
        let jsonDecoder = JSONDecoder()
        return try jsonDecoder.decode(CurrentProductPrice.self, from: data)
    }
    init() {
        print("\(String(describing: self)) INIT")
    }
    deinit {
        print("\(String(describing: self)) DEINIT")
    }
    func requestDetailProduct(requestData: RequestCurrentProductPriceData) throws -> Data {
        let jsonEncoder = JSONEncoder()
        return try jsonEncoder.encode(requestData)
    }
    
}
