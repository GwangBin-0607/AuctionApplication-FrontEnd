import Foundation
import UIKit
import RxSwift
class ProductImageRepository{
    private let cacheImage:NSCache<NSNumber,UIImage>
    private let imageServer:GetProductImage
    init(ImageServer:GetProductImage) {
        imageServer = ImageServer
        cacheImage = NSCache<NSNumber,UIImage>()
        testFrom()
    }
    private func imageLoad(imageURL: String?) -> UIImage {
        guard let imageURL = imageURL else{
            return UIImage(named: "36")!
        }
        return UIImage(named: imageURL)!
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
extension ProductImageRepository{
    func T_returnImage(productId:Int,imageURL:String?)->Observable<Result<UIImage,Error>>{
        guard let cacheImage = returnCacheImage(productId: productId) else{
            return imageLoadObservable(imageURL: imageURL)
                .withUnretained(self)
                .map {
                    owner,image in
                    switch image {
                    case .success(let image):
                        let downImage = owner.returnImageObservable(productId: productId, image: image)
                        return .success(downImage)
                    case .failure(let error):
                        print(error)
                        return .failure(error)
                        
                    }
                }
        }
        return Observable<Result<UIImage,Error>>.create { observer in
            observer.onNext(.success(cacheImage))
            observer.onCompleted()
            return Disposables.create()
        }
    }
    func returnImageObservable(productId:Int,image:UIImage)->UIImage{
        let downImage = downImageSize(image: image)
        setCacheImage(productId: productId, image: image)
        return downImage
    }
    func imageLoadObservable(imageURL:String?)->Observable<Result<UIImage,Error>>{
        return Observable<Result<UIImage,Error>>.create {
            [weak self] observer in
            guard let self = self,let imageURL = imageURL else{
                let err = NSError(domain: "No ImageURL", code: -1)
                observer.onNext(.failure(err))
                return Disposables.create()
            }
            self.imageServer.returnImage(imageURL: imageURL, onComplete: {
                result in
                switch result{
                case .success(let imageData):
                    let image = self.decodeImage(imageData: imageData)
                    observer.onNext(.success(image))
                    observer.onCompleted()
                case .failure(let error):
                    observer.onNext(.failure(error))
                }
                
            })
            return Disposables.create()
        }
    }
    func decodeImage(imageData:Data)->UIImage{
        return UIImage(data: imageData)!
    }
    func T_returnImageHeight(productId:Int,imageURL:String?)->Observable<CGFloat>{
        guard let image = self.returnCacheImage(productId: productId)
        else{
            return T_returnImage(productId: productId, imageURL: imageURL).withUnretained(self).map { owner,result in
                switch result{
                case .success(let image):
                    return owner.returnImageHeight(image: image)
                case .failure(_):
                    return 150
                }
            }
        }
        return Observable<CGFloat>.create {
            observer in
            let imageHeight = self.returnImageHeight(image: image)
            observer.onNext(imageHeight)
            observer.onCompleted()
            return Disposables.create()
        }
    }
    func testFrom(){
        let first = Observable<Int>.create { observer in
            observer.onNext(1)
            return Disposables.create()
        }.delay(.seconds(5), scheduler: MainScheduler.asyncInstance)
        let second = Observable<Int>.create { observer in
            observer.onNext(2)
            return Disposables.create()
        }.delay(.seconds(3), scheduler: MainScheduler.asyncInstance)
        let third = Observable<Int>.create { observer in
            observer.onNext(3)
            return Disposables.create()
        }.delay(.seconds(2), scheduler: MainScheduler.asyncInstance)
        
    }

}
extension ProductImageRepository:ProductImageRepositoryInterface{
    func returnImageHeight(productId: Int, imageURL: String?) -> CGFloat {
        guard let image = returnCacheImage(productId: productId) else{
            let nonCacheImage = imageLoad(imageURL: imageURL)
            let downImage = downImageSize(image: nonCacheImage)
            setCacheImage(productId: productId, image: downImage)
            return returnImageHeight(image: nonCacheImage)
        }
        return returnImageHeight(image: image)
    }
    func returnImage(productId:Int, imageURL: String?)->UIImage{
        guard let cacheImage = returnCacheImage(productId: productId) else{
            let nonCacheImage = imageLoad(imageURL: imageURL)
            let downImage = downImageSize(image: nonCacheImage)
            setCacheImage(productId: productId, image: downImage)
            return downImage
        }
        return cacheImage
    }
}
