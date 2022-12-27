//
//  NetworkService.swift
//  front-end
//
//  Created by 안광빈 on 2022/10/27.
//

import Foundation
import RxSwift

final class ProductsListHTTP{
    private let url:URL
    
    init(ServerURL serverURL:String) {
        url = URL(string:serverURL)!
    }
}
extension ProductsListHTTP:GetProductsList{
    func getProductData(lastNumber:Int?,onComplete: @escaping (Result<Data, Error>) -> Void) {
        print("====//")
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                onComplete(.failure(error))
                return
            }
            guard let data = data else{
                let httpResponse = response as! HTTPURLResponse
                let responseError = NSError(domain: "Data Error", code: httpResponse.statusCode, userInfo: nil)
                onComplete(.failure(responseError))
                return
            }
            onComplete(.success(data))
            
            
        }.resume()
   }
    
    
}
