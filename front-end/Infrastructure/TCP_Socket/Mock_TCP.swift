import RxSwift
class Mock_TCP:SocketNetworkInterface{
    let controlSocketConnect: AnyObserver<isConnecting>
    
    let outputDataObserver: AnyObserver<Data?>
    
    let inputDataObservable: Observable<Data>
    
    let isSocketConnect: Observable<isConnecting>
    private let inputObserver:AnyObserver<Data>
    private let disposeBag:DisposeBag
    init(){
        disposeBag = DisposeBag()
        let connectSubject = PublishSubject<isConnecting>()
        let inputDataSubject = PublishSubject<Data>()
        let outputDataSubject = PublishSubject<Data?>()
        controlSocketConnect = connectSubject.asObserver()
        isSocketConnect = connectSubject.asObservable()
        inputDataObservable = inputDataSubject.asObservable()
        outputDataObserver = outputDataSubject.asObserver()
        inputObserver = inputDataSubject.asObserver()
        let isSocketConnectObservable = connectSubject.asObservable()
        isSocketConnectObservable.observe(on: MainScheduler.asyncInstance).subscribe(onNext: {
            isconnect in
            print(Thread.isMainThread)
            if isconnect == .connect{
                print(isconnect)
                                self.startSocket()
            }
        }).disposed(by: disposeBag)
        
    }
    private func startSocket(){
        testInputData()
    }
    private func testInputData(){
        print("Set")
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(TimerAction), userInfo: nil, repeats: true)
    }
    @objc private func TimerAction(){
        print("timer")
        do{
            let data = try getData()
            inputObserver.onNext(data)
        }catch{
            print(error)
        }
    }
    private func getData()throws->Data{
        guard let path = Bundle.main.path(forResource: "StreamingProductPriceListTestData", ofType: "json")
                ,let jsonString = try? String(contentsOfFile: path)
                ,let data = jsonString.data(using: .utf8)else{
            throw NSError(domain: "Not Data", code: -1)
        }
        return data
    }
    deinit {
        print("TCP DEINIT")
    }
    
}
