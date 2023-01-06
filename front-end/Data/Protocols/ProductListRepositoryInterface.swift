import RxSwift
protocol ProductListRepositoryInterface{
    var productListObservable:Observable<Result<[Product],Error>>{get}
    var requestObserver:AnyObserver<Void>{get}
    func streamState(state: isConnecting)
    func observableSteamState() -> Observable<SocketConnectState>
    func buyProduct(output productPrice:StreamPrice)->Observable<Error?>
}
