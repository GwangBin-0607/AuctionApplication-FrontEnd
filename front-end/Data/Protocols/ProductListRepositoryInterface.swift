import RxSwift
protocol ProductListRepositoryInterface{
    var productListObservable:Observable<Result<[Product],Error>>{get}
    var requestObserver:AnyObserver<Int>{get}
    func streamState(state: isConnecting)
    func observableSteamState() -> Observable<isConnecting>
    func buyProduct(Product:Product)
}
