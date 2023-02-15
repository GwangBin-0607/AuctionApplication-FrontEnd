import Foundation
import UIKit
import RxSwift
class ProductImageRepository:ProductImageRepositoryInterface{
    private let imageServer:GetProductImage
    private let cacheRepository:ProductImageCacheRepositoryInterface
    private let imageWidth:CGFloat
    init(ImageServer:GetProductImage,CacheRepository:ProductImageCacheRepositoryInterface,imageWidth:CGFloat) {
        imageServer = ImageServer
        cacheRepository = CacheRepository
        self.imageWidth = imageWidth
        print("\(String(describing: self)) INIT")
    }
    deinit {
        print("\(String(describing: self)) DEINIT")
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
    private func downImageSize(image:UIImage,newWidth:CGFloat) -> UIImage{
        let scale = newWidth / image.size.width
        print(scale)
        let newHeight = image.size.height * scale

        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
        return renderImage
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
                        let downImage = owner.returnDownImage(productId: productId, image: image)
                        return CellImageTag(result: .success(downImage), tag: productId)
                    case .failure(let error):
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
    private func returnDownImage(productId:Int,image:UIImage)->UIImage{
        let downImage = downImageSize(image: image, newWidth: imageWidth)
        setCacheImage(productId: productId, image: downImage)
        return downImage
    }
    private func imageLoadObservable(productId:Int,imageURL:String?)->Observable<CellImageTag>{
        return Observable<CellImageTag>.create {
            [weak self] observer in
            guard let self = self,let imageURL = imageURL else{
                observer.onNext(CellImageTag(result: .failure(HTTPError.RequestError), tag: productId))
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
                return inProduct
            }
        }
        return Observable<Product>.create {
            [weak self] observer in
            inProduct.imageHeight = self?.returnImageHeight(image: CacheImage)
            observer.onNext(inProduct)
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func returnProductWithImageHeight(product: [Product]) -> Observable<[Product]> {
        var observables:[Observable<Product>]=[]
        product.forEach { product in
            if product.imageHeight == nil{
                let observable = returnImageHeight(product:product)
                observables.append(observable)
            }else{
                let observable = Observable<Product>.create { ob in
                    ob.onNext(product)
                    ob.onCompleted()
                    return Disposables.create()
                }
                observables.append(observable)
            }
        }
        return Observable.combineLatest(observables)
    }

}
