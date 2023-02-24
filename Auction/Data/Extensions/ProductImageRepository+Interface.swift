import Foundation
import UIKit
import RxSwift
class ProductImageRepository:ProductImageRepositoryInterface{
    private let imageServer:GetProductImage
    private let cacheRepository:ProductImageCacheRepositoryInterface
    private let httpTransfer:Pr_HTTPDataTransferProductImage
    init(ImageServer:GetProductImage,CacheRepository:ProductImageCacheRepositoryInterface,httpTransfer:Pr_HTTPDataTransferProductImage) {
        self.httpTransfer = httpTransfer
        imageServer = ImageServer
        cacheRepository = CacheRepository
        print("\(String(describing: self)) INIT")
    }
    deinit {
        print("\(String(describing: self)) DEINIT")
    }
    private func returnImageHeight(image:UIImage)->CGFloat{
        image.size.height
    }
    private func setCacheImage(image_id:Int,image:UIImage){
        cacheRepository.setImage(key: image_id, value: image)
    }
    private func returnCacheImage(image_id:Int)->UIImage?{
        return cacheRepository.getImage(key: image_id)
    }
    private func downImageSize(image:UIImage,newWidth:CGFloat) -> UIImage{
        let scale = newWidth / image.size.width
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
    func returnCellImageTag(product_image:Image?,imageWidth:CGFloat,tag:Int)->Observable<CellImageTag>{
        guard let product_image = product_image else{
            return Observable<CellImageTag>.create { observer in
                observer.onNext(CellImageTag(result: .failure(HTTPError.RequestError), tag: tag))
                observer.onCompleted()
                return Disposables.create()
            }
        }
        guard let cacheImage = returnCacheImage(image_id: product_image.image_id) else{
            return imageLoadObservable(image_id: product_image.image_id)
                .withUnretained(self)
                .map {
                    owner,result in
                    switch result {
                    case .success(let image):
                        let downImage = owner.returnDownImage(image_id: product_image.image_id, image: image, imageWidth: imageWidth)
                        return CellImageTag(result: .success(downImage), tag: tag)
                    case .failure(let error):
                        return CellImageTag(result: .failure(error), tag: tag)
                        
                    }
                }
        }
        return Observable<CellImageTag>.create { observer in
            observer.onNext(CellImageTag(result: .success(cacheImage), tag: tag))
            observer.onCompleted()
            return Disposables.create()
        }
    }
    private func returnImage(product_image:Image,imageWidth:CGFloat)->Observable<Result<UIImage,HTTPError>>{
        guard let cacheImage = returnCacheImage(image_id: product_image.image_id) else{
            return imageLoadObservable(image_id: product_image.image_id)
                .withUnretained(self)
                .map {
                    owner,result in
                    switch result {
                    case .success(let image):
                        let downImage = owner.returnDownImage(image_id: product_image.image_id, image: image,imageWidth: imageWidth)
                        return .success(downImage)
                    case .failure(let error):
                        return .failure(error)
                        
                    }
                }
        }
        return Observable<Result<UIImage,HTTPError>>.create { observer in
            observer.onNext(.success(cacheImage))
            observer.onCompleted()
            return Disposables.create()
        }
    }
    private func returnDownImage(image_id:Int,image:UIImage,imageWidth:CGFloat)->UIImage{
        let downImage = downImageSize(image: image, newWidth: imageWidth)
        setCacheImage(image_id:image_id, image: downImage)
        return downImage
    }
    private func imageLoadObservable(image_id:Int)->Observable<Result<UIImage,HTTPError>>{
        return Observable<Result<UIImage,HTTPError>>.create {
            [weak self] observer in
            guard let self = self,let data = try? self.httpTransfer.requestProductImage(requestData: RequestProductImage(image_id: image_id)) else{
                observer.onNext(.failure(HTTPError.RequestError))
                observer.onCompleted()
                return Disposables.create()
            }
            self.imageServer.returnImage(requestData: data, onComplete: {
                result in
                switch result {
                case .success(let data):
                    let image = self.decodeImage(imageData: data)
                    observer.onNext(.success(image))
                    observer.onCompleted()
                case .failure(let error):
                    observer.onNext(.failure(error))
                    observer.onCompleted()
                }
            })
            return Disposables.create()
        }
    }
    private func decodeImage(imageData:Data)->UIImage{
        return UIImage(data: imageData)!
    }
    private func returnImageHeight(product:Product,imageWidth:CGFloat)->Observable<Product>{
        var inProduct = product
        if let product_image = product.mainImage{
            return returnImage(product_image: product_image,imageWidth: imageWidth).withUnretained(self).map { owner,result in
                switch result{
                case .success(let image):
                    inProduct.imageHeight = owner.returnImageHeight(image: image)
                case .failure(_):
                    inProduct.imageHeight = 150
                }
                return inProduct
            }
        }else{
            return Observable<Product>.create { observer in
                inProduct.imageHeight = 150
                observer.onNext(inProduct)
                observer.onCompleted()
                return Disposables.create()
            }
        }
        
    }
    
    func returnProductWithImageHeight(product: [Product],imageWidth:CGFloat) -> Observable<[Product]> {
        var observables:[Observable<Product>]=[]
        product.forEach { product in
            if product.imageHeight == nil{
                let observable = returnImageHeight(product:product,imageWidth: imageWidth)
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
