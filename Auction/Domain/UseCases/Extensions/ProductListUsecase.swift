import RxSwift
class ProductListWithImageHeightUsecase{
    private let listRepo:ProductListRepositoryInterface
    private let imageHeightRepo:ProductImageRepositoryInterface
    init(ListRepo:ProductListRepositoryInterface,ImageHeightRepo:ProductImageRepositoryInterface) {
        listRepo = ListRepo
        imageHeightRepo = ImageHeightRepo
        print("\(String(describing: self)) INIT")
    }
    deinit {
        print("\(String(describing: self)) DEINIT")
    }
}
extension ProductListWithImageHeightUsecase:Pr_ProductListWithImageHeightUsecase{
    func returnProductList(imageWidth:CGFloat) -> Observable<Result<[Product], HTTPError>> {
        listRepo.httpList().withUnretained(self).flatMap { owner,result in
            switch result{
            case .success(let list):
                return owner.imageHeightRepo.returnProductWithImageHeight(product: list,imageWidth:imageWidth).flatMap { list in
                    return Observable<Result<[Product],HTTPError>>.create { ob in
                        ob.onNext(.success(list))
                        ob.onCompleted()
                        return Disposables.create()
                    }
                }
            case .failure(let error):
                return Observable<Result<[Product],HTTPError>>.create { observer in
                    observer.onNext(.failure(error))
                    observer.onCompleted()
                    return Disposables.create()
                }
            }
        }
    }
    func returnObservableStreamState() -> Observable<isConnecting> {
        listRepo.observableSteamState()
    }
    func returnControlStreamState(state: isConnecting) {
        listRepo.streamState(state: state)
    }
    func returnStreamProduct() -> Observable<Result<[StreamPrice], StreamError>> {
        listRepo.streamingList
    }
}
