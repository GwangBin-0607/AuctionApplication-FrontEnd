import RxSwift
protocol RequestingProductImageLoad{
    func returnImageHeight(productId:Int,imageURL: String?)->CGFloat
    func returnImage(productId:Int, imageURL: String?)->UIImage
}
