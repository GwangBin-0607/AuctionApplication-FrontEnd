import Foundation
import RxSwift
class ProductImageLoadUseCase:Pr_ProductImageLoadUsecase{
    func returnImage(productId: Int, imageURL: String?) -> Observable<CellImageTag> {
        productsImageRepository.returnImage(productId: productId, imageURL: imageURL)
    }
    private let productsImageRepository:ProductImageRepositoryInterface
    init(productsImageRepository:ProductImageRepositoryInterface) {
        self.productsImageRepository = productsImageRepository
    }
}
