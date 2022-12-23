import Foundation
import RxSwift
class ProductImageUseCase:ProductImageUsecaseInterface{
    func returnImageHeight(productId: Int, imageURL: String?) -> CGFloat {
        productsImageRepository.returnImageHeight(productId: productId, imageURL: imageURL)
    }
    func returnImage(productId:Int, imageURL: String?)->UIImage{
        productsImageRepository.returnImage(productId: productId, imageURL: imageURL)
    }
    
    private let productsImageRepository:ProductImageRepositoryInterface
    init(productsImageRepository:ProductImageRepositoryInterface) {
        print("Init USECASE")
        self.productsImageRepository = productsImageRepository
    }
}
