import UIKit
import RxSwift
protocol Pr_ProductImageLoadUsecase{
    func returnImage(product_image:Image?,imageWidth:CGFloat,tag:Int)->Observable<CellImageTag>
}
protocol Pr_ProductImageHeightUsecase{
    func returnProductsWithImageHeight(products:[Product],imageWidth:CGFloat)->Observable<[Product]>
}
