//
//  Pr_HTTPDataTransfer.swift
//  front-end
//
//  Created by 안광빈 on 2023/01/30.
//

import Foundation

protocol Pr_HTTPDataTransfer{
    func requestProductList(requestData:RequestProductListData)throws->Data
    func responseProductList(data:Data) throws -> [Product]
}
