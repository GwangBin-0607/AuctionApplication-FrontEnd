//
//  NetworkService.swift
//  front-end
//
//  Created by 안광빈 on 2022/10/27.
//

import Foundation
import RxSwift

class NetworkService{
    
}
protocol APIService{
    func getProductData(lastNumber:Int,onComplete: @escaping (Result<Data, Error>) -> Void)
}
extension NetworkService:APIService{
    func getProductData(lastNumber:Int,onComplete: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: URL(string:"http~~~~")!)
        URLSession.shared.dataTask(with: request) { data, response, error in
            
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
