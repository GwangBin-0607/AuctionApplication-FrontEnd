import RxSwift
protocol ProductListRepositoryInterface{
    func streamState(state: isConnecting)
    func observableSteamState() -> Observable<isConnecting>
    func sendData(output data:Encodable)->Observable<Result<Bool,Error>>
    var streamingList:Observable<Result<[StreamPrice],Error>>{get}
    func T_transfer()->Observable<Result<[Product],Error>>
}
