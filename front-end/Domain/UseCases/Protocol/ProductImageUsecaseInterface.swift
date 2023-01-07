import UIKit
import RxSwift
protocol ProductImageLoadUsecaseInterface{
    func returnImage(productId:Int, imageURL: String?)->UIImage
    func T_returnImage(productId:Int,imageURL:String?)->Observable<CellImageTag>
}
protocol ProductImageHeightUsecaseInterface{
    func returnImageHeight(productId:Int,imageURL: String?)->CGFloat
    func T_returnImageHeight(productId:Int,imageURL:String)->Observable<CGFloat>
}
