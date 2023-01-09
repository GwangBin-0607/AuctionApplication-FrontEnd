import Foundation
import UIKit
import RxSwift
class ProductImageRepository:ProductImageRepositoryInterface{
    private let imageServer:GetProductImage
    private let cacheRepository:ProductImageCacheRepositoryInterface = ProductImageCacheRepository.shared
    init(ImageServer:GetProductImage) {
        imageServer = ImageServer
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
    func returnImage(productId:Int,imageURL:String?)->Observable<CellImageTag>{
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
    private func returnImageObservable(productId:Int,image:UIImage)->UIImage{
        let downImage = downImageSize(image: image)
        setCacheImage(productId: productId, image: image)
        return downImage
    }
    private func imageLoadObservable(productId:Int,imageURL:String?)->Observable<CellImageTag>{
        return Observable<CellImageTag>.create {
            [weak self] observer in
            guard let self = self,let imageURL = imageURL else{
                let err = NSError(domain: "No ImageURL", code: -1)
                observer.onNext(CellImageTag(result: .failure(err), tag: productId))
                observer.onCompleted()
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
                    observer.onCompleted()
                }
                
            })
            return Disposables.create()
        }
    }
    private func decodeImage(imageData:Data)->UIImage{
        return UIImage(data: imageData)!
    }
    private func returnImageHeight(product:Product)->Observable<Product>{
        var inProduct = product
        guard let CacheImage = self.returnCacheImage(productId: inProduct.product_id)
        else{
            return returnImage(productId: inProduct.product_id, imageURL: inProduct.mainImageURL).withUnretained(self).map { owner,cellImageTag in
                switch cellImageTag.result{
                case .success(let image):
                    inProduct.imageHeight = owner.returnImageHeight(image: image)
                case .failure(_):
                    inProduct.imageHeight = 150
                }
                return product
            }
        }
        return Observable<Product>.create {
            [weak self] observer in
            inProduct.imageHeight = self?.returnImageHeight(image: CacheImage)
            observer.onNext(product)
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func returnProductWithImageHeight(product: [Product]) -> Observable<[Product]> {
        var observables:[Observable<Product>]=[]
        product.forEach { product in
            let observable = returnImageHeight(product:product)
            observables.append(observable)
        }
        return Observable.combineLatest(observables)
    }

}
