//
//  HTTPServiceTest.swift
//  front-endTests
//
//  Created by 안광빈 on 2023/01/25.
//

import XCTest
@testable import front_end_DEBUG
@testable import RxSwift

final class HTTPServiceTest: XCTestCase {
    var httpService:GetProductsList!

    override func setUpWithError() throws {
        httpService = ProductsListHTTP(ServerURL: "http://localhost:3100/products/alllist")
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
    func test_productList(){
        let promise = expectation(description: "Http service test")
        httpService.getProductData(requestNum: 0, onComplete: {
            result in
            switch result {
            case .success(let data):
                promise.fulfill()
                XCTAssertNotNil(data)
            case .failure(let error):
                break;
            }
        })
        wait(for: [promise], timeout: 5.0)
    }

}
