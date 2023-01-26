//
//  NetworkService.swift
//  front-end
//
//  Created by 안광빈 on 2022/10/27.
//

import Foundation
import RxSwift
enum HTTPError:Error{
    case RequestError
    case ResponseError
    case DataError
    case StatusError
    case DecodeError
    case EndProductList
}
final class ProductsListHTTP{
    private let url:URL
    init(ServerURL serverURL:String) {
        url = URL(string:serverURL)!
    }
}
extension ProductsListHTTP:GetProductsList{
    func getProductData(requestNum:Int8,onComplete: @escaping (Result<Data, HTTPError>) -> Void) {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        let json:Dictionary<String,Int8> = ["pageNum":requestNum]
        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = data
        URLSession.shared.dataTask(with: urlRequest) {
            data, response, error in
            if let error = error {
                onComplete(.failure(HTTPError.RequestError))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else{
                onComplete(.failure(HTTPError.ResponseError))
                return
            }
            guard httpResponse.statusCode == 200 else{
                onComplete(.failure(HTTPError.StatusError))
                return
            }
            guard let data = data else{
                onComplete(.failure(HTTPError.DataError))
                return
            }
            onComplete(.success(data))
            
            
        }.resume()
   }
    
    
}
