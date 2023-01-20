import RxSwift
protocol ProductListRepositoryInterface{
    var productListObservable:Observable<Result<[Product],Error>>{get}
    var requestObserver:AnyObserver<Void>{get}
    func streamState(state: isConnecting)
    func observableSteamState() -> Observable<isConnecting>
    func sendData(output data:Encodable)->Observable<Result<Bool,Error>>
}
