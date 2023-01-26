//
//  GetProductsList.swift
//  front-end
//
//  Created by 안광빈 on 2022/11/22.
//

import Foundation

protocol GetProductsList{
    func getProductData(requestNum:Int8,onComplete: @escaping (Result<Data, HTTPError>) -> Void)
}
