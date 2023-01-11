import RxSwift
protocol ProductListWithImageHeightUsecaseInterface{
    func returnProductList() -> Observable<Result<[Product], Error>>
    func returnRequestObserver() -> AnyObserver<Void>
    func returnObservableStreamState() -> Observable<SocketConnectState>
    func returnControlStreamState(state: isConnecting)
    func updateStreamProduct(visibleCell:[Int])->Observable<Error?>
}
class ProductListWithImageHeightUsecase{
    private let listRepo:ProductListRepositoryInterface
    private let imageHeightRepo:ProductImageRepositoryInterface
    init(ListRepo:ProductListRepositoryInterface,ImageHeightRepo:ProductImageRepositoryInterface) {
        listRepo = ListRepo
        imageHeightRepo = ImageHeightRepo
    }
}
extension ProductListWithImageHeightUsecase:ProductListWithImageHeightUsecaseInterface{
    func returnProductList() -> Observable<Result<[Product], Error>> {
        listRepo.productListObservable.withUnretained(self).flatMap { owner,result in
            switch result{
            case .success(let list):
                return owner.imageHeightRepo.returnProductWithImageHeight(product: list).flatMap { list in
                    return Observable<Result<[Product],Error>>.create { ob in
                        ob.onNext(.success(list))
                        ob.onCompleted()
                        return Disposables.create()
                    }
                }
            case .failure(let error):
                return Observable<Result<[Product],Error>>.create { observer in
                    observer.onNext(.failure(error))
                    observer.onCompleted()
                    return Disposables.create()
                }
            }
        }
    }
    func returnRequestObserver() -> AnyObserver<Void> {
        listRepo.requestObserver
    }
    func returnObservableStreamState() -> Observable<SocketConnectState> {
        listRepo.observableSteamState()
    }
    func returnControlStreamState(state: isConnecting) {
        listRepo.streamState(state: state)
    }
    func updateStreamProduct(visibleCell:[Int])->Observable<Error?>{
        let t = StreamStateData(result: 1)
        let set = Set(visibleCell)
        return listRepo.sendData(output: t) { err in
            print(err)
        }
    }
}
