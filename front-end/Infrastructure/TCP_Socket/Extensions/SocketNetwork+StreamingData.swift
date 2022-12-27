import Foundation
import RxSwift

enum isConnecting {
    case connect
    case disconnect
}
class SocketNetwork: NSObject,StreamingData  {
    // MARK: INPUT
    let controlSocketConnect: AnyObserver<isConnecting>
    let outputDataObserver: AnyObserver<Data?>
    // MARK: OUTPUT
    let isSocketConnect: Observable<isConnecting>
    let inputDataObservable: Observable<Data>
    
    
    private let isSocketConnected:AnyObserver<isConnecting>
    private let outputDataObservable:Observable<Data?>
    private let inputDataObserver:AnyObserver<Data>
    private var inputStream: InputStream?
    private var outputStream: OutputStream?
    private let urlSession:URLSession
    private let hostName:String
    private let portNumber:Int
    private var shouldKeeping = true
    private let disposeBag:DisposeBag
    private var currentRunloop:RunLoop?
    
    /// - parameter hostName: host Address
    /// - parameter portNumber: port Number
    init(hostName: String, portNumber: Int) {
        self.hostName = hostName
        self.portNumber = portNumber
        self.urlSession = URLSession(configuration: URLSessionConfiguration.default)
        disposeBag = DisposeBag()
        
        let controlSocketNetwork = PublishSubject<isConnecting>()
        let connected = PublishSubject<isConnecting>()
        let inputPricing = PublishSubject<Data>()
        let outputPricing = PublishSubject<Data?>()
        controlSocketConnect = controlSocketNetwork.asObserver()
        isSocketConnect = connected.asObservable()
        isSocketConnected = connected.asObserver()
        inputDataObservable = inputPricing.asObservable()
        outputDataObservable = outputPricing.asObservable()
        inputDataObserver = inputPricing.asObserver()
        outputDataObserver = outputPricing.asObserver()
        super.init()
        
        // MARK: Connect Or Disconnect Server
        let connectingObservable = controlSocketNetwork.asObservable()
        connectingObservable.withUnretained(self).subscribe(onNext: {
            owner,state in
            switch state {
            case .connect:
                owner.connect()
            case .disconnect:
                owner.disconnect()
            }
        }).disposed(by: disposeBag)
        
        // MARK: Write Output Stream
        outputDataObservable.observe(on: ConcurrentDispatchQueueScheduler.init(qos: .background)).withUnretained(self).subscribe(onNext: {
            owner,data in
            guard let data = data else{
                return
            }
            let _ = data.withUnsafeBytes { pointer in
                let buffer = pointer.baseAddress!.assumingMemoryBound(to: UInt8.self)
                owner.outputStream?.write(buffer, maxLength: data.count)
            }
        }).disposed(by: disposeBag)
        
        connect()
    }
    
    private func connect() {
        let streamTask = urlSession.streamTask(withHostName: self.hostName, port: self.portNumber)
        streamTask.delegate = self
        streamTask.captureStreams()
        streamTask.resume()
    }
    private func disconnect(){
        shouldKeeping = false
        closeStream()
        removeFromThread()
    }
    private func reconnect(){
        shouldKeeping = true
        connect()
    }
    private func removeFromThread(){
        guard let currentRunloop = currentRunloop else{
            return
        }
        self.inputStream?.remove(from:currentRunloop, forMode: .default)
        self.outputStream?.remove(from:currentRunloop, forMode: .default)
    }
    private func closeStream(){
        self.inputStream?.close()
        self.outputStream?.close()
    }
    deinit {
        print("SOCKET DEINIT")
    }
    
}
extension SocketNetwork:StreamDelegate{
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case .openCompleted:
            isSocketConnected.onNext(isConnecting.connect)
            print("Stream opened")
        case .hasBytesAvailable:
            print("hasBytesAvailable")
            if aStream == inputStream {
                var dataBuffer = Array<UInt8>(repeating: 0, count: 1024)
                var len: Int
                len = (inputStream?.read(&dataBuffer, maxLength: 1024))!
                if len > 0 {
                    let data = Data(bytes: &dataBuffer, count: len)
                    inputDataObserver.onNext(data)
                }
            }
        case .hasSpaceAvailable:
            print("Stream has space available now")
        case .errorOccurred:
            print("\(aStream.streamError?.localizedDescription ?? "")")
        case .endEncountered:
            print("End counter")
            isSocketConnected.onNext(isConnecting.disconnect)
            disconnect()
        default:
            print("Unknown event")
        }
    }
}
extension SocketNetwork:URLSessionStreamDelegate{
    func urlSession(_ session: URLSession, streamTask: URLSessionStreamTask, didBecome inputStream: InputStream, outputStream: OutputStream) {
        self.currentRunloop = RunLoop.current
        self.inputStream = inputStream
        self.outputStream = outputStream
        self.inputStream?.delegate = self
        self.outputStream?.delegate = self
        self.inputStream?.schedule(in: .current, forMode: .default)
        self.outputStream?.schedule(in: .current, forMode: .default)
        self.inputStream?.open()
        self.outputStream?.open()
        while(shouldKeeping&&RunLoop.current.run(mode: .default, before: .now+1.0)){}
    }
    
}
