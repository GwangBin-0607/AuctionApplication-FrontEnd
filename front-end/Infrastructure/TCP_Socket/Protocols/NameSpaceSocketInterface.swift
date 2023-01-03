//
//  NameSpaceSocket.swift
//  front-end
//
//  Created by 안광빈 on 2022/12/27.
//

import Foundation
import RxSwift
import Network

class NameSpaceSocketInterface:SocketNetworkInterface{
    let isSocketConnect: Observable<isConnecting>
    let controlSocketConnect: AnyObserver<isConnecting>
    let inputDataObservable: Observable<Result<Data,Error>>
    let connection:NWConnection
    let thread = DispatchQueue(label: "quee",qos: .background)
    let disposeBag:DisposeBag
    private let isSocketConnected:AnyObserver<isConnecting>
    private let inputDataObserver:AnyObserver<Result<Data,Error>>
    init(Host:NWEndpoint.Host,Port:NWEndpoint.Port) {
        disposeBag = DisposeBag()
        let option = NWProtocolTCP.Options()
        let parameters = NWParameters(tls: nil,tcp: option)
        let controlSocketNetwork = PublishSubject<isConnecting>()
        let connected = PublishSubject<isConnecting>()
        let inputPricing = PublishSubject<Result<Data,Error>>()
        controlSocketConnect = controlSocketNetwork.asObserver()
        isSocketConnect = connected.asObservable()
        isSocketConnected = connected.asObserver()
        inputDataObservable = inputPricing.asObservable()
        inputDataObserver = inputPricing.asObserver()
        connection = NWConnection(host: Host, port: Port, using: parameters)
        
        connection.stateUpdateHandler = {
            (state) in
            switch state {
            case .failed(let error):
                print("Failed")
                print(error)
            case .preparing:
                print("Preparing")
            case .ready:
                print("ready")
            case .setup:
                print("setup")
            case .waiting(let error):
                print("Waiting")
            case .cancelled:
                print("cancelled")
            }
            
        }
        start()
        receive()
    }
    func receive(){
        connection.receive(minimumIncompleteLength: 0, maximumLength: 1000) {
            content, contentContext, isComplete, error in
            print("---------")
            print(content)
            if error == nil{
                self.receive()
            }else{
                self.connection.cancel()
            }
            
            print(error)
            print(contentContext?.isFinal)
            if let error = error{
                self.inputDataObserver.onNext(.failure(error))
            }else if let content = content{
                self.inputDataObserver.onNext(.success(content))
            }
            //            self.receive()
            
        }
    }
    func start(){
        connection.start(queue: thread)
    }
    func sendData(data: Data, completion: @escaping (Error?) -> Void) {
        connection.send(content: data, contentContext: .defaultMessage, isComplete: true, completion: .contentProcessed({ error in
            completion(error)
            /*
             서버의 연결이 닫히고 나서도 error는 nil을 반환한다.
             예상하는 값은 error의 값이 있어야하는데
             서버가 닫히고 나서 한번은 nil이 오고
             그 다음부터는 에러메세지가 출력된다.
             이를 통한 문제점은 처음에 서버가 닫히고 값이 전달이 되지않아도
             에러가 없다고 판단되기 때문에 사용자는 값이 전달되었다고 생각한다.
             Establish -> closewait이 되는데 이를 핸들링 하는 방법을 알아야한다.
             */
        }))
    }
}
class TestRepository{
    let con = NameSpaceSocketInterface(Host: "localhost", Port: 3200)
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
