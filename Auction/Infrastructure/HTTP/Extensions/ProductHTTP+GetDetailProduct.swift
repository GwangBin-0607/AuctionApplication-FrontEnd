//
//  ProductHTTP+GetDetailProduct.swift
//  Auction
//
//  Created by 안광빈 on 2023/02/17.
//

import Foundation
extension ProductHTTP:GetDetailProduct{
    func getDetailProduct(requestData: Data, onComplete: @escaping (Result<Data, HTTPError>) -> Void) {
        var urlRequest = URLRequest(url: productDetailURL)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = requestData
        URLSession.shared.dataTask(with: urlRequest) {
            data, response, error in
            if error != nil {
                onComplete(.failure(HTTPError.RequestError))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else{
                onComplete(.failure(HTTPError.ResponseError))
                return
            }
            guard httpResponse.statusCode == 200 else{
                if httpResponse.statusCode == 201{
                    onComplete(.failure(HTTPError.EndProductList))

                }else{
                    onComplete(.failure(HTTPError.StatusError))

                }
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
