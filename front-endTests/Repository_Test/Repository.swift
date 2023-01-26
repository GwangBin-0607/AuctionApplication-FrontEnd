//
//  Repository.swift
//  front-endTests
//
//  Created by 안광빈 on 2023/01/20.
//

import XCTest
@testable import front_end_DEBUG
@testable import RxSwift

final class Repository: XCTestCase {
    class MockStreamService:SocketNetworkInterface{
        var MockInputData:Data{
            let path = Bundle(for: MockStreamService.self).path(forResource: "MockInputData", ofType: "json")!
            let jsonString = try! String(contentsOfFile: path)
            let data = jsonString.data(using: .utf8)!
            return data
        }
        var controlSocketConnect: AnyObserver<isConnecting>
        
        var inputDataObservable: Observable<Result<Data, StreamError>>
        
        var isSocketConnect: Observable<isConnecting>
        
        func sendData(data: Data, completion: @escaping (StreamError?) -> Void) {
            inputDataObserver.onNext(.success(MockInputData))
        }
        private let inputDataObserver:AnyObserver<Result<Data,StreamError>>
        init(){
            let inputDataPublishSubject = PublishSubject<Result<Data,StreamError>>()
            controlSocketConnect = AnyObserver<isConnecting>(eventHandler: {
                _ in
                
            })
            inputDataObserver = inputDataPublishSubject.asObserver()
            inputDataObservable = inputDataPublishSubject.asObservable()
            isSocketConnect = Observable<isConnecting>.create({ observer in
                observer.onNext(isConnecting.connect)
                observer.onCompleted()
                return Disposables.create()
            })
            
        }
        func streamData(){
            inputDataObserver.onNext(.success(MockInputData))
        }
        
        
    }
    var mock_Stream_Infra:MockStreamService!
    var repo:ProductListRepositoryInterface!
    override func setUpWithError() throws {
        let mock_Http_Infra = MockProductsListAPI()
        mock_Stream_Infra = MockStreamService()
        let inputTransfer = InputStreamDataTransfer()
        let outputTransfer = OutputStreamDataTransfer()
        let outputHandler = OutputStreamCompletionHandler()
        let transfer = TCPStreamDataTransfer(inputStreamDataTransfer: inputTransfer, outputStreamDataTransfer: outputTransfer, outputStreamCompletionHandler: outputHandler)
        let productListState = ProductListState()
        repo = ProductListRepository(ApiService: mock_Http_Infra, StreamingService: mock_Stream_Infra, TCPStreamDataTransfer: transfer, ProductListState: productListState)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func test_MockStreamService(){
        let mock_StreamService = MockStreamService()
        let disposeBag = DisposeBag()
        let promise = expectation(description: "Status code: 200")
        mock_StreamService.inputDataObservable.subscribe(onNext: {
            result in
            switch result {
            case .success(let data):
                promise.fulfill()
                XCTAssertEqual(data, mock_StreamService.MockInputData)
            case .failure(_):
                break;
           
            }
        }).disposed(by: disposeBag)
        mock_StreamService.sendData(data: Data(), completion: {
            error in
            print(error)
        })
        wait(for: [promise], timeout: 5.0)
    }
    func test_StreamData(){
        let test = expectation(description: "Status code: 200a")
        let disposeBag = DisposeBag()
        repo.streamingList.subscribe(onNext: {
            result in
            print("=====\(result)=====")
            switch result{
            case .success(let list):
                test.fulfill()
                XCTAssertEqual(list[0].product_price, 1400)
            case .failure(let error):
                print("=====\(error)=====")
                print(error)
                break;
            }
        })
        repo.sendData(output: Data()).subscribe(onNext: {
            re in

        })

        wait(for: [test], timeout: 5.0)
    }

}
