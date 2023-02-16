//
//  FetchingProductsListDataRepositoryMock.swift
//  front-end
//
//  Created by 안광빈 on 2022/11/03.
//

import Foundation
final class MockProductsListAPI:GetProductsList{
    func getProductData(requestData: Data, onComplete: @escaping (Result<Data, HTTPError>) -> Void) {
        let testNum = try? JSONDecoder().decode(Int.self, from: requestData)
        if testNum == 1{
            guard let path = Bundle.main.path(forResource: "FetchingProductsListTestDataTwo", ofType: "json")
                    ,let jsonString = try? String(contentsOfFile: path)
                    ,let data = jsonString.data(using: .utf8)else{
                return
            }
            onComplete(.success(data))
        }else if testNum == 0{
            guard let path = Bundle.main.path(forResource: "FetchingProductsListTestData", ofType: "json")
                    ,let jsonString = try? String(contentsOfFile: path)
                    ,let data = jsonString.data(using: .utf8)else{
                return
            }
            onComplete(.success(data))
        }else{
            onComplete(.failure(HTTPError.EndProductList))
        }
        
    }
    
    
}
