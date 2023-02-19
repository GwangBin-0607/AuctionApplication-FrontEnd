//
//  HTTPDataTransferProductImage.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/19.
//

import Foundation
final class HTTPDataTransferProductImage:Pr_HTTPDataTransferProductImage{
    func responseProductImage(data: Data) throws -> Product_Images {
        let jsonDecoder = JSONDecoder()
        return try jsonDecoder.decode(Product_Images.self, from: data)
    }
    init() {
        print("\(String(describing: self)) INIT")
    }
    deinit {
        print("\(String(describing: self)) DEINIT")
    }
    func requestProductImage(requestData: RequestProductImage) throws -> Data {
        let jsonEncoder = JSONEncoder()
        return try jsonEncoder.encode(requestData)
    }
    
}
