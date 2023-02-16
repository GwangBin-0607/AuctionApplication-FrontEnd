import UIKit
import RxSwift
protocol Pr_ProductImageLoadUsecase{
    func returnImage(productId:Int,imageURL:String?,imageWidth:CGFloat)->Observable<CellImageTag>
}
protocol Pr_ProductImageHeightUsecase{
    func returnProductsWithImageHeight(products:[Product],imageWidth:CGFloat)->Observable<[Product]>
}
