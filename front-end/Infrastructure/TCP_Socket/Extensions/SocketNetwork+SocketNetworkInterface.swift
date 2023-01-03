import Foundation
import RxSwift

enum isConnecting {
    case connect
    case disconnect
}
class SocketNetwork: NSObject,SocketNetworkInterface  {
    // MARK: INPUT
    private enum SocketOutputError:Error{
        case OutputError
    }
    let controlSocketConnect: AnyObserver<isConnecting>
    // MARK: OUTPUT
    let isSocketConnect: Observable<isConnecting>
    let inputDataObservable: Observable<Result<Data,Error>>
    
    
    private let isSocketConnected:AnyObserver<isConnecting>
    private let inputDataObserver:AnyObserver<Result<Data,Error>>
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
        print("Socket Init")
        self.hostName = hostName
        self.portNumber = portNumber
        self.urlSession = URLSession(configuration: URLSessionConfiguration.default)
        disposeBag = DisposeBag()
        
        let controlSocketNetwork = PublishSubject<isConnecting>()
        let connected = PublishSubject<isConnecting>()
        let inputPricing = PublishSubject<Result<Data,Error>>()
        controlSocketConnect = controlSocketNetwork.asObserver()
        isSocketConnect = connected.asObservable()
        isSocketConnected = connected.asObserver()
        inputDataObservable = inputPricing.asObservable()
        inputDataObserver = inputPricing.asObserver()
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
        
        
//        connect()
    }
    private func connect() {
        let streamTask = urlSession.streamTask(withHostName: self.hostName, port: self.portNumber)
        streamTask.delegate = self
        streamTask.captureStreams()
        streamTask.resume()
        switch  streamTask.state {
        case .running:
            print("runnig")
        case .completed:
            print("complete")
        default:
            print("default")
        }
    }
    private func disconnect(){
        shouldKeeping = false
        closeStream()
        removeFromThread()
    }
    var timer:DispatchSourceTimer!
    func reconnect(){
        print("reconnect")
        timer = DispatchSource.makeTimerSource(queue: .global(qos: .background))
        timer.setEventHandler(handler: {
            [weak self] in
            if self?.inputStream?.streamStatus == .open,self?.outputStream?.streamStatus == .open,self?.shouldKeeping == true{
                self?.timer.cancel()
            }else{
                self?.shouldKeeping = true
                self?.connect()
            }
        })
        timer.schedule(wallDeadline: .now()+1.0, repeating: 1.0)
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
    deinit {
        print("SOCKET DEINIT")
    }
    func sendData(data: Data, completion: @escaping (Error?) -> Void) {
        data.withUnsafeBytes { pointer in
            let buffer = pointer.baseAddress!.assumingMemoryBound(to: UInt8.self)
            let result = outputStream?.write(buffer, maxLength: data.count)
            if result == -1{
                completion(SocketOutputError.OutputError)
            }else{
                completion(nil)
            }
        }
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
                    inputDataObserver.onNext(.success(data))
                }
            }
        case .hasSpaceAvailable:
            print("Stream has space available now")
        case .errorOccurred:
            guard let error = aStream.streamError else{
                return
            }
            inputDataObserver.onNext(.failure(error))
            print("\(aStream.streamError?.localizedDescription ?? "")")
        case .endEncountered:
            print("End counter")
            isSocketConnected.onNext(isConnecting.disconnect)
            disconnect()
            reconnect()
        default:
            print("Unknown event")
        }
    }
}
extension SocketNetwork:URLSessionStreamDelegate{
    func urlSession(_ session: URLSession, streamTask: URLSessionStreamTask, didBecome inputStream: InputStream, outputStream: OutputStream) {
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
