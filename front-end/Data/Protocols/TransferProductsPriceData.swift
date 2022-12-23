import RxSwift
protocol ObserverSocketState{
    func streamState(state:isConnecting)
    func observableSteamState()->Observable<isConnecting>
}
