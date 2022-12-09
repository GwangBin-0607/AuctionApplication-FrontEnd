import Foundation
import RxSwift
class ShowProductImageUseCase:RequestingProductImageLoad,RequestingProductImageHeight{
    func returnImageHeight(productId: Int, imageURL: String?) -> CGFloat {
        productsImageRepository.returnImageHeight(productId: productId, imageURL: imageURL)
    }
    func returnImage(productId:Int, imageURL: String?)->UIImage{
        productsImageRepository.returnImage(productId: productId, imageURL: imageURL)
    }
    
    private let productsImageRepository:TransferProductsImage
    // singleton 필요!
    init(productsImageRepository:TransferProductsImage) {
        print("Init USECASE")
        self.productsImageRepository = productsImageRepository
    }
}
