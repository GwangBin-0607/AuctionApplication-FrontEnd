import UIKit
import RxSwift
protocol Pr_ProductImageLoadUsecase{
    func returnImage(productId:Int,imageURL:String?)->Observable<CellImageTag>
}
protocol Pr_ProductImageHeightUsecase{
    func returnProductsWithImageHeight(products:[Product])->Observable<[Product]>
}
