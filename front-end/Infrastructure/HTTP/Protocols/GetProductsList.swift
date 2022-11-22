//
//  GetProductsList.swift
//  front-end
//
//  Created by 안광빈 on 2022/11/22.
//

import Foundation

protocol GetProductsList{
    func getProductData(lastNumber:Int,onComplete: @escaping (Result<Data, Error>) -> Void)
}
