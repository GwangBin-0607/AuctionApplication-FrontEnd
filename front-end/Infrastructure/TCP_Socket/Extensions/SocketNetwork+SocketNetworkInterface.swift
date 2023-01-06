import Foundation
import RxSwift
enum isConnecting {
    case connect
    case disconnect
}
enum SocketOutputError:Error{
    case OutputError
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
    let inputDataObservable: Observable<Result<Decodable,Error>>
    
    
    private let isSocketConnected:AnyObserver<SocketConnectState>
    private let inputDataObserver:AnyObserver<Result<Decodable,Error>>
    private var inputStream: InputStream?
    private var outputStream: OutputStream?
    private let urlSession:URLSession
    private let hostName:String
    private let portNumber:Int
    private var shouldKeeping:Bool = false
    private let disposeBag:DisposeBag
    private var currentRunloop:RunLoop?
    private let socketCompletionHandler:OutputStreamCompletionHandlerInterface
    private let inputStreamDataTransfer:InputStreamDataTransferInterface
    /// - parameter hostName: host Address
    /// - parameter portNumber: port Number
    init(hostName: String, portNumber: Int) {
        print("Socket Init")
        socketCompletionHandler = OutputStreamCompletionHandler()
        inputStreamDataTransfer = InputStreamDataTransfer()
        self.hostName = hostName
        self.portNumber = portNumber
        self.urlSession = URLSession(configuration: URLSessionConfiguration.default)
        disposeBag = DisposeBag()
        
        let controlSocketNetwork = PublishSubject<isConnecting>()
        let connected = PublishSubject<SocketConnectState>()
        let inputPricing = PublishSubject<Result<Decodable,Error>>()
        controlSocketConnect = controlSocketNetwork.asObserver()
        isSocketConnect = connected.asObservable()
        isSocketConnected = connected.asObserver()
        inputDataObservable = inputPricing.asObservable()
        inputDataObserver = inputPricing.asObserver()
        super.init()
        T_Encode()
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
    func sendData(data: Data, completion: @escaping (Error?) -> Void) {
        data.withUnsafeBytes { pointer in
            let buffer = pointer.baseAddress!.assumingMemoryBound(to: UInt8.self)
            if let result = outputStream?.write(buffer, maxLength: data.count),result != -1{
                completion(nil)
            }else{
                completion(SocketOutputError.OutputError)
            }
        }
    }
    func T_Encode(){
        let t = OutputStreamData(dataType: .OutputStreamReaded, data: StreamPrice(product_id: 150, product_price: 150))
        do{
            let data = try JSONEncoder().encode(t)
            print(data)
        }catch{
            print(error)
        }
        
    }
    func sendData(data:Encodable,outputStreamCompletion:@escaping(Error?)->Void,inputStreamCompletion:@escaping ()->Void){
        let data = OutputStreamData(dataType: .OutputStreamReaded, data: data)
    }
}
extension SocketNetwork:StreamDelegate{
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case .openCompleted:
            print("Open")
            isSocketConnected.onNext(SocketConnectState(socketConnect: .connect, error: nil))
        case .hasBytesAvailable:
            print("Has")
            if aStream == inputStream {
                var dataBuffer = Array<UInt8>(repeating: 0, count: 1024)
                var len: Int
                len = (inputStream?.read(&dataBuffer, maxLength: 1024))!
                print(len)
                if len > 0 {
                    let data = Data(bytes: &dataBuffer, count: len)
                    do{
                        let dataType = try inputStreamDataTransfer.decodeInputStreamDataType(data: data)
                        switch dataType.dataType {
                        case .InputStreamProductPrice:
                            inputDataObserver.onNext(.success(dataType.data))
                        case .OutputStreamReaded:
                            guard let resultOutputStreamReaded = dataType.data as? ResultOutputStreamReaded,resultOutputStreamReaded.result else{
                                return
                            }
                            socketCompletionHandler.executeCompletion(completionId: resultOutputStreamReaded.completionId)
                        }
                    }catch InputStreamDataDecodeError.ProductPriceDecodeError{
                        inputDataObserver.onNext(.failure(InputStreamDataDecodeError.ProductPriceDecodeError))
                    }catch {
                        print(error)
                    }
                }
            }
        case .hasSpaceAvailable:
            break;
        case .errorOccurred:
            guard let error = aStream.streamError else{
                return
            }
            inputDataObserver.onNext(.failure(error))
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
