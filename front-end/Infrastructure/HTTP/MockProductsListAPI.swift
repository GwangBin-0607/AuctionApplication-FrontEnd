//
//  FetchingProductsListDataRepositoryMock.swift
//  front-end
//
//  Created by 안광빈 on 2022/11/03.
//

import Foundation
final class MockProductsListAPI:GetProductsList{
    func getProductData(lastNumber: Int, onComplete: @escaping (Result<Data, Error>) -> Void) {
        guard let path = Bundle.main.path(forResource: "ImageTest", ofType: "json")
                ,let jsonString = try? String(contentsOfFile: path)
                ,let data = jsonString.data(using: .utf8)else{
            print("not")
            return
        }
        onComplete(.success(data))
        print(path)
    }
    
    
}
