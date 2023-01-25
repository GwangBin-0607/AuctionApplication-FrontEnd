import Foundation
import RxSwift

protocol GetProductImage{
    func returnImage(imageURL:String,onComplete: @escaping (Result<Data, Error>) -> Void)
}
class ProductImageAPI:GetProductImage{
    func returnImage(imageURL:String,onComplete: @escaping (Result<Data, Error>) -> Void) {
        var urlRequest = URLRequest(url: URL(string: "http://localhost:3100/products/productimage")!)
        urlRequest.httpMethod = "POST"
        let json:Dictionary<String,String> = ["imageURL":imageURL]
        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = data
        onComplete(.failure(NSError(domain: "Handling", code: -1)))
//        URLSession.shared.dataTask(with: urlRequest, completionHandler: {
//            imageData,response,error in
//            print("=====\(error)=====")
//            if let error = error{
//                onComplete(.failure(error))
//            }
//        })
    }
    }

struct Product_Images:Decodable{
    let url:String
}

