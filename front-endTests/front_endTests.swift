//
//  front_endTests.swift
//  front-endTests
//
//  Created by 안광빈 on 2022/09/29.
//

import XCTest
import RxSwift
@testable import front_end_DEBUG

class front_endTests: XCTestCase {
    
    var mock:ProductListRepository!
    override func setUpWithError() throws {
        
        mock = ProductListRepository(ApiService: ProductsListHTTP(ServerURL: "localhost:3100"), StreamingService: SocketNetwork(hostName: "localhost", portNumber: 3200))
        try super.setUpWithError()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        mock = nil
        try super.tearDownWithError()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func testSocket(){
        let promise = expectation(description: "Promise")
        mock.productListObservable.subscribe(onNext: {
            result in
            switch result{
            case .success(let list):
                print(list)
            case .failure(let error):
                print(error)
            }
        })
        mock.observableSteamState().subscribe(onNext: {
            isConnecting in
            
            print(isConnecting)
        })
        mock.requestObserver.onNext(1)
        
        wait(for: [promise], timeout: 15)
        
    }
    func testRepository(){
        print("1111")
        let promise = expectation(description: "Promise")
        wait(for: [promise], timeout: 15)
        let httpService = MockProductsListAPI()
        let tcpService = Mock_TCP()
        let repo = Test_ProductListRepository(ApiService: httpService, StreamingService: tcpService)
        repo.requestObserver.onNext(1)
        repo.productListObservable.subscribe(onNext: {
            result in
            
            switch result {
            case .success(let list):
                print(list)
            case .failure(let error):
                print(error)
            case .none:
                break;
            }
        })
        
    }
    
}
