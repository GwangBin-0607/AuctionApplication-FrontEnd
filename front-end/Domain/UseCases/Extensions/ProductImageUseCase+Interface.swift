import Foundation
import RxSwift
class ProductImageHeightUseCase:ProductImageHeightUsecaseInterface{
    func returnImageHeight(productId: Int, imageURL: String?) -> CGFloat {
        productsImageRepository.returnImageHeight(productId: productId, imageURL: imageURL)
    }
    func T_returnImageHeight(productId: Int, imageURL: String) -> Observable<CGFloat> {
        productsImageRepository.T_returnImageHeight(productId: productId, imageURL: imageURL)
    }
    private let productsImageRepository:ProductImageRepositoryInterface
    init(productsImageRepository:ProductImageRepositoryInterface) {
        self.productsImageRepository = productsImageRepository
    }
}
class ProductImageLoadUseCase:ProductImageLoadUsecaseInterface{
    func returnImage(productId:Int, imageURL: String?)->UIImage{
        productsImageRepository.returnImage(productId: productId, imageURL: imageURL)
    }
    func T_returnImage(productId: Int, imageURL: String?) -> Observable<CellImageTag> {
        productsImageRepository.T_returnImage(productId: productId, imageURL: imageURL)
    }
    private let productsImageRepository:ProductImageRepositoryInterface
    init(productsImageRepository:ProductImageRepositoryInterface) {
        self.productsImageRepository = productsImageRepository
    }
}
