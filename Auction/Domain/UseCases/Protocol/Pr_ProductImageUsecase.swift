import UIKit
import RxSwift
protocol Pr_ProductImageLoadUsecase{
    func returnImage(product_image:Image?,imageWidth:CGFloat,tag:Int)->Observable<ResultCellImageTag>
}
