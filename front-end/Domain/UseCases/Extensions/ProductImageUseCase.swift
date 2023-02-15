import Foundation
import RxSwift
class ProductImageLoadUseCase:Pr_ProductImageLoadUsecase{
    func returnImage(productId: Int, imageURL: String?,imageWidth:CGFloat) -> Observable<CellImageTag> {
        productsImageRepository.returnImage(productId: productId, imageURL: imageURL,imageWidth: imageWidth)
    }
    private let productsImageRepository:ProductImageRepositoryInterface
    init(productsImageRepository:ProductImageRepositoryInterface) {
        self.productsImageRepository = productsImageRepository
        print("\(String(describing: self)) INIT")
    }
    deinit {
        print("\(String(describing: self)) DEINIT")
    }
}
