import Foundation

final class Network: NSObject, StreamDelegate,URLSessionStreamDelegate  {
    
    var streamTask: URLSessionStreamTask?
    var urlSession:URLSession!
    var inputStream: InputStream?
    var outputStream: OutputStream?
    var shouldKeeping = true
    
    override init() {
        
    }
    
    func connect(hostName: String, portNumber: Int) {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        self.streamTask = urlSession.streamTask(withHostName: hostName, port: portNumber)
        streamTask?.delegate = self
        streamTask?.captureStreams()
        streamTask?.resume()
        
    }
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case .openCompleted:
            print("Stream opened")
        case .hasBytesAvailable:
            print("-------AVAILE--------")
            if aStream == inputStream {
                var dataBuffer = Array<UInt8>(repeating: 0, count: 1024)
                var len: Int
                len = (inputStream?.read(&dataBuffer, maxLength: 1024))!
                if len > 0 {
                    let output = String(bytes: dataBuffer, encoding: .utf8)
                    if nil != output {
                        print("server said: \(output ?? "")")
                    }
                }
            }else if(aStream == outputStream){
                print("!!!!!!!!!!!!!!!!!!")
            }
        case .hasSpaceAvailable:
            if(aStream == inputStream){
                print("input")
            }else if(aStream == outputStream){
                print("output")
            }
            print("Stream has space available now")
        case .errorOccurred:
            print("---------------")
            print("\(aStream.streamError?.localizedDescription ?? "")")
        case .endEncountered:
            aStream.close()
            aStream.remove(from: .current, forMode: RunLoop.Mode.default)
            print("close stream")
        default:
            print("Unknown event")
        }
    }
    func send(message: String){
        let response = "msg:\(message)"
        let buff = [UInt8](message.utf8)
        if let _ = response.data(using: .ascii) {
            self.outputStream?.write(buff, maxLength: buff.count)
        }
        
        
        
    }
    func urlSession(_ session: URLSession, streamTask: URLSessionStreamTask, didBecome inputStream: InputStream, outputStream: OutputStream) {
        print(Thread.current)
        self.inputStream = inputStream
        self.outputStream = outputStream
        self.inputStream?.delegate = self//Streme opened
        self.outputStream?.delegate = self//Streme opened
        self.inputStream?.schedule(in: .current, forMode: .default)
        self.outputStream?.schedule(in: .current, forMode: .default)
        self.inputStream?.open()
        self.outputStream?.open()
        while(shouldKeeping&&RunLoop.current.run(mode: .default, before: .now+5.0)){
            print("Get")
        }
        print("End")
        //        RunLoop.current.run()
        
    }
    
    
}
