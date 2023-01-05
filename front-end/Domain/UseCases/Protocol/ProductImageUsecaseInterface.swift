import UIKit
import RxSwift
protocol RequestingProductImageLoad{
    func returnImage(productId:Int, imageURL: String?)->UIImage
    func T_returnImage(productId:Int,imageURL:String?)->Observable<Result<UIImage,Error>>
}
protocol RequestingProductImageHeight{
    func returnImageHeight(productId:Int,imageURL: String?)->CGFloat
    func T_returnImageHeight(productId:Int,imageURL:String?)->Observable<CGFloat>
}
typealias ProductImageUsecaseInterface = RequestingProductImageLoad&RequestingProductImageHeight
