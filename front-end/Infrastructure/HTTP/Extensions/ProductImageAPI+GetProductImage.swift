import Foundation
import RxSwift

protocol GetProductImage{
    func returnImage(imageURL:String?,onComplete: @escaping (Result<Data, Error>) -> Void)
}
class ProductImageAPI:GetProductImage{
    init() {
    }
    func returnImage(imageURL:String?,onComplete: @escaping (Result<Data, Error>) -> Void) {
        
    }
}
