import Foundation
import RxSwift
enum isConnecting {
    case connect
    case disconnect
}
enum SocketOutputError:Error{
    case OutputError
    case EncodeError
}
enum SocketStateError:Error{
    case ServerEncounter
    case ClientEncounter
}
struct SocketConnectState {
    let socketConnect:isConnecting
    let error:SocketStateError?
}
final class SocketNetwork: NSObject,SocketNetworkInterface  {
    
    // MARK: INPUT
    let controlSocketConnect: AnyObserver<isConnecting>
    // MARK: OUTPUT
    let isSocketConnect: Observable<SocketConnectState>
    let inputDataObservable: Observable<Result<Data,Error>>
    
    
    private let isSocketConnected:AnyObserver<SocketConnectState>
    private let inputDataObserver:AnyObserver<Result<Data,Error>>
    private var inputStream: InputStream?
    private var outputStream: OutputStream?
    private let urlSession:URLSession
    private let hostName:String
    private let portNumber:Int
    private var shouldKeeping:Bool = false
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
        let connected = PublishSubject<SocketConnectState>()
        let inputPricing = PublishSubject<Result<Data,Error>>()
        controlSocketConnect = controlSocketNetwork.asObserver()
        isSocketConnect = connected.asObservable()
        isSocketConnected = connected.asObserver()
        inputDataObservable = inputPricing.asObservable()
        inputDataObserver = inputPricing.asObserver()
        super.init()
        // MARK: Connect Or Disconnect Server
        let connectingObservable = controlSocketNetwork.asObservable()
        connectingObservable.withUnretained(self).observe(on: ConcurrentDispatchQueueScheduler.init(qos: .background)).subscribe(onNext: {
            owner,state in
            switch state {
            case .connect:
                owner.connect()
            case .disconnect:
                owner.disconnect{
                    owner.isSocketConnected.onNext(SocketConnectState(socketConnect: .disconnect, error: SocketStateError.ClientEncounter))
                }
            }
        }).disposed(by: disposeBag)
        
        
        start()
    }
    private func connect() {
        let streamTask = urlSession.streamTask(withHostName: self.hostName, port: self.portNumber)
        streamTask.delegate = self
        streamTask.captureStreams()
        streamTask.resume()
    }
    private func disconnect(completion:@escaping()->Void = {}){
        shouldKeeping = false
        closeStream()
        removeFromThread()
        initStream()
        completion()
    }
    private var timer:DispatchSourceTimer!
    private var repeatTime = 5.0
    private func start(){
        timer = DispatchSource.makeTimerSource(queue: .global(qos: .background))
        timer.setEventHandler(handler: {
            [weak self] in
            if self?.inputStream?.streamStatus == .open,self?.outputStream?.streamStatus == .open,self?.shouldKeeping == true{
                self?.timer.cancel()
            }else{
                self?.connect()
            }
        })
        timer.schedule(wallDeadline: .now(), repeating: repeatTime)
        timer.resume()
    }
    private func removeFromThread(){
        guard let currentRunloop = currentRunloop else{
            return
        }
        inputStream?.remove(from:currentRunloop, forMode: .default)
        outputStream?.remove(from:currentRunloop, forMode: .default)
    }
    private func closeStream(){
        inputStream?.close()
        outputStream?.close()
    }
    private func initStream(){
        inputStream = nil
        outputStream = nil
    }
    deinit {
        print("SOCKET DEINIT")
    }
    let lock = NSLock()
    func sendData(data:Data,completion:@escaping(Error?)->Void){
        print(Thread.current)
        lock.lock()
        defer{
            lock.unlock()
        }
        data.withUnsafeBytes { pointer in
            let buffer = pointer.baseAddress!.assumingMemoryBound(to: UInt8.self)
            let result = outputStream?.write(buffer, maxLength: data.count)
            if result == nil || result == -1{
                completion(SocketOutputError.OutputError)
                
            }
        }
    }
}
extension SocketNetwork:StreamDelegate{
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case .openCompleted:
            print("connect")
            isSocketConnected.onNext(SocketConnectState(socketConnect: .connect, error: nil))
        case .hasBytesAvailable:
            if aStream == inputStream {
                var dataBuffer = Array<UInt8>(repeating: 0, count: 4096)
                var len: Int
                len = (inputStream?.read(&dataBuffer, maxLength: 4096))!
                if len > 0 {
                    let data = Data(bytes: &dataBuffer, count: len)
                    inputDataObserver.onNext(.success(data))
                }
            }
        case .hasSpaceAvailable:
            break;
        case .errorOccurred:
            guard let error = aStream.streamError else{
                return
            }
            inputDataObserver.onNext(.failure(error))
            break;
        case .endEncountered:
            isSocketConnected.onNext(SocketConnectState(socketConnect: .disconnect, error: SocketStateError.ServerEncounter))
            disconnect()
            start()
        default:
            print("Unknown event")
        }
    }
}
extension SocketNetwork:URLSessionStreamDelegate{
    func urlSession(_ session: URLSession, streamTask: URLSessionStreamTask, didBecome inputStream: InputStream, outputStream: OutputStream) {
        shouldKeeping = true
        currentRunloop = RunLoop.current
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
