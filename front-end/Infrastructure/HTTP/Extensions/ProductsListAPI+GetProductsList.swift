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
    func getProductData(onComplete: @escaping (Result<Data, Error>) -> Void) {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        let json:Dictionary<String,Int8> = ["pageNum":0]
        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = data
        URLSession.shared.dataTask(with: urlRequest) {
            [weak self] data, response, error in
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
