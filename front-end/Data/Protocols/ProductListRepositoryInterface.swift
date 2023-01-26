import RxSwift
protocol ProductListRepositoryInterface{
    func streamState(state: isConnecting)
    func observableSteamState() -> Observable<isConnecting>
    func sendData(output data:Encodable)->Observable<Result<Bool,StreamError>>
    var streamingList:Observable<Result<[StreamPrice],StreamError>>{get}
    func httpList()->Observable<Result<[Product],HTTPError>>
}
