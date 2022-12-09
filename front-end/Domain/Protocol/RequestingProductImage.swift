import RxSwift
protocol RequestingProductImageLoad{
    func returnImage(productId:Int, imageURL: String?)->UIImage
}
protocol RequestingProductImageHeight{
    func returnImageHeight(productId:Int,imageURL: String?)->CGFloat
}
typealias RequestingProductImage = RequestingProductImageLoad&RequestingProductImageHeight
