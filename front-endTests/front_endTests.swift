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
        
        mock = ProductListRepository(ApiService: MockProductsListAPI(), StreamingService: SocketNetwork(hostName: "localhost", portNumber: 3200))
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
            print("======")
            switch result{
            case .success(_):
                break;
            case .failure(_):
                break;
            }
        })
        mock.observableSteamState().subscribe(onNext: {
            isConnecting in
            print("0000000")
            self.mock.buyProduct(output: StreamPrice(product_id: 100, product_price: 1000))
            print(isConnecting)
            promise.fulfill()
        })
//        mock.buyProduct(output: StreamPrice(product_id: 100, product_price: 1000))
        mock.requestObserver.onNext(())
        
        wait(for: [promise], timeout: 15)
        
    }
    func testRepository(){
        print("1111")
        
    }
    
}
