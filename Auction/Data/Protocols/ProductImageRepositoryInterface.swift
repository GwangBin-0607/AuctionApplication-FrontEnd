import UIKit
import RxSwift
protocol ProductImageRepositoryInterface{
    func returnImage(productId:Int,imageURL:String?,imageWidth:CGFloat)->Observable<CellImageTag>
    func returnProductWithImageHeight(product:[Product],imageWidth:CGFloat)->Observable<[Product]>
    
}
