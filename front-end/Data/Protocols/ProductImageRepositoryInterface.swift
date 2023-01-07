import UIKit
import RxSwift
protocol ProductImageRepositoryInterface{
    func returnImage(productId:Int,imageURL:String?)->Observable<CellImageTag>
    func returnProductWithImageHeight(product:[Product])->Observable<[Product]>
    
}
