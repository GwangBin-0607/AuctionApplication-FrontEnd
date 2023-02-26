import UIKit
import RxSwift
protocol ProductImageRepositoryInterface{
    func returnCellImageTag(product_image:Image?,imageWidth:CGFloat,tag:Int)->Observable<ResultCellImageTag>
    func returnProductWithImageHeight(product:[Product],imageWidth:CGFloat)->Observable<[Product]>
    
}
