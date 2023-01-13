import Foundation
import RxSwift
class ProductImageHeightUseCase:Pr_ProductImageHeightUsecase{
    func returnProductsWithImageHeight(products: [Product]) -> Observable<[Product]> {
        productsImageRepository.returnProductWithImageHeight(product: products)
    }
    private let productsImageRepository:ProductImageRepositoryInterface
    init(productsImageRepository:ProductImageRepositoryInterface) {
        self.productsImageRepository = productsImageRepository
    }
}
class ProductImageLoadUseCase:Pr_ProductImageLoadUsecase{
    func returnImage(productId: Int, imageURL: String?) -> Observable<CellImageTag> {
        productsImageRepository.returnImage(productId: productId, imageURL: imageURL)
    }
    private let productsImageRepository:ProductImageRepositoryInterface
    init(productsImageRepository:ProductImageRepositoryInterface) {
        self.productsImageRepository = productsImageRepository
    }
}
