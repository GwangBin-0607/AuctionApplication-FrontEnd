import RxSwift
class ProductListUsecase:ProductListUsecaseInterface{
    let repo:ProductListRepositoryInterface
    init(repo: ProductListRepositoryInterface) {
        self.repo = repo
    }
    func returnProductList() -> Observable<Result<[Product], Error>> {
        repo.productListObservable
    }
    func returnRequestObserver() -> AnyObserver<Void> {
        repo.requestObserver
    }
    func returnObservableStreamState() -> Observable<isConnecting> {
        repo.observableSteamState()
    }
    func returnControlStreamState(state: isConnecting) {
        repo.streamState(state: state)
    }
}
