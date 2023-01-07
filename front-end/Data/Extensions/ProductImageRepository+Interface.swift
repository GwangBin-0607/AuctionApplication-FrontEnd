import Foundation
import UIKit
import RxSwift
class ProductImageRepository{
    private let imageServer:GetProductImage
    private let cacheRepository:ProductImageCacheRepositoryInterface = ProductImageCacheRepository.shared
    init(ImageServer:GetProductImage) {
        imageServer = ImageServer
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
        cacheRepository.setImage(key: productId, value: image)
    }
    private func returnCacheImage(productId:Int)->UIImage?{
        return cacheRepository.getImage(key: productId)
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
    func T_returnImage(productId:Int,imageURL:String?)->Observable<CellImageTag>{
        guard let cacheImage = returnCacheImage(productId: productId) else{
            return imageLoadObservable(productId:productId,imageURL: imageURL)
                .withUnretained(self)
                .map {
                    owner,cellImageTag in
                    switch cellImageTag.result {
                    case .success(let image):
                        let downImage = owner.returnImageObservable(productId: productId, image: image)
                        return CellImageTag(result: .success(downImage), tag: productId)
                    case .failure(let error):
                        print(error)
                        return CellImageTag(result: .failure(error), tag: productId)
                        
                    }
                }
        }
        return Observable<CellImageTag>.create { observer in
            observer.onNext(CellImageTag(result: .success(cacheImage), tag: productId))
            observer.onCompleted()
            return Disposables.create()
        }
    }
    func returnImageObservable(productId:Int,image:UIImage)->UIImage{
        let downImage = downImageSize(image: image)
        setCacheImage(productId: productId, image: image)
        return downImage
    }
    func imageLoadObservable(productId:Int,imageURL:String?)->Observable<CellImageTag>{
        return Observable<CellImageTag>.create {
            [weak self] observer in
            guard let self = self,let imageURL = imageURL else{
                let err = NSError(domain: "No ImageURL", code: -1)
                observer.onNext(CellImageTag(result: .failure(err), tag: productId))
                return Disposables.create()
            }
            self.imageServer.returnImage(imageURL: imageURL, onComplete: {
                result in
                switch result{
                case .success(let imageData):
                    let image = self.decodeImage(imageData: imageData)
                    observer.onNext(CellImageTag(result: .success(image), tag: productId))
                    observer.onCompleted()
                case .failure(let error):
                    observer.onNext(CellImageTag(result: .failure(error), tag: productId))
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
            return T_returnImage(productId: productId, imageURL: imageURL).withUnretained(self).map { owner,cellImageTag in
                switch cellImageTag.result{
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
