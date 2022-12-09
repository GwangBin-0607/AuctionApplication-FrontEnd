import RxSwift

class ProductsListCollectionCellViewModel:BindingProductsListCollectionCellViewModel{
    let requestImage: AnyObserver<TestRequestImage>
    let responseImage: Observable<TestResponseImage>
    private let imageUseCase:RequestingProductImageLoad
    private let imageThread = DispatchQueue(label: "imageThread", qos: .background, attributes: .concurrent)
    init(ImageUseCase:RequestingProductImageLoad) {
        print("INIT")
        self.imageUseCase = ImageUseCase
        let requestImageSubject = PublishSubject<TestRequestImage>()
        requestImage = requestImageSubject.asObserver()
        responseImage = requestImageSubject.asObservable().observe(on: ConcurrentDispatchQueueScheduler.init(queue: imageThread)).flatMap({ re -> Observable<TestResponseImage> in
            print(re)
            return Observable<TestResponseImage>.create { observer in
                let image = ImageUseCase.returnImage(productId: re.productId,imageURL: re.imageURL)
                let responseImage = TestResponseImage(image: image, productId: re.productId)
                observer.onNext(responseImage)
                observer.onCompleted()
                return Disposables.create()
            }
        })
    }
}
