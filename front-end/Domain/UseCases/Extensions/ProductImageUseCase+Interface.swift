import Foundation
import RxSwift
class ProductImageHeightUseCase:ProductImageHeightUsecaseInterface{
    func returnProductsWithImageHeight(products: [Product]) -> Observable<[Product]> {
        productsImageRepository.returnProductWithImageHeight(product: products)
    }
    private let productsImageRepository:ProductImageRepositoryInterface
    init(productsImageRepository:ProductImageRepositoryInterface) {
        self.productsImageRepository = productsImageRepository
    }
}
class ProductImageLoadUseCase:ProductImageLoadUsecaseInterface{
    func returnImage(productId: Int, imageURL: String?) -> Observable<CellImageTag> {
        productsImageRepository.returnImage(productId: productId, imageURL: imageURL)
    }
    private let productsImageRepository:ProductImageRepositoryInterface
    init(productsImageRepository:ProductImageRepositoryInterface) {
        self.productsImageRepository = productsImageRepository
    }
}
