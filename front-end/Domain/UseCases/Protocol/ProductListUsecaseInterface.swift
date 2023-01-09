import RxSwift

protocol ProductListUsecaseInterface{
    func returnProductList()->Observable<Result<[Product],Error>>
    func returnRequestObserver()->AnyObserver<Void>
    func returnControlStreamState(state:isConnecting)
    func returnObservableStreamState()->Observable<SocketConnectState>
    func updateStreamProduct(visibleCell:[Int])->Observable<Error?>
}
