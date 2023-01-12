//
//  FetchingProductsListDataRepositoryMock.swift
//  front-end
//
//  Created by 안광빈 on 2022/11/03.
//

import Foundation
final class MockProductsListAPI:GetProductsList{
    func getProductData(requestNum:Int?,onComplete: @escaping (Result<Data, Error>) -> Void) {
        if requestNum == 1{
            guard let path = Bundle.main.path(forResource: "FetchingProductsListTestDataTwo", ofType: "json")
                    ,let jsonString = try? String(contentsOfFile: path)
                    ,let data = jsonString.data(using: .utf8)else{
                return
            }
            onComplete(.success(data))
        }else if requestNum == 0{
            guard let path = Bundle.main.path(forResource: "FetchingProductsListTestData", ofType: "json")
                    ,let jsonString = try? String(contentsOfFile: path)
                    ,let data = jsonString.data(using: .utf8)else{
                return
            }
            onComplete(.success(data))
        }else{
            let error = NSError(domain: "Not ProductList Data", code: -1)
            onComplete(.failure(error))
        }
        
        
    }
    
    
}
