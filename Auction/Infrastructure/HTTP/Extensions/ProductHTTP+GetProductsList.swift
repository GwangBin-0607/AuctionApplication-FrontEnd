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
    case NoImageData
}
final class ProductHTTP{
    let productListURL:URL
    let productImageURL:URL
    let productDetailURL:URL
    init(ProductListURL listURL:URL,ProductImageURL imageURL:URL,ProductDetailURL detailURL:URL) {
        self.productListURL = listURL
        self.productImageURL = imageURL
        self.productDetailURL = detailURL
    }
}
extension ProductHTTP:GetProductsList{
    func getProductData(requestData: Data, onComplete: @escaping (Result<Data, HTTPError>) -> Void) {
        var urlRequest = URLRequest(url: productListURL)
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
