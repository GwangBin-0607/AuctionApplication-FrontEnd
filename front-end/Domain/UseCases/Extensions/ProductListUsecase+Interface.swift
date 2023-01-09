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
    func returnObservableStreamState() -> Observable<SocketConnectState> {
        repo.observableSteamState()
    }
    func returnControlStreamState(state: isConnecting) {
        repo.streamState(state: state)
    }
    deinit {
        print("USECASE DEINIT")
    }
    func updateStreamProduct(visibleCell:[Int])->Observable<Error?>{
        let set = Set(visibleCell)
        return repo.sendData(output: set) { err in
            print(err)
        }
    }
}
