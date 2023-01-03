//
//  NameSpaceSocket.swift
//  front-end
//
//  Created by 안광빈 on 2022/12/27.
//

import Foundation
import RxSwift
import Network

final class SocketNWConnection:SocketNetworkInterface{
    let isSocketConnect: Observable<SocketState>
    let controlSocketConnect: AnyObserver<isConnecting>
    let inputDataObservable: Observable<Result<Data,Error>>
    private var connection:NWConnection?
    private let host:NWEndpoint.Host
    private let port:NWEndpoint.Port
    private let thread = DispatchQueue(label: "quee",qos: .background)
    private let disposeBag:DisposeBag
    private let isSocketConnected:AnyObserver<SocketState>
    private let inputDataObserver:AnyObserver<Result<Data,Error>>
    init(Host:NWEndpoint.Host,Port:NWEndpoint.Port) {
        disposeBag = DisposeBag()
        let controlSocketNetwork = PublishSubject<isConnecting>()
        let connected = PublishSubject<SocketState>()
        let inputPricing = PublishSubject<Result<Data,Error>>()
        controlSocketConnect = controlSocketNetwork.asObserver()
        isSocketConnect = connected.asObservable()
        isSocketConnected = connected.asObserver()
        inputDataObservable = inputPricing.asObservable()
        inputDataObserver = inputPricing.asObserver()
        host = Host
        port = Port
        controlSocketNetwork.asObservable().subscribe(onNext: {
            isConnecting in
            print(isConnecting)
            self.connection?.forceCancel()
            print("Tap")
        }).disposed(by: disposeBag)
        startConnection()
        
    }
    func setUpdateHandler(){
        connection?.stateUpdateHandler = {
            [weak self] (state) in
            switch state {
            case .failed(_),.waiting(_),.cancelled:
                print("Cancel")
                self?.timeInterval = .now()+5.0
                self?.isSocketConnected.onNext(SocketState(socketConnect: .disconnect, error: SocketStateError.Encounter))
                self?.startConnection()
            case .preparing:
                print("Preparing")
            case .ready:
                self?.isSocketConnected.onNext(SocketState(socketConnect: .connect, error: nil))
                self?.connect = true
                print("ready")
            case .setup:
                print("setup")
            @unknown default:
                break;
            }
            
        }
    }
    func initConnection(){
        connection = NWConnection(host: host, port: port, using: .tcp)
        connect = false
    }
    func startConnection(){
        initConnection()
        setUpdateHandler()
        start()
        receive()
    }
    func receive(){
        connection?.receive(minimumIncompleteLength: 0, maximumLength: 1000) {
            [weak self] content, contentContext, isComplete, error in
            if content == nil,isComplete{
                print("CAN")
                // Server Down
                self?.connection?.cancel()
            }else if let content = content,!isComplete{
                self?.inputDataObserver.onNext(.success(content))
                self?.receive()
            }else if let error = error{
                self?.inputDataObserver.onNext(.failure(error))
            }
        }
    }
    private var connect:Bool = false
    private var timeInterval:DispatchWallTime = .now()
    private var timer:DispatchSourceTimer?
    func start(){
        timer = DispatchSource.makeTimerSource(queue: .global(qos: .background))
        timer?.setEventHandler(handler: {
            [weak self] in
            if self?.connect == false,let queue = self?.thread{
                self?.connection?.start(queue: queue)
            }else if self?.connect == true{
                self?.timer?.cancel()
            }
        })
        timer?.schedule(wallDeadline: timeInterval, repeating: 5.0)
        timer?.resume()
    }
    func sendData(data: Data, completion: @escaping (Error?) -> Void) {
        connection?.send(content: data, contentContext: .defaultMessage, isComplete: true, completion: .contentProcessed({ error in
            completion(error)
        }))
    }
    deinit {
        print("NWConnection DEINIT")
    }
}
class TestRepository{
    let con = SocketNWConnection(Host: "localhost", Port: 3200)
    func sendData(ProductPrice:StreamPrice){
        let encode = JSONEncoder()
        do{
            let data = try encode.encode(ProductPrice)
            con.sendData(data: data, completion: {
                error in
                print(error)
            })
        }catch{
            print(error)
        }
    }
}
