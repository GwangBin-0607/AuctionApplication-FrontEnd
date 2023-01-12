import RxSwift

protocol ProductListWithImageHeightUsecaseInterface{
    func returnProductList() -> Observable<Result<[Product], Error>>
    func returnRequestObserver() -> AnyObserver<Void>
    func returnObservableStreamState() -> Observable<SocketConnectState>
    func returnControlStreamState(state: isConnecting)
    func updateStreamProduct(visibleCell:[Int])->Observable<Result<ResultData,Error>>
}
