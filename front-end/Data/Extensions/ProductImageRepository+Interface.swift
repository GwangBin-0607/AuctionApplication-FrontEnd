import Foundation
import UIKit
class ProductImageRepository{
    private let cacheImage:NSCache<NSNumber,UIImage>
    private let imageServer:GetProductImage
    init() {
        imageServer = ProductImageAPI()
        cacheImage = NSCache<NSNumber,UIImage>()
    }
    private func imageLoad(imageURL: String) -> UIImage {
        let image = UIImage(named: imageURL)!
        return image
    }
    private func returnImageHeight(image:UIImage)->CGFloat{
        image.size.height
    }
    private func setCacheImage(productId:Int,image:UIImage){
        cacheImage.setObject(image, forKey: NSNumber(integerLiteral: productId))
    }
    private func returnCacheImage(productId:Int)->UIImage?{
        cacheImage.object(forKey: NSNumber(integerLiteral: productId))
    }
    private func downImageSize(image:UIImage) -> UIImage {
        let data = image.pngData()! as CFData
//        let imageSourceOptions = [kCGImageSourceShouldCache:false] as CFDictionary
        let imageSource = CGImageSourceCreateWithData(data, nil)!
        let maxPixel = max(image.size.width, image.size.height)
        let downSampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxPixel
        ] as CFDictionary

        let downSampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downSampleOptions)!

        let newImage = UIImage(cgImage: downSampledImage)
        return newImage
    }
}
extension ProductImageRepository:ProductImageRepositoryInterface{
    func returnImageHeight(productId: Int, imageURL: String?) -> CGFloat {

        guard let imageURL = imageURL else {
            return 150.0
        }
        guard let image = returnCacheImage(productId: productId) else{
            let nonCacheImage = imageLoad(imageURL: imageURL)
            let downImage = downImageSize(image: nonCacheImage)
            setCacheImage(productId: productId, image: downImage)
            return returnImageHeight(image: nonCacheImage)
        }
        return returnImageHeight(image: image)
    }
    func returnImage(productId:Int, imageURL: String?)->UIImage{
        guard let imageURL = imageURL else {
            return UIImage()
        }
        guard let cacheImage = returnCacheImage(productId: productId) else{
            let nonCacheImage = imageLoad(imageURL: imageURL)
            let downImage = downImageSize(image: nonCacheImage)
            setCacheImage(productId: productId, image: downImage)
            return downImage
        }
        return cacheImage
    }
}
