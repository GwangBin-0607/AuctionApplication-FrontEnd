import Foundation
import RxSwift

protocol GetProductImage{
    func returnImage(requestData:Data,onComplete: @escaping (Result<Data, HTTPError>) -> Void)
}
extension ProductHTTP:GetProductImage{
    func returnImage(requestData:Data,onComplete: @escaping (Result<Data, HTTPError>) -> Void) {
        var urlRequest = URLRequest(url:productImageURL)
        
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
                    onComplete(.failure(HTTPError.NoImageData))
                    
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


