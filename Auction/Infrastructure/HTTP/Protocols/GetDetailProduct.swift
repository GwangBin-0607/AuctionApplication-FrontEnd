//
//  GetDetailProduct.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/17.
//

import Foundation
protocol GetDetailProduct{
    func getDetailProduct(requestData:Data,onComplete: @escaping (Result<Data, HTTPError>) -> Void)
}
