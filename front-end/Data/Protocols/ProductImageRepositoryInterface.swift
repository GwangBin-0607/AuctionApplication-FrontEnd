import UIKit
import RxSwift
protocol ProductImageRepositoryInterface{
    func returnImageHeight(productId: Int, imageURL: String?) -> CGFloat
    func returnImage(productId:Int, imageURL: String?)->UIImage
    func T_returnImage(productId:Int,imageURL:String?)->Observable<CellImageTag>
    func T_returnImageHeight(productId:Int,imageURL:String?)->Observable<CGFloat>
    
}
