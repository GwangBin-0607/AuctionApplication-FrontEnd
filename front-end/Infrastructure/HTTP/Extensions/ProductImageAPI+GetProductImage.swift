import Foundation
import RxSwift

protocol GetProductImage{
    func returnImage(imageURL:String?,onComplete: @escaping (Result<Data, Error>) -> Void)
}
class ProductImageAPI:GetProductImage{
    init() {
 
    }
    func returnImage(imageURL:String?,onComplete: @escaping (Result<Data, Error>) -> Void) {
        var urlRequest = URLRequest(url: URL(string: "http://localhost:3100/products/productimage")!)
        urlRequest.httpMethod = "POST"
        let json:Dictionary<String,String> = ["imageURL":"/Users/angwangbin/Desktop/Backend/Auction_Backend/Backend/images/nike2.png"]
        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = data
        URLSession.shared.dataTask(with: urlRequest, completionHandler: {
            imageData,response,error in
            print(imageData,response,error)
        }).resume()
    }
    func returnJson(){
        var urlRequest = URLRequest(url: URL(string: "http://localhost:3100/products/alllist")!)
        urlRequest.httpMethod = "GET"
        URLSession.shared.dataTask(with: urlRequest, completionHandler: {
            imageData,response,error in
            print(imageData,response,error)
            guard let data = imageData else{
                return
            }
            
            do{let testProduct = try JSONDecoder().decode([TestProduct].self, from: data)
                print(testProduct)
            }catch{
                print(error)
            }
//
//            let string = String.init(data: data, encoding: .utf8)
//            print(string)
        }).resume()
    }
}
struct Product_Images:Decodable{
    let url:String
}
struct TestProduct:Decodable {
    let product_id:Int
    let product_name:String
    let product_price:Int
    let product_images:[Product_Images]
    enum CodingKeys:String,CodingKey{
        case product_id
        case product_name
        case product_price
        case product_images = "Product_Images"
    }
}

