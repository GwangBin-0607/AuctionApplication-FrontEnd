import RxSwift

protocol ProductListUsecaseInterface{
    func returnProductList()->Observable<Result<[Product],Error>>
    func returnRequestObserver()->AnyObserver<Int>
    func returnControlStreamState(state:isConnecting)
    func returnObservableStreamState()->Observable<isConnecting>
}
