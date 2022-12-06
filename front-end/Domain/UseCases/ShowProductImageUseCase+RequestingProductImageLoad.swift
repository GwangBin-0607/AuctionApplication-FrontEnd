import Foundation
import RxSwift
class ShowProductImageUseCase:RequestingProductImageLoad{
    func returnImageHeight(productId: Int, imageURL: String) -> CGFloat {
        let image = imageLoad(imageURL: imageURL)
        let downImage = downImageSize(image: image)
        setCacheImage(productId: productId, image: downImage)
        return returnImageHeight(image: image)
    }
    func returnImage(productId:Int)->UIImage{
        cacheImage.object(forKey: NSNumber(integerLiteral: productId)) ?? UIImage()
    }
    
    private let cacheImage:NSCache<NSNumber,UIImage>
    init() {
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
    private func downImageSize(image:UIImage) -> UIImage {
        let data = image.pngData()! as CFData
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
