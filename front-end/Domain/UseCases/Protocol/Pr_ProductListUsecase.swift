import RxSwift

protocol Pr_ProductListWithImageHeightUsecase{
    func returnProductList() -> Observable<Result<[Product], Error>>
    func returnStreamProduct() -> Observable<Result<[StreamPrice],Error>>
    func returnObservableStreamState() -> Observable<isConnecting>
    func returnControlStreamState(state: isConnecting)
    func updateStreamProduct(visibleCell:[Int])->Observable<Result<Bool,Error>>
}
