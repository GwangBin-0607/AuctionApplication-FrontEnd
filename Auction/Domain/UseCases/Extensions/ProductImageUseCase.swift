import Foundation
import RxSwift
class ProductImageLoadUseCase:Pr_ProductImageLoadUsecase{
    func returnImage(product_image:Image?,imageWidth:CGFloat,tag:Int) -> Observable<CellImageTag> {
        productsImageRepository.returnCellImageTag(product_image: product_image, imageWidth: imageWidth, tag: tag)
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
