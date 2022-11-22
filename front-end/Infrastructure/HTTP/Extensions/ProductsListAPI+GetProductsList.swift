//
//  NetworkService.swift
//  front-end
//
//  Created by 안광빈 on 2022/10/27.
//

import Foundation
import RxSwift

final class ProductsListAPI{
    private let url:URL
    private let urlRequest:URLRequest
    
    init(ServerURL serverURL:String) {
        url = URL(string:serverURL)!
        urlRequest = URLRequest(url: url)
    }
}
extension ProductsListAPI:GetProductsList{
    func getProductData(lastNumber:Int,onComplete: @escaping (Result<Data, Error>) -> Void) {
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
            
            
        }
   }
    
    
}
