//
//  HTTPDataTransfer.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/30.
//

import Foundation
struct RequestProductListData:Encodable{
    let index:Int8
}
final class HTTPDataTransfer:Pr_HTTPDataTransfer{
    func requestProductList(requestData: RequestProductListData) throws -> Data {
        let jsonEncoder = JSONEncoder()
        return try jsonEncoder.encode(requestData)
    }
    
    func responseProductList(data:Data) throws -> [Product] {
        let jsonDecoder = JSONDecoder()
        return try jsonDecoder.decode([Product].self, from: data)
    }
    init() {
        print("\(String(describing: self)) INIT")
    }
    deinit {
        print("\(String(describing: self)) DEINIT")
    }
    
    
}
