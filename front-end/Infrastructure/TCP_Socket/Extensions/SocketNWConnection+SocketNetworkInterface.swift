////
////  NameSpaceSocket.swift
////  front-end
////
////  Created by 안광빈 on 2022/12/27.
////
//
//import Foundation
//import RxSwift
//import Network
//
//final class SocketNWConnection:SocketNetworkInterface{
//
//    let isSocketConnect: Observable<isConnecting>
//    let controlSocketConnect: AnyObserver<isConnecting>
//    let inputDataObservable: Observable<Result<Data,Error>>
//
//    private var connection:NWConnection?
//    private let host:NWEndpoint.Host
//    private let port:NWEndpoint.Port
//    private let thread = DispatchQueue(label: "quee",qos: .background)
//    private let disposeBag:DisposeBag
//    private let isSocketConnected:AnyObserver<isConnecting>
//    private let inputDataObserver:AnyObserver<Result<Data,Error>>
//    init(Host:NWEndpoint.Host,Port:NWEndpoint.Port) {
//        disposeBag = DisposeBag()
//        let controlSocketNetwork = PublishSubject<isConnecting>()
//        let connected = BehaviorSubject<isConnecting>(value: .disconnect)
//        let inputPricing = PublishSubject<Result<Data,Error>>()
//        controlSocketConnect = controlSocketNetwork.asObserver()
//        isSocketConnect = connected.asObservable()
//        isSocketConnected = connected.asObserver()
//        inputDataObservable = inputPricing.asObservable()
//        inputDataObserver = inputPricing.asObserver()
//        host = Host
//        port = Port
//        controlSocketNetwork.asObservable().withUnretained(self).subscribe(onNext: {
//            owner,isConnecting in
//            if isConnecting == .disconnect{
//                owner.connection?.forceCancel()
//            }
//        }).disposed(by: disposeBag)
//
//        startConnection()
//
//    }
//    func initConnection(){
//        connection = NWConnection(host: host, port: port, using: .tcp)
//        connection?.stateUpdateHandler = {
//            [weak self] state in
//            switch state {
//            case .ready:
//                self?.isSocketConnected.onNext(.connect)
//            case .cancelled:
//                self?.isSocketConnected.onNext(.disconnect)
//                self?.startConnection()
//            default:
//                break;
//            }
//        }
//    }
//    func startConnection(){
//        initConnection()
//        receive()
//        connection?.start(queue: thread)
//    }
//    func receive(){
//        connection?.receive(minimumIncompleteLength: 0, maximumLength: 1024) {
//            [weak self] content, contentContext, isComplete, error in
//            if content == nil,isComplete{
//                print("Encounter")
//                let error = NSError(domain: "Encoutered Server", code: -1)
//                self?.inputDataObserver.onNext(.failure(error))
//                self?.connection?.cancel()
//            }else if let content = content,!isComplete{
//                print("RECEIVE")
//                self?.inputDataObserver.onNext(.success(content))
//                self?.receive()
//            }else if let error = error{
//                self?.inputDataObserver.onNext(.failure(error))
//            }
//        }
//    }
//    func sendData(data: Data, completion: @escaping (Error?) -> Void) {
//        print("Send")
//        connection?.send(content: data, contentContext: .defaultStream, isComplete: false, completion: .contentProcessed({
//            error in
//            completion(error)
//        }))
//    }
//    deinit {
//        print("NWConnection DEINIT")
//    }
//}
