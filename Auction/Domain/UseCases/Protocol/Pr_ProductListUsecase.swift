import RxSwift

protocol Pr_ProductListWithImageHeightUsecase{
    func returnProductList(imageWidth:CGFloat) -> Observable<Result<[Product], HTTPError>>
    func returnStreamProduct() -> Observable<Result<[StreamPrice],StreamError>>
    func returnObservableStreamState() -> Observable<isConnecting>
    func returnControlStreamState(state: isConnecting)
}
