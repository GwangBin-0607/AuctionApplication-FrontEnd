import UIKit
import RxSwift
protocol ProductImageLoadUsecaseInterface{
    func returnImage(productId:Int,imageURL:String?)->Observable<CellImageTag>
}
protocol ProductImageHeightUsecaseInterface{
    func returnProductsWithImageHeight(products:[Product])->Observable<[Product]>
}
