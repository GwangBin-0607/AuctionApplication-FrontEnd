import UIKit
import RxSwift
protocol Pr_ProductImageLoadUsecase{
    func returnImage(product_image:Product_Images?,imageWidth:CGFloat,tag:Int)->Observable<CellImageTag>
}
protocol Pr_ProductImageHeightUsecase{
    func returnProductsWithImageHeight(products:[Product],imageWidth:CGFloat)->Observable<[Product]>
}
