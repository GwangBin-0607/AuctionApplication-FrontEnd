import UIKit
protocol ProductImageRepositoryInterface{
    func returnImageHeight(productId: Int, imageURL: String?) -> CGFloat
    func returnImage(productId:Int, imageURL: String?)->UIImage
    
}
