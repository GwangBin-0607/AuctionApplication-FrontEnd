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
    
    var mock:MockUsecase!
    override func setUpWithError() throws {
        mock = MockUsecase()
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
    class MockUsecase:StreamingProductPriceOutput,StreamingProductPriceInput{
        func connectingNetwork(state: isConnecting) {
            productPriceRepo.streamState(state: state)
        }
        
        func returningInputObservable() -> Observable<Result<[StreamPrice], Error>> {
            productPriceRepo.transferDataToPrice()
        }
        
        func returningSocketState() -> Observable<isConnecting> {
            productPriceRepo.observableSteamState()
        }
        
        
        let productPriceRepo = ProductPriceRepository(StreamingService: SocketNetwork(hostName: "ec2-13-125-247-240.ap-northeast-2.compute.amazonaws.com", portNumber: 8100))
        func sendProductPrice(ProductPrice: StreamPrice) {
            productPriceRepo.transferPriceToData(output:ProductPrice)
        }
    }
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func testSocket(){
        let promise = expectation(description: "Promise")
        mock.returningSocketState().subscribe(onNext: {
            connect in
            print("2")
        })
        mock.connectingNetwork(state: isConnecting.connect)
        mock.returningInputObservable().subscribe(onNext: {
            result in
            print("=======")
            print(result)
            promise.fulfill()
        })
        mock.sendProductPrice(ProductPrice: StreamPrice(id: 140, price: 1100))
        wait(for: [promise], timeout: 15)
        
    }
    
}
