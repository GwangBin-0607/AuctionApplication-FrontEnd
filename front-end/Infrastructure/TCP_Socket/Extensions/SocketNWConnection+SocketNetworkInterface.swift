//
//  NameSpaceSocket.swift
//  front-end
//
//  Created by 안광빈 on 2022/12/27.
//

import Foundation
import RxSwift
import Network

final class SocketNWConnection:SocketNetworkInterface {
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
    private let productListServiceState:StreamProductListServiceInterface
    init(Host:NWEndpoint.Host,Port:NWEndpoint.Port,ProductListServiceState:StreamProductListServiceInterface) {
        disposeBag = DisposeBag()
        productListServiceState = ProductListServiceState
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
        controlSocketNetwork.asObservable().withUnretained(self).subscribe(onNext: {
            owner,isConnecting in
            owner.clientEncounter = true
            owner.connection?.forceCancel()
        }).disposed(by: disposeBag)
        
        startConnection()
        
    }
    func setUpdateHandler(){
        connection?.stateUpdateHandler = {
            [weak self] (state) in
            switch state {
            case .failed(_),.waiting(_),.cancelled:
                self?.timeInterval = .now()+5.0
                if (self?.clientEncounter == false){
                    self?.isSocketConnected.onNext(SocketState(socketConnect: .disconnect, error: SocketStateError.ServerEncounter))
                }else if self?.clientEncounter == true{
                    self?.isSocketConnected.onNext(SocketState(socketConnect: .disconnect, error: SocketStateError.ClientEncounter))
                }
                self?.startConnection()
            case .ready:
                self?.isSocketConnected.onNext(SocketState(socketConnect: .connect, error: nil))
                self?.connect = true
            default:
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
        connection?.receive(minimumIncompleteLength: 0, maximumLength: 1024) {
            [weak self] content, contentContext, isComplete, error in
            if content == nil,isComplete{
                print(1)
                self?.clientEncounter = false
                self?.connection?.cancel()
            }else if let content = content,!isComplete{
                print(2)
                self?.inputDataObserver.onNext(.success(content))
                self?.receive()
            }else if let error = error{
                print(3)
                self?.inputDataObserver.onNext(.failure(error))
            }
        }
    }
    private var clientEncounter:Bool = false
    private var connect:Bool = false
    private var timeInterval:DispatchWallTime = .now()
    private var repeatTime = 5.0
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
        timer?.schedule(wallDeadline: timeInterval, repeating: repeatTime)
        timer?.resume()
    }
    func sendData(data: Data, completion: @escaping (Error?) -> Void) {
        connection?.send(content: data, contentContext: .defaultMessage, isComplete: true, completion: .contentProcessed({
            error in
            completion(error)
        }))
    }
    func updateStreamServiceState(){
        if productListServiceState.isUpdated(){
            let json:Dictionary<String,Int8> = ["pageNum":productListServiceState.getServiceState()]
            let data = try! JSONSerialization.data(withJSONObject: json, options: [])
            connection?.send(content: data, contentContext: .defaultMessage, isComplete: true, completion: .contentProcessed({
                [weak self] error in
                if (error != nil){
                    self?.productListServiceState.updateStreamState()
                }
            }))
        }
    }
    deinit {
        print("NWConnection DEINIT")
    }
}
